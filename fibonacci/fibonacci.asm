%include "asm_io.inc"

section .data
    msg1 db "Insira um número: ",0
    newline  db "", 0xa, 0

section .bss

section .text
    global main
main:
    mov EBX,0           ; zera o register
    mov eax, msg1       ; prepara para imprimir a mensagem do syscall
    call print_string   ; printa mensagem
    call read_int       ; le na tela o valor do n-esimo numero
    mov EBX, eax        ; armazena no registrador
    mov EDX,EBX         ; guarda no registrador
    cmp EBX,1           ; compara com 1 para iniciar as operacoes
    jge loop            ; se maior, vai para o primeiro loop
    jmp main            ; se nao, volta pra main e imprime 1, o primeiro termo
loop:
    xor  eax,eax        ; evita lixo de memoria em eax colocando zero
    call fibonacci_init  ; primeiro loop
    call print_int       ; printa o numero
    mov eax, newline
    call print_string
    ret

fibonacci_init:
    cmp  EBX,2    ; compara o register ao 2 para manter ou não no fibonacci_init
    jg   fibonacci_continue   ; se não for maior que 2, vai pro continue
    inc  eax      ; fibo 1 e 2 igual a 1
    ret
fibonacci_continue:
    dec  EBX      ; ebx = ebx-1
    call fibonacci_init     ; soma = soma + fib(n-1)
    dec  EBX      ;
    call fibonacci_init     ; soma = soma + fib(n-2)
    add  EBX,2    ; volta o register pra continuar a operacao
    ret
