data segment
n       db 3,?,?
array   db 100 dup(?)
space   db ' ','$'

data ends
stack segment stack
        db 100 dup(?)
stack ends
code segment
        assume cs:code,ss:stack,ds:data
start:
        mov ax,data
        mov ds,ax
        
        lea dx,n
        mov ah,0ah
        int 21h

        mov dl,n+2
        mov ah,02h
        int 21h
        add dl,-48
        mov n+2,dl

        mov al,n+2
        ;add al,-48
        mov ah,00h
        mov cx,ax       ;循环次数
        ;mov dl,al      ;dl保存n的值
        ;mov dh,00h   
        xor dx,dx
        xor di,di      ;dl为计数器
        xor bx,bx      ;基址
inicol:        
        xor si,si      ;变址

save:   
        cmp si,ax
        jz nextrow
        push bx
        inc dl
        mul bl
        mov bl,al
        mov al,n+2
        ;add al,-48
        mov ah,00h
        mov array[bx+si],dl
        pop bx
        mov bh,00h
        inc si
        jmp save
nextrow:
        inc bl
        cmp bl,al
        jz print
        loop inicol ;
print:
        mov dl,0ah
        mov ah,02h
        int 21h
        mov ax,n+2
        mov ah,00h
        mov di,0
        add di,ax
        mov ax,0
        mov cx,0
        mov si,0

loopout:
        cmp cx,di
        jz endout
        xor si,si
loopin:
        cmp si,di
        jz endin

        cmp si,cx
        ja endin
        mov ax,cx
        mul n+2
        mov bx,ax
        mov al,array[bx+si];al to be print
        mov dl,10
        div dl

        mov dl,al
        add dl,48
        push ax
        mov ah,02h
        int 21h
        pop ax

        mov dl,ah
        add dl,48
        mov ah,02h
        int 21h

        mov dl,space
        int 21h

        inc si
        jmp loopin
endin:
        mov dl,0ah
        int 21h

        inc cx
        jmp loopout
endout: 
        
        mov ah,4ch
        int 21h
     
code ends
        end start
