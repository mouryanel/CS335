

.data

format_print_str: .asciz "%s\n"
format_print_int: .asciz "%ld\n"

format_print_true: .asciz "True\n"
format_print_false: .asciz "False\n"
.text
.globl main

area:
pushq %rbp
movq %rsp, %rbp
subq $56, %rsp
movq -16(%rbp), %rax
movq %rax, -8(%rbp)
movq -8(%rbp), %rax
movq %rax, -24(%rbp)
movq -16(%rbp), %rax
movq %rax, -32(%rbp)
movq -32(%rbp), %rax
movq %rax, -40(%rbp)
movq -24(%rbp), %rdx
movq -40(%rbp), %rbx
imulq %rbx, %rdx
movq %rdx, -48(%rbp)
movq -48(%rbp), %rax
movq %rax, -56(%rbp)
movq -56(%rbp), %rax
leave
ret
leave
ret
main:
pushq %rbp
movq %rsp, %rbp
subq $40, %rsp
movq $3, %rax
movq %rax, -8(%rbp)
movq $5, %rax
movq %rax, -16(%rbp)
pushq %rdx
pushq %rdi
pushq %r10
pushq %r11
pushq %rax
pushq %rsi
pushq %r8
pushq %r9
pushq %rcx
movq %rsp, %rbx
movq %rsp, %rcx
addq $-8, %rcx
andq $15, %rcx
subq %rcx, %rsp
movq -8(%rbp), %rdx
pushq %rdx
movq -16(%rbp), %rdx
pushq %rdx
call area
movq %rbx, %rsp
popq %rcx
popq %r9
popq %r8
popq %rsi
popq %rax
popq %r11
popq %r10
popq %rdi
popq %rdx
movq -32(%rbp), %rax
movq %rax, -24(%rbp)
movq -24(%rbp), %rax
movq %rax, -40(%rbp)
pushq %rdx
pushq %rdi
pushq %r10
pushq %r11
pushq %rax
pushq %rsi
pushq %r8
pushq %r9
pushq %rcx
movq %rsp, %rbx
movq %rsp, %rcx
addq $-8, %rcx
andq $15, %rcx
subq %rcx, %rsp
movq -40(%rbp), %rdx
pushq %rdx
movq -40(%rbp), %rdx
pushq %rdx
movq %rbx, %rsp
popq %rcx
popq %r9
popq %r8
popq %rsi
popq %rax
popq %r11
popq %r10
popq %rdi
popq %rdx
leave
ret
print_int:
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %rsi
lea format_print_int(%rip), %rdi
xorq %rax, %rax
callq printf@plt
leave
ret
print_bool:
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %rcx
cmp $0, %rcx
jne print_true_label
lea format_print_false(%rip), %rdi
jmp print_false_exit
print_true_label:
lea format_print_true(%rip), %rdi
print_false_exit:
xorq %rax, %rax
callq printf@plt
leave
ret
print_str:
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %rsi
lea format_print_str(%rip), %rdi
xorq %rax, %rax
callq printf@plt
leave
ret
get_list:
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %rdi
callq malloc
leave
ret
.power:
pushq %rbp
movq %rsp, %rbp
subq $-32, %rsp
movq $0, -24(%rbp)
movq $1, -32(%rbp)
jmp .L2
.L3:
movq -32(%rbp), %rax
imulq 16(%rbp), %rax
movq %rax, -32(%rbp)
addq $1, -24(%rbp)
.L2:
movq -24(%rbp), %rax
cmpq 24(%rbp), %rax
jl .L3
movq -32(%rbp), %rax
leave
ret
