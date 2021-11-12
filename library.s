%ifndef STANDARD_LIBRARY_ASM
%define STANDARD_LIBRARY_ASM

section .data
    hexstr: db "0x????????", 0h
    hex: db "0123456789ABCDEF", 0h
    endline: db 0xA, 0x0
    error: db "Exit with error", 0xA, 0h
    mem_start: dq 0
    mem_end: dq 0

section .text

global printf
global printlen
global print
global printHex
global printNum
global newline
global getInput
global stoi
global strfind
global strlen
global strcmp
global strcat
global strcopy
global memcopy
global memlen
global alloc
global free
global pow
global sleep
global exit

exit:
    mov rax, 60
    syscall
    hlt

getArg:
    cmp rdi, 0
    jne .case1
    xor rax, rax
    jmp .end
    .case1:
        cmp rdi, 1
        jne .case2
        mov rax, rsi
        jmp .end
    .case2:
        cmp rdi, 2
        jne .case3
        mov rax, rdx
        jmp .end
    .case3:
        cmp rdi, 3
        jne .case4
        mov rax, rcx
        jmp .end
    .case4:
        cmp rdi, 4
        jne .case5
        mov rax, r8
        jmp .end
    .case5:
        cmp rdi, 5
        jne .fail
        mov rax, r9
        jmp .end
    .fail:
        mov rax, ~0
    .end:
        ret

printf:
    push rax
    sub rsp, 1
    mov byte [rsp], 1
    push rsi
    push rdi
    jmp .header
    .loop:
        mov rsi, rax
        call printlen
        add [rsp], rax
        mov rdi, [rsp]
        cmp [rdi+1], byte 's'
        jne .caseN
        xor rdi, rdi
        mov dil, [rsp+16]
        mov rsi, [rsp+8]
        call getArg
        mov rdi, rax
        call print
        inc byte [rsp+16]
        add qword [rsp], 2
        jmp .header
        .caseN:
            cmp [rdi+1], byte 'n'
            jne .caseH
            xor rdi, rdi
            mov dil, [rsp+16]
            mov rsi, [rsp+8]
            call getArg
            mov rdi, rax
            call printNum
            inc byte [rsp+16]
            add qword [rsp], 2
            jmp .header
        .caseH:
            cmp [rdi+1], byte 'h'
            jne .fail
            xor rdi, rdi
            mov dil, [rsp+16]
            mov rsi, [rsp+8]
            call getArg
            mov rdi, rax
            call printHex
            inc byte [rsp+16]
            add qword [rsp], 2
            jmp .header
        .fail:
            mov rsi, 1
            call printlen
            inc qword [rsp]
    .header:
        mov rdi, [rsp]
        mov rsi, '%'
        call strfind
        cmp rax, ~0
        je .flush
        jmp .loop
    .flush:
        call print
    .end:
        pop rdi
        pop rsi
        add rsp, 1
        pop rax
        ret

printlen:
    push rdi
    push rax
    push rdx
    push rsi
    push rcx
    mov rdx, rsi
    mov rsi, rdi
    mov rax, 1
    mov rdi, 1
    syscall
    pop rcx
    pop rsi
    pop rdx
    pop rax
    pop rdi
    ret

print:
    push rdi
    push rsi
    push rax
    call strlen
    mov rsi, rax
    call printlen
    pop rax
    pop rsi
    pop rdi
    ret

newline:
    push rdi
    push rsi
    mov rdi, endline
    mov rsi, 1
    call printlen
    pop rsi
    pop rdi
    ret

printHex:
    push rdi
    push rdx
    push rax
    push rcx
    mov rax, rdi
    mov rcx, 16
    mov rdi, 9
    jmp .header
    .loop:
        xor rdx, rdx
        div rcx
        mov dl, [hex + rdx]
        mov [hexstr + rdi], dl
        dec rdi
    .header:
        cmp rdi, 2
        jge .loop
    .end:
        mov rdi, hexstr
        call print
        pop rcx
        pop rax
        pop rdx
        pop rdi
        ret

printNum:
    push rdi
    push rdx
    push rax
    push rcx
    push rbx
    mov rbx, hexstr + 5
    mov rax, rdi
    mov rcx, 10
    mov rdi, 4
    jmp .header
    .loop:
        xor rdx, rdx
        div rcx
        add rdx, '0'
        add rbx, rdi
        mov [rbx], dl
        sub rbx, rdi
        dec rdi
    .header:
        cmp rdi, 0
        jge .loop
    mov rdi, hexstr + 5
    mov rbx, hex - 2
    jmp .check
    .skip:
        inc rdi
    .check:
        cmp rdi, rbx
        je .end
        cmp [rdi], byte '0'
        je .skip
    .end:
        call print
        pop rbx
        pop rcx
        pop rax
        pop rdx
        pop rdi
        ret

getInput:
    push rdi
    push rsi
    push rdx
    push rcx
    sub rsp, 100
    xor rax, rax
    xor rdi, rdi
    mov rsi, rsp
    mov rdx, 101
    syscall
    jmp .header
    .loop:
        inc rsi
    .header:
        cmp [rsi], byte 0h
        je .next
        cmp [rsi], byte 0xA
        jne .loop
        mov [rsi], byte 0h
    .next:
        mov rdi, rsp
        call strlen
        inc rax
        mov rdi, rax
        call alloc
        mov rdi, rax
        mov rsi, rsp
        call strcopy
        add rsp, 100
    .end:
        pop rcx
        pop rdx
        pop rsi
        pop rdi
        ret

