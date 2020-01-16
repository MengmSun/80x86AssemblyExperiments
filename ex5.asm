data segment
;numerr      db  'no operand for operator',0dh,0ah,'$'
;synerr      db  'unmatched parenthese',0dh,0ah,'$'
;oprerr      db  'wrong operator',0dh,0ah,'$'
unknownerr  db  'unknown input',0dh,0ah,'$'
buffer      db  1024 dup(?)
data ends
stack segment para stack 'stack'
      dw 64 dup(0)
stack ends
code segment
      assume cs:code,ss:stack,ds:data
main proc far
start:
      mov ax,data
      mov ds,ax

      xor si,si
      xor ax,ax
      call readExpr
      dec si
      xor bx,bx
      xor cx,cx
      call calStk
      ;pop ax
      xor di,di

 tranto10:
       mov dx,0
             
       mov bx,10
       inc di
       div bx;(dx)(ax)/10
       push dx;dx为模,ax为商
       mov dx,0
       cmp ax,0
       jz print
       
       jmp tranto10

print:
       ;cmp di,0
       ;jz printloop
       pop ax
       mov dl,al
       add dl,48
       mov ah,02h
       int 21h
       dec di
       cmp di,0
       jne print
            
      jmp quit


main endp
calStk proc
      push bx
      push cx
      cmp buffer[si],'-'
      je eval
      cmp buffer[si],'+'
      je eval
      xor ah,ah
      mov al,buffer[si]
      dec si
      jmp calquit
eval:
      mov cl,buffer[si]
      dec si
      call calStk
      mov bx,ax
      call calStk
      cmp cl,'+'
      je plus
      sub ax,bx
      jmp calquit
plus:
      add ax,bx
calquit:
      pop cx
      pop bx
      ;push ax
      ret

calStk endp


readExpr proc 

      push bx
      push dx
      xor bx,bx
      xor dx,dx

read:
      call getChar
compare:
      cmp al,13
      je check
      cmp al,')'
      je check
      cmp al,'('
      je newExpr
      cmp al,'+'
      je opr
      cmp al,'-'
      je opr
      cmp al,'0'
      jl unknown
      cmp al,'9'
      jg unknown
      sub al,'0'
      jmp readNum

readNum:
      mov cl,al
      mov al,bl
      xor ah,ah
      mov ch,10
      mul ch
      mov bl,al
      add bl,cl
      mov dl,1
      call getChar
      jmp compare

opr:
      test dl,dl
      jz noNum
      xor dl,dl
      mov buffer[si],bl
      inc si
      xor bl,bl
noNum:
      test bh,bh
      jz noOpr
      mov buffer[si],bh
      inc si
noOpr:
      mov bh,al
      jmp read

newExpr:
      call readExpr
      cmp al,')'
      jne synErr
      test bh,bh
      jz read
      mov buffer[si],bh
      inc si
      xor bx,bx
      jmp read

numErr:
      
      jmp quit
synErr:
      
      jmp quit
oprErr:
      
      jmp quit

unknown:
      push dx
      push ax
      lea dx,unknownerr
      mov ah,09h
      int 21h
      pop ax
      pop dx
      jmp quit

check:
      test dl,dl
      jz finish
      mov buffer[si],bl
      inc si
      test bh,bh
      jz finish
      mov buffer[si],bh
      inc si
finish:
      pop dx
      pop bx
      ret
readExpr endp

getChar proc
      mov ah,1
      int 21h
      ret
getChar endp

quit:
     mov ah,4ch
     int 21h
     ret
code ends
     end start


      