  ; A macro for exiting
  %macro exit 0
    mov eax,1    ;system call number (sys_exit)
    int  0x80     ;call kernel
  %endmacro

  ; A macro with two parameters
  ; Implements the write system call
  %macro write_string 2
    push eax
    push ebx
    push ecx
    push edx
  
    mov   eax, 4
    mov   ebx, 1
    mov   ecx, %1
    mov   edx, %2
    int   80h
    
    pop eax
    pop ebx
    pop ecx
    pop edx
  %endmacro

  ; How to used it:
  ;   _do
  ;     ; stuff
  		; comparation
  ;   _while ae

  ; given declarations, make the comparison
  %macro _do 0  
    %push _do                                          ; Put the context on stack
    %$DO:                                              ; Label used to repeat the loop
  %endmacro

  ; end for
  %macro _while 1
    %ifctx _do 
      j%1 %$DO                                        ; Return to the begining to start the comparison
    %else 
          %error  "expected `_do' or `else' before `_while'" 
    %endif 
  %endmacro

section .data
  msg3 db 'Loop!', 0xA,0xD
  len3 equ $- msg3

  msg5 db 'Done!', 0xA, 0xD
  len5 equ $- msg5

section .text
   global _start            ;must be declared for using gcc

_start:

  mov eax, 0
  mov ebx, 3
  
  _do 
    write_string msg3, len3
    inc eax
    cmp eax, ebx
  _while ae

  write_string msg5, len5

  exit