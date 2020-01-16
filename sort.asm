data segment
bufferin db 200,?,200 dup(?)
array    dw 100 dup(?)
n        db 0 
number   dw 0
loopn    dw ?
flag     db 0
filename db 'C:\input3.txt'
handle   dw ?
success1 db 'success to read file',0dh,0ah,'$'
fail1    db 'fail to read file',0dh,0ah,'$'
space    db ' ','$'
data ends
stack segment stack
        dw 100 dup(?)
stack ends
code segment
        assume cs:code,ss:stack,ds:data
start:
        mov ax,data
        mov ds,ax

        lea dx,filename;open the file 
        mov al,00h
        mov ah,3dh
        int 21h
        mov handle,ax
readfile:
        mov bx,handle
        mov cx,11;读入cx个字节先
        ;mov ch,00h
        lea dx,bufferin+2
        mov ah,3fh
        int 21h
        cmp ax,cx
        jz displayread
        lea dx,fail1
        jmp displayread
displayread:
        lea dx,success1
        mov ah,09h
        int 21h
        mov bx,handle;close the file
        mov ah,3eh
        int 21h

        ;mov cx,bufferin+1;缓冲区中实际字节数
        mov number,0

        mov cx,0
        mov ax,0
        mov bx,0
        mov dx,0
        xor si,si
        xor di,di

readbufferin:   
        cmp bufferin+2[si],'$'
        jz  transend
        cmp bufferin+2[si],','
        jz  nextnum
        cmp bufferin+2[si],'-'
        jz  nagative


positive:
        mov bl,bufferin+2[si]
        add bl,-48
        mov bh,00h
        mov ax,10
        mul number
        mov number,ax
        add number,bx
        mov ax,0
        mov bx,0
        inc si
        jmp readbufferin

nagative:
        ;inc si
        ;mov bl,bufferin+2[si]
        ;add bl,-48
        ;mov bh,00h
        ;mov ax,10
        ;mul number
        ;mov number,ax
        ;add number,bx

        ;mov ax,0
      
        inc si
        ;cmp bufferin+2[si],','
        ;jz  opposite
        mov flag,1
        ;jmp readbufferin
;opposite:
        ;mov ax,number
        ;mov bx,0
        ;sub bx,ax
        ;mov number,bx       
        jmp readbufferin
nextnum:
        inc n
        mov cx,number
        mov ax,cx
        ;cmp flag,1
        ;jz opposite
        ;mov cx,0
        
        mov number,0
        inc si
        cmp flag,1
        jz opposite
        mov array[di],cx
        add di,2
        jmp readbufferin
opposite:
        mov cx,0
        sub cx,ax
        mov array[di],cx
        ;mov cx,0
        add di,2
        mov flag,0
        jmp readbufferin

transend:
        mov ax,0
        mov bx,0
        mov si,0
        mov dl,n
        add dl,48     ;输出读取了几个数字
        mov ah,02h
        int 21h
        mov dl,0ah
        int 21h

        mov dx,0
        mov ax,0
        mov cx,0
        mov bx,0
        mov di,0
        mov si,0

        mov cl,n
        mov ch,00h
        add cx,cx
        add cx,-2
        mov loopn,cx
        mov cx,0
loop1:
        cmp si,loopn;i=0;i<2n-2;i+=2
        jae loop1out;>= jump
        ;add si,2
        mov di,0
        mov ax,0
        mov bx,0
loop2:
        mov cx,loopn
        sub cx,si
        cmp di,cx;j=0;j<2n-2-i;j+=2
        jae loop2out
        mov cx,0
        mov ax,array[di]
        mov bx,array+2[di]
        cmp ax,bx;a[j]>a[j+1],exchange a[j] with a[j+1]
        jg change
        add di,2
        jmp loop2
change:
        mov array[di],bx
        mov array+2[di],ax
        add di,2
        mov ax,0
        mov bx,0
        jmp loop2

loop2out:
        add si,2
        jmp loop1
loop1out:
        mov ax,0
        mov cx,0
        mov bx,0
        mov dx,0
        mov si,0
        mov di,0
        mov number,0

printloop:
       mov dl,0ah
       mov ah,02h
       int 21h
       mov dx,0
       mov ax,0
       cmp si,loopn
       ja  printloopout
       mov cx,array[si]
       mov ax,cx
       add si,2
       mov di,1
       cmp cx,0
       jge  tranto10;>=0
nagativeprint:
       mov dl,'-'
       mov ah,02h
       int 21h
       mov ax,0
       sub ax,cx
       
tranto10:
       mov dx,0
       
       
       mov bx,10
       div bx;(dx)(ax)/10
       push dx;dx为模,ax为商
       mov dx,0
       cmp ax,0
       jz print
       inc di
       jmp tranto10

print:
       cmp di,0
       jz printloop
       pop ax
       mov dl,al
       add dl,48
       mov ah,02h
       int 21h
       dec di
       jmp print

printloopout:
       mov ah,4ch
       int 21h

code ends
     end start







         

