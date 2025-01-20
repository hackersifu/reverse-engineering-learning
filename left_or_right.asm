section .data
    msg db "Left or Right?", 0xA, 0         ; Prompt message with newline
    msg2 db "You chose left!", 0xA, 0       ; "Left" message
    msg3 db "You chose right!", 0xA, 0      ; "Right" message

section .text
    global _start

_start:
    ; Print the message
    mov rax, 1                   ; syscall number for sys_write
    mov rdi, 1                   ; file descriptor (stdout)
    mov rsi, msg                 ; address of the message
    mov rdx, 15                  ; length of the message
    syscall                      ; invoke the syscall

    ; Generate a random value using RDTSC
    rdtsc                        ; read the timestamp counter into edx:eax
    xor edx, eax                 ; combine high and low bits
    and edx, 1                   ; mask to get either 0 or 1

    ; Compare the random value
    cmp edx, 0
    je left                      ; if 0, jump to left
    jmp right                    ; otherwise, jump to right

left:
    ; Print the left message
    mov rax, 1                   ; syscall number for sys_write
    mov rdi, 1                   ; file descriptor (stdout)
    mov rsi, msg2                ; address of the left message
    mov rdx, 15                  ; length of the left message
    syscall                      ; invoke the syscall
    jmp exit                     ; exit the process

right:
    ; Print the right message
    mov rax, 1                   ; syscall number for sys_write
    mov rdi, 1                   ; file descriptor (stdout)
    mov rsi, msg3                ; address of the right message
    mov rdx, 16                  ; length of the right message
    syscall                      ; invoke the syscall
    jmp exit                     ; exit the process

exit:
    ; Exit the process
    mov rax, 60                  ; syscall number for sys_exit
    xor rdi, rdi                 ; return code 0
    syscall                      ; invoke the syscall