pow:
    push rdx
    push rsi
    xor rax, rax
    cmp rsi, 0
    je .end
    inc rax
    jmp .header
    .loop:
        mul rdi
        dec rsi
    .header:
        cmp rsi, 0
        jne .loop
    .end:
        pop rsi
        pop rdx
        ret

val:
    cmp dil, '0'
    jl .elseif
    cmp dil, '9'
    jg .elseif
    sub dil, '0'
    jmp .end
    .elseif:
        cmp dil, 'A'
        jl .else
        cmp dil, 'Z'
        jg .else
        sub dil, 'A' - 10
        jmp .end
    .else:
        cmp dil, 'a'
        jl .end
        cmp dil, 'z'
        jg .end
        sub dil, 'a' - 10
    .end:
        ret

stoi:
    push rbx
    push rsi
    push rcx
    push rdx
    push rdi
    sub rsp, 1
    mov [rsp], sil
    cmp rsi, 16
    jne .eval
    cmp [rdi+1], byte 'x'
    jne .eval
    add rdi, 2
    .eval:
    mov rcx, rdi
    xor rdx, rdx
    call strlen
    mov rbx, rax
    dec rbx
    add rcx, rbx
    mov rsi, 1
    jmp .header
    .loop:
        xor rdi, rdi
        mov dil, [rsp]
        call pow
        mov dil, [rcx]
        call val
        push rdx
        mul rdi
        pop rdx
        add rdx, rax
        dec rcx
        inc rsi
        dec rbx
    .header:
        cmp rbx, 0
        jge .loop
    .end:
        xor rdi, rdi
        mov dil, [rsp]
        mov rax, rdx
        xor rdx, rdx
        div rdi
        add rsp, 1
        pop rdi
        pop rdx
        pop rcx
        pop rsi
        pop rbx
        ret

strlen:
    push rdi
    xor rax, rax
    jmp .header
    .loop:
        inc rdi
        inc rax
    .header:
        cmp [rdi], byte 0
        jne .loop
    pop rdi
    ret

strfind:
    push rdi
    push rsi
    xor rax, rax
    jmp .header
    .loop:
        inc rdi
        inc rax
    .header:
        cmp [rdi], byte 0h
        je .fail
        cmp [rdi], sil
        je .end
        jmp .loop
    .fail:
        mov rax, -1
    .end:
        pop rsi
        pop rdi
        ret

strcat:
    push rdi
    push rsi
    push rdx
    push rcx
    push rbx
    call strlen
    mov rcx, rax
    mov rbx, rax
    mov rdx, rdi
    mov rdi, rsi
    call strlen
    add rcx, rax
    inc rcx
    mov rdi, rcx
    call alloc
    mov rdi, rax
    mov rcx, rsi
    mov rsi, rdx
    call strcopy
    add rdi, rbx
    mov rsi, rcx
    call strcopy
    pop rbx
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    ret

strcmp:
    push rdi
    push rsi
    jmp .header
    .loop:
        inc rdi
        inc rsi
    .header:
        mov al, [rsi]
        cmp [rdi], al
        jne .false
        cmp [rdi], byte 0h
        je .true
        jmp .loop
    .true:
        mov rax, -1
        jmp .end
    .false:
        xor rax, rax
    .end:
        pop rsi
        pop rdi
        ret

strcopy:
    push rdi
    push rsi
    push rax
    jmp .header
    .loop:
        mov al, [rsi]
        mov [rdi], al
        inc rdi
        inc rsi
    .header:
        cmp [rsi], byte 0
        je .end
        jmp .loop
    .end:
        pop rax
        pop rdi
        pop rdi
        ret

memcopy:
    push rdi
    push rsi
    .loop:
        mov [rdi], dl
        inc rdi
        dec rsi
    .header:
        cmp rsi, 0
        jg .loop
    .end:
        pop rsi
        pop rdi
        ret

memlen:
    push rdi
    xor rax, rax
    jmp .header
    .loop:
        inc rax
        inc rdi
    .header:
        cmp rdi, [mem_end]
        je .end
        cmp [rdi], word 0
        je .loop
    .end:
        pop rdi
        ret

alloc:
    push rdi
    push rsi
    push rdx
    push rbx
    push rcx
    mov rdx, rdi
    add rdx, 2
    cmp qword [mem_start], 0
    jne .find
    .init:
        mov rax, 12
        xor rdi, rdi
        syscall
        mov [mem_start], rax
        mov rdi, rax
        add rdi, 5120
        mov rax, 12
        syscall
        mov [mem_end], rax
        mov rdi, [mem_start]
    .find:
        mov rdi, [mem_start]
        .do:
            call memlen
        .while:
            cmp rdx, rax
            jle .researve
            cmp [rdi], word 0
            je .expand
            add di, word [rdi]
            inc rdi
            jmp .do
    .expand:
        mov rbx, rdi
        sub rdx, rax
        mov rdi, [mem_end]
        add rdi, rdx
        mov rax, 12
        syscall
        mov [mem_end], rax
        mov rdi, rbx
    .researve:
        mov [rdi], dx
        mov rax, rdi
        add rax, 2
    .exit:
        pop rcx
        pop rbx
        pop rdx
        pop rsi
        pop rdi
        ret

free:
    push rdi
    push rdx
    push rsi
    xor rsi, rsi
    sub rdi, 2
    mov si, word [rdi]
    mov dl, 0
    call memcopy
    pop rsi
    pop rdx
    pop rdi
    ret

sleep:
    push rsi
    xor rsi, rsi
    sub rsp, 16
    mov qword [rsp], rdi
    mov qword [rsp + 8], rsi
    mov rdi, rsp
    mov rax, 35
    syscall
    add rsp, 16
    pop rsi
    ret

%endif
