section .text
global _start

%include "library.s"

_start:
    mov rdi, prompt
    call print
    call getInput
    mov rsi, rax
    mov rdi, msg
    call printf
    mov rdi, rsi
    call free

    xor rdi, rdi
    jmp exit

section .data
    prompt: db "What is your name: ", 0
    msg: db "Nice to meet you %s!", 10, 0
