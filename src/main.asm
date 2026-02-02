org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A
start : 
 jmp main


;Print a string to the screen 
;Params :
;   - ds:si point to string
puts :
    ; save register we will modify
    push si 
    push ax

.loop : 
    lodsb       ;loads net caracter in al
    or al, al   ; verify if next caracter is null
    jz .done

    mov ah, 0x0e ; call bios interrupts
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop ax 
    pop si 
    ret


main :

    ; setup data segment 
    mov ax, 0; cant' write to ds/es direcly
    mov ds, ax
    mov es, ax

    ;setup the stack 
    mov ss, ax
    mov sp, 0x7C00 

    mov si, msg_hello
    call puts 

.halt : 
    jmp .halt

msg_hello: db 'Hello word!', ENDL , 0
times 510 -($-$$) db 0
dw 0AA55h