.data
MyArray:   .space 32
prompt1:   .asciiz "\nfirst position: "
prompt2:   .asciiz "\nlast position: "
prompt3:   .asciiz "\nThe Minimum Value is :"
theFirstPosition:   .word 0
theLastPosition:    .word 7
theAnswer: .word 0
.globl main
.text

main:
         li $t0,8
         la $t2,MyArray
for:                         # Enter the numbers
         li $v0,5
         syscall
         sw $v0,0($t2)
         add $t2,$t2,4
         add $t0,$t0,-1
         bgtz $t0,for
         
         li $v0,4
         la $a0,prompt1             # Print String 
         syscall
         
         li $v0,1
         lw $a0,theFirstPosition    # Print the first position
         syscall
         
         li $v0,4
         la $a0,prompt2             # Print String
         syscall
         
         li $v0,1
         lw $a0,theLastPosition     # Print the second position
         syscall
         
         la $a0,MyArray             # load Given Array
         lw $a1,theFirstPosition    # load first position
         lw $a2,theLastPosition     # load second position
         la $v0,theAnswer           # load the value address
         jal min                    # recursivly function
         sw $v0,theAnswer           # store the answer
         
         li $v0,4
         la $a0,prompt3             # print string
         syscall 
         
         li $v0,1
         lw $a0,theAnswer           # Print answer
         syscall
end:
         li $v0,10                  # End 
         syscall
min:
         bne $a1,$a2,else           # base case a1==a2
         move $t0,$a1
         li $t5,4
         mult $t0,$t5
         mflo $t0
         add $t0,$t0,$a0
         lw $t1,0($t0)              # t1 = A[a1]
         move $v0,$t1               # return value
         jr $ra
else:
         addiu $sp,$sp,-16          # store 4 locations
         sw $ra,0($sp)              # sp
         sw $a2,4($sp)              # store a2 memory location
         li $t2,2                 
         add $t3,$a1,$a2            
         div $t3,$t3,$t2            # get mid 
         sw $t3,8($sp)              # store the mid for second part
         move $a2,$t3               # jal to first part
         jal min
         sw $v0,12($sp)             # get the value from the first part
         lw $a2,4($sp)              # get a2 from the memory
         lw $a1,8($sp)              # get a1 from the memory
         add $a1,$a1,1              # mid++
         jal min                    # jal to second part
         lw $t4,12($sp)             # get the value from the first part
         blt $v0,$t4,else2          # compare to find the smallest value
         move $v0,$t4
else2:
         lw $ra,0($sp)
         addiu $sp,$sp,16           # move pointer back 
         jr $ra
         
