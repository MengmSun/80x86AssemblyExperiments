data segment
bufferin      db 5,?,5 dup(?);输入
bufferout     db 20 dup(0);输出
n      db ?
funcn  dw ?;求得的阶乘
data ends
stack segment para stack 'stack'
       dw 64 dup(?)
stack ends
code segment
       assume cs:code,ss:stack,ds:data
main proc far
start:
       mov ax,data
       mov ds,ax
       
       lea dx,bufferin
       mov ah,0ah
       int 21h
       
       mov ah,0
       mov al,bufferin+1
       cmp ax,1
       jz  next
turn:  
       mov al,10
       add al,bufferin+3
       sub al,48
       mov n,al
       jmp compute

next:
       mov al,bufferin+2
       sub al,48
       mov n,al
compute:
       push cx
       mov ah,0
       mov al,n
       call factor
       ;mov funcn,ax
       pop cx

       mov si,19

print:
       cmp si,-1
       jz printend
       mov dl,bufferout[si]
       add dl,48
       mov ah,02h
       int 21h
       dec si
       jmp print

       
printend:
       mov ah,4ch
       int 21h

       ret
main endp
factor proc near
       push ax
       sub al,1
       jne again
       mov si,0
       pop ax
       mov bufferout,al
       jmp fin
again:
       call factor
       pop cx
       mov si,0
loop1:
       ;判断si,将bufferout数组中每一个数字和cl相乘
       cmp si,20
       jz  carry
       mov al,bufferout[si]
       mul cl;结果存放在al中
       mov bufferout[si],al
       inc si
       jmp loop1
carry:
       mov si,0
loop2:
       ;进位
       cmp si,20
       jz fin
       mov al,bufferout[si]
       mov bl,10;al商ah余数
       div bl
       mov bufferout[si],ah
       add bufferout+1[si],al
       mov ah,0
       inc si
       jmp loop2

fin:
       ret

factor endp
code ends
       end start
       


