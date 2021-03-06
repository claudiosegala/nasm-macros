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
  ;  _while
  ;   ; comparation
  ;  _loop ae
  ;   ; do stuff
  ;  _end

  ; given declarations, make the comparison
  %macro _while 0
    %push _while                                          ; Put the context on stack
    %$WHILE:                                             ; Label used to repeat the loop
  %endmacro

  ; given the result of a comparison, decides if do stuff or end for
  %macro _loop 1
    %ifctx _while                                         ; Enters if a _while was declared before
      %repl  _loop                                        ; rename context to _loop
      j%+1  %$END                                          ; Will jump to ending for if the comparison (argument) is false
    %else
      %error  "expected `_while' before `_loop'"
    %endif
  %endmacro

  ; do nothing, used just to separate
  %macro _end 0
    %ifctx _loop                                       ; Enters if a for_loop was declared before
      jmp %$WHILE                                      ; jump to begining
      %$END:                                           ; label to end program
      %pop
    %else
      %error  "expected `_loop' before `_end'"
    %endif
  %endmacro

section .data
  msg2 db 'Compared!', 0xA,0xD
  len2 equ $- msg2

  msg3 db 'Loop!', 0xA,0xD
  len3 equ $- msg3

  msg5 db 'Done!', 0xA, 0xD
  len5 equ $- msg5

section .text
   global _start            ;must be declared for using gcc

_start:
  mov eax, 0
  mov ebx, 5

  _while
  	cmp eax, ebx
  	write_string msg2, len2
  _loop ae
  	write_string msg3, len3
    inc eax
  _end

  write_string msg5, len5


  exit
