%macro if 1
  %push if
  j%-1  %$ifnot
%endmacro

%macro else 0
  %repl   else
  jmp     %$ifend
  %$ifnot:
%endmacro

%macro endif 0
  %$ifnot:
  %pop
  %$ifend:
  %pop
%endmacro
