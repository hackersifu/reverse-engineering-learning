section .data
    msg db "Left or Right?", 0       ; null-terminated string
    msg2 db "You chose left!", 0     ; null-terminated string
    msg3 db "You chose right!", 0    ; null-terminated string
    error db "Invalid choice!", 0    ; null-terminated string
    answer db 0                      ; reserve 1 byte for the input answer

section .text
    global _start                    ; Entry point for the process

_start:
    ; Print the message
    mov eax, 4                       ; syscall number for sys_write
    mov ebx, 1                       ; file descriptor 1 is stdout
    mov ecx, msg                     ; address of the message
    mov edx, 14                      ; length of the message
    int 0x80                         ; call the kernel

    ; Read the answer
    mov eax, 3                       ; syscall number for sys_read
    mov ebx, 0                       ; file descriptor 0 is stdin
    mov ecx, answer                  ; address of the answer
    mov edx, 1                       ; read 1 byte
    int 0x80                         ; call the kernel

    ; Check the answer
    cmp byte [answer], 'l'           ; compare the answer to 'l'
    je left                          ; if equal, jump to left
    cmp byte [answer], 'r'           ; compare the answer to 'r'
    je right                         ; if equal, jump to right

    ; Print an error message
    mov eax, 4                       ; syscall number for sys_write
    mov ebx, 1                       ; file descriptor 1 is stdout
    mov ecx, error                   ; address of the error message
    mov edx, 15                      ; length of the error message
    int 0x80                         ; call the kernel
    jmp exit                         ; exit the process

left:
    ; Print the left message
    mov eax, 4                       ; syscall number for sys_write
    mov ebx, 1                       ; file descriptor 1 is stdout
    mov ecx, msg2                    ; address of the left message
    mov edx, 15                      ; length of the left message
    int 0x80                         ; call the kernel
    jmp exit                         ; exit the process

right:
    ; Print the right message
    mov eax, 4                       ; syscall number for sys_write
    mov ebx, 1                       ; file descriptor 1 is stdout
    mov ecx, msg3                    ; address of the right message
    mov edx, 16                      ; length of the right message
    int 0x80                         ; call the kernel
    jmp exit                         ; exit the process

exit:
    ; Exit the process
    mov eax, 1                       ; syscall number for sys_exit
    xor ebx, ebx                     ; return code 0
    int 0x80                         ; call the kernel
