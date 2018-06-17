%macro for_loop 1 

    %push for_loop 
    j%-1  %$ifnot 
    
%endmacro 

%macro else 0 

  %ifctx if 
        %repl   else 
        jmp     %$ifend 
        %$ifnot: 
  %else 
        %error  "expected `if' before `else'" 
  %endif 

%endmacro 

%macro endif 0 

  %ifctx if 
        %$ifnot: 
        %pop 
  %elifctx      else 
        %$ifend: 
        %pop 
  %else 
        %error  "expected `if' or `else' before `endif'" 
  %endif 

%endmacro