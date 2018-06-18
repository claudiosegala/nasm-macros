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
;   _switch
;     ;comparation
;     _case ae
;       ;do stuff
;     _break
;   _switch

; given declarations, make the comparison
%macro _switch 0
  %push _switch                                          ; Put the context on stack
  ; %$FOR:                                             ; Label used to repeat the loop
%endmacro

; given the result of a comparison, decides if do stuff or end for
%macro _case 1
  %ifctx _switch                                         ; Enters if a for was declared before
    %repl _case                                 ; Rename the current context to for_loop (to avoid error)
    j%-1  %$BREAK                                  ; Will jump to ending for if the comparison (argument) is false
  %elifctx _break
    %repl _case                                 ; Rename the current context to for_loop (to avoid error)
    j%-1  %$BREAK
  %else
    %error  "expected `_switch' or `_break' before `case'"       ; Emit error explaining
  %endif                                             ; End if
%endmacro

%macro _break 0
  %ifctx _case
    %repl _break
    %$BREAK:
  %else
    %error  "expected `case' before `_break'"
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

_switch
  cmp eax,ebx
  _case ae
    write_string msg1, len1
  _break
  cmp ebx,ebx
  _case ae
    write_string msg2, len2
  _break

exit
