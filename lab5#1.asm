.data
prompt1:   .asciiz "\nEnter first input number: "
prompt2:   .asciiz "\nEnter second input number: "
prompt3:   .asciiz "\nThe Value is : "
theParaFirst:   .word 0
theParaSecond:   .word 0
theAnswer: .word 0
.globl main
.text

main:
         li $v0,4
         la $a0,prompt1        # Print Enter first input number
         syscall
         
         li $v0,5
         syscall
         sw $v0,theParaFirst    # Enter the first number
         
         li $v0,4
         la $a0,prompt2         # Print Enter second input number
         syscall
         
         li $v0,5
         syscall
         sw $v0,theParaSecond    # Enter the second number
         
         lw $a0,theParaFirst     # load a0, a1
         lw $a1,theParaSecond
         jal comb
         sw $v0,theAnswer        # store the answer
         
         li $v0,4
         la $a0,prompt3          # Print the answer
         syscall
         
         li $v0,1
         lw $a0,theAnswer
         syscall
end:
         li $v0,10               # End
         syscall
comb:
         bne $a0,$a1,notThis     # check if it is not equal, need to check a1 == 0
notThis:
         beq $a0,$a1,getValue
         bnez $a1,else
getValue:
         li $v0,1                # return function = 1
         jr $ra
else:
         addiu $sp,$sp,-16       # store 3 locations
         sw $ra,0($sp)           # sp
         sw $a0,4($sp)           # store a0 memory location
         sw $a1,8($sp)           # store a1 memory location
         addi $a0,$a0,-1         # a0 -= 1
         jal comb                # first part 
         sw $v0,12($sp)          # store the value from the first part
         lw $a0,4($sp)           # load a0 from memory location
         lw $a1,8($sp)           # load a1 from memory location
         addi $a0,$a0,-1         # a0 -= 1
         addi $a1,$a1,-1         # a1 -= 1
         jal comb                # the second part
         lw $t0,12($sp)          # load the value from the first part           
         add $v0,$t0,$v0         # add together
         lw $ra,0($sp)           # load return address
         addiu $sp,$sp,16        # move the pointer back 
         jr $ra
