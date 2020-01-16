DSEG SEGMENT
   ENDL db 10,'$'
   DISP1 db 'INPUT A STRING:','$'
   DISP2 db 10,'YOUR STRING IS:','$'
   DISP3 db 10,'file has be written', '$'
   DISP4 db 10,'file has be read:', '$'
   STRING db 60 ;定义写入字符串长度
      db ? ;预留实际输入字符个数的技术单元
      db 60 DUP('$') ;设DS已是段基址(?)
   BUFFER db 60 ;同上
      db ?
      db 60 DUP('$')
   INPUT_FILE db 'C:\INPUT1.txt', 0  ;输入文件名
   OUTPUT_FILE db 'C:\OUTPUT1.txt', 0   ;输出文件名
   FILECODE dw ?  ;定义文件句柄(?)
DSEG ENDS
CSEG SEGMENT
assume cs:CSEG, ds:DSEG
MAIN PROC FAR
   mov ax, dseg
   mov ds, ax

   lea dx, DISP1
   mov ah,9h ;打印
   int 21h

   lea dx, STRING
   mov ah,0ah ;输入
   int 21h

   lea dx, DISP2
   mov ah,9h ;打印
   int 21h
   lea dx, STRING + 2 ;字符串开始
   int 21h

   mov ah, 3dh ;打开文件
   lea dx, INPUT_FILE ;ds:dx指向文件名首地址,文件名以00H结尾
   mov al, 1 ;写
   int 21h
   mov FILECODE, ax  ;返回的文件句柄存入内存

   mov ah, 40h ;文件写
   mov bx, FILECODE ;文件句柄
   xor ch, ch
   mov cl, STRING + 1 ;写入字节个数
   lea dx, STRING + 2 ;ds:ds指向的串将写入文件
   int 21h

   mov ah, 3eh ;关闭文件
   mov bx, FILECODE
   int 21h

   mov ah, 9h ;打印
   lea dx, DISP3
   int 21h

   mov ah, 3dh ;打开文件
   lea dx, INPUT_FILE
   mov al, 0 ;读
   int 21h
   mov FILECODE, ax

   mov ah, 3fh ;文件读
   mov bx, FILECODE
   xor ch, ch
   mov cl, STRING + 1
   lea dx, BUFFER + 2
   int 21h

   mov ah, 3eh ;关闭文件
   mov bx, FILECODE
   int 21h

   xor ch, ch
   mov cl, STRING + 1
   lea bx, BUFFER + 2
   add bx, -1
L1:
   add bx, 1
   mov dl, [bx] ;取一个字符

   ;mov ah, 2h ;打印取出的字符
   ;int 21h

   cmp dl, 61h
   jb S ;小于'a'
   cmp dl, 7ah
   ja S ;大于'z'
   and dl, 11011111b ;小写转大写
   mov [bx], dl
S:
   loop L1

   ;debug
   mov ah, 9h ;打印
   lea dx, ENDL
   int 21h
   lea dx, BUFFER + 2
   int 21h
   ;

   mov ah, 3dh ;打开文件
   lea dx, OUTPUT_FILE ;ds:dx指向文件名首地址,文件名以00H结尾
   mov al, 1 ;写
   int 21h
   mov FILECODE, ax  ;返回的文件句柄存入内存

   mov ah, 40h ;文件写
   mov bx, FILECODE ;文件句柄
   xor ch, ch
   mov cl, STRING + 1 ;写入字节个数
   lea dx, BUFFER + 2 ;ds:ds指向的串将写入文件
   int 21h

   mov ah, 3eh ;关闭文件
   mov bx, FILECODE
   int 21h

   mov ax, 4c00h
   int 21h
MAIN ENDP
CSEG ENDS
END MAIN