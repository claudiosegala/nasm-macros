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
  ;   ; declaration
  ;   for
  ;     ; comparation
  ;   for_loop ae
  ;     ; do stuff
  ;   for_inc
  ;     ; inc
  ;   for_end


  %macro for 0
    %push for                                          ; Put the context on stack
    %$FOR:                                             ; Label used to repeat the loop
  %endmacro

  %macro for_loop 1
    %ifctx for                                         ; Enters if a for was declared before
      %repl   for_loop                                 ; Rename the current context to for_loop (to avoid error)
      j%+1  %$FOR_END                                  ; Will jump to ending for if the comparison (argument) is false
    %else                                              ; Enters if a for wasn't declared before
      %error  "expected `for' before `for_loop'"       ; Emit error explaining
    %endif                                             ; End if
  %endmacro

  ; do nothing, used just to separate
  %macro for_inc 0
    %ifctx for_loop                                    ; Enters if a for_loop was declared before
      %repl   for_inc                                  ; Rename the current context to for_inc (to avoid error)
      jmp %$FOR                                        ; Return to the begining to start the comparison
    %else                                              ; Enters if a for wasn't declared before
      %error  "expected `for_loop' before `for_inc'"   ; Emit error explaining
    %endif                                             ; End if
  %endmacro

  ; end for
  %macro for_end 0
    %ifctx for_loop
          %$FOR_END:
          %pop
    %elifctx  for_inc
          %$FOR_END:
          %pop
    %else
          %error  "expected `for_inc' or `else' before `for_end'"
    %endif
  %endmacro

section .data
  msg1 db 'Declared!',0xA,0xD
  len1 equ $ - msg1

  msg2 db 'Compared!', 0xA,0xD
  len2 equ $- msg2

  msg3 db 'Loop!', 0xA,0xD
  len3 equ $- msg3

  msg4 db 'Incremented!', 0xA, 0xD
  len4 equ $- msg4

  msg5 db 'Done!', 0xA, 0xD
  len5 equ $- msg5

section .text
   global _start            ;must be declared for using gcc

_start:
  mov eax, 0
  mov ebx, 3
  write_string msg1, len1
  for
    write_string msg2, len2
    cmp eax, ebx
  for_loop ae
    ; do stuff
    ; write_string msg3, len3
  for_inc
    inc ax
    write_string msg4, len4
  for_end

  write_string msg5, len5

  exit
