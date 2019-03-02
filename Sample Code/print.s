;Example program that contains a function that prints to standard output the string contained in $a0:

.data
params_sys5: .space 8
.text
print_string:
sw $a0, params_sys5(r0)
daddi r14, r0, params_sys5
syscall 5
jr r31