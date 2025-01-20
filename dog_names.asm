section .data
    names db "Buddy", 0, "Bella", 0, "Charlie", 0, "Max", 0, "Luna", 0, "Lucy", 0, \
          "Bailey", 0, "Daisy", 0, "Rocky", 0, "Milo", 0, "Sadie", 0, "Coco", 0, \
          "Ruby", 0, "Bo", 0, "Rosie", 0, "Zoe", 0, "Leo", 0, "Jack", 0, \
          "Ellie", 0, "Lily", 0, "Oscar", 0, "Duke", 0, "Riley", 0

    num_names equ 20       ; Total number of names
    max_name_length equ 10 ; Max length of a name (including null terminator)

    msg_prompt db "Dog Name Select! Enter a number (0-19): ", 10, 0
    msg_result db "You selected: ", 0
    error_msg db "Invalid selection.", 10, 0
    answer db 0             ; Storage for user input

section .text
    global _start

_start:
    ; Print the prompt
    mov rax, 1               ; syscall number for sys_write
    mov rdi, 1               ; file descriptor 1 is stdout
    mov rsi, msg_prompt      ; address of the message
    mov rdx, 39              ; length of the message
    syscall                  ; make the syscall

    ; Read the index
    mov rax, 0               ; syscall number for sys_read
    mov rdi, 0               ; file descriptor 0 is stdin
    mov rsi, answer          ; address to store the input
    mov rdx, 2               ; number of bytes to read (including newline)
    syscall                  ; make the syscall

    ; Remove the newline and convert input ASCII to integer
    sub byte [answer], '0'

    ; Check the index validity
    cmp byte [answer], 0
    jl invalid_selection     ; jump if input < 0
    cmp byte [answer], num_names
    jge invalid_selection    ; jump if input >= num_names

    ; Print the result message
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_result
    mov rdx, 14              ; length of the result message
    syscall

    ; Calculate the address of the selected name
    movzx rax, byte [answer] ; zero-extend the input value
    imul rax, max_name_length ; multiply by max_name_length
    add rax, names           ; add the base address of names
    mov rsi, rax             ; move the calculated address to rsi

    ; Print the selected name
    mov rax, 1
    mov rdi, 1
    mov rdx, max_name_length ; length of the name (includes null terminator)
    syscall

    ; Exit the process
    mov rax, 60              ; syscall number for sys_exit
    xor rdi, rdi             ; return code 0
    syscall

invalid_selection:
    ; Print the error message
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, 19              ; length of the error message
    syscall

    ; Exit the process
    mov rax, 60
    xor rdi, rdi
    syscall
