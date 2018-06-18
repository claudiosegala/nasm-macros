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

; This switch does not have fall through
; How to used it:
;   ; declaration
;   _switch eax
;     ;comparation

;     _case ae
;       ;do stuff

;     _default
;       ;do stuff
;   _end

%macro _switch 1
  %push _switch                                                ; Put context in stack
  %define value %1                                             ; Save the value that should be compared
  %assign %$n 1                                                ; Assign variable to change labels
  jmp case_ %+ %$n                                             ; Jump to first case
%endmacro

%macro _case 1
  %ifctx _switch                                               ; Enters if a switch was declared before
    jmp %$END                                                  ; No fall through, once inside, switch should end
    case_ %+ %$n:                                              ; Define a variable label
      %assign %$n %$n+1                                        ; Assing the next
      cmp value, %1                                            ; If false, go to the next case
      jne case_ %+ %$n                                         ; If not equal, go to next case  
  %else                                                        ; Enters if a switch was NOT declared before
    %error  "expected `_switch' before `case'"                 ; Emit error explaining
  %endif                                                       ; End if context
%endmacro

%macro _default 0
  %ifctx _switch                                               ; Enters if a switch was declared before
    jmp %$END                                                  ; No fall through, once inside, switch should end
    case_ %+ %$n:                                              ; Define a variable label
      %assign %$n %$n+1                                        ; Assing the next
  %else                                                        ; Enters if a switch was NOT declared before
    %error  "expected `_switch' or `_break' before `case'"     ; Emit error explaining
  %endif                                                       ; End if context
%endmacro

%macro _end 0
  %ifctx _switch                                               ; Enters if a switch was declared before
    case_ %+ %$n:                                              ; Define a variable label
    %$END:                                                     ; Label the end of the switch
    %pop
  %else                                                        ; Enters if a switch was declared before
    %error  "expected `_switch' or `_break' before `_end'"     ; Emit error explaining
  %endif                                                       ; End if
%endmacro

section .data
  msg1 db 'Entered in case1!',0xA,0xD
  len1 equ $ - msg1

  msg2 db 'Entered in default!', 0xA,0xD
  len2 equ $- msg2

  msg3 db 'Done!', 0xA,0xD
  len3 equ $- msg3

  msg4 db 'Entered in case2!',0xA,0xD
  len4 equ $ - msg4


section .text
 global _start            ;must be declared for using gcc

_start:
  mov ebx, 0
  mov ecx, 3
  mov edx, 0

  _switch ebx  
    _case ecx
      write_string msg1, len1

    _case edx
      write_string msg4, len4

    _default
      write_string msg2, len2
  _end

  write_string msg3, len3
  exit
