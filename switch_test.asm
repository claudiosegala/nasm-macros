%macro switch 1
  %push switch
  %define arg %1
%endmacro

%macro case 1
  cmp %1, arg
  jne %$end_case
%endmacro

%macro end_case
  %$end_case:
    %pop
%endmacro
