          .data
MyArray:  .space  208
MyString: .space  20
copyString: .space  20
Prompt:   .asciiz "Give me a string: "
Prompt1:   .asciiz "\nThis is palindrome \n\n"
Prompt2:   .asciiz "\nThis is not palindrome\n\n"
Space:    .asciiz " "
Line:     .asciiz "\n"
CheckArray:  .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
Upper:   .asciiz "Upper : \nA B C D E F G H I J K L M N O P Q R S T U V W X Y Z \n"
Lower:   .asciiz "\nLower : \na b c d e f g h i j k l m n o p q r s t u v w x y z Space\n"
         .globl  main
         .text
main:
        li $v0,4
        la $a0,Prompt        # Print give me a number
        syscall
        
        li $v0,8
        la $a0,MyString        # User input a string
        li $a1,20
        move $t0,$a0           # Store string to $t0
        syscall

        la $t1,CheckArray              #  t0 is Input String   $t1 Check letter string
        la $t2,MyArray                 # t2  output result
             
        la $t8,copyString            #copy String to $t8
        jal Copystr
        
        li $t6,53                 # round count initialize
        
#first for loop
OutsideLoop:
        lb $t5,0($t1)
        la $t0,MyString               # Initialize User input string pointer
        li $t3,0                       # t3 for each character sequences (temp)
        li $t7,0                     # string length    
#second for loop
InsideLoop:                           #check user input (string)
        lb $t4,0($t0)
        beq $t4,$zero,cont
        bne $t4,$t5,notFound
        addi $t3,$t3,1               # If Found the match character   $t3=$t3+1
notFound:        
        addi $t7,$t7,1
        addi $t0,$t0,1
        b InsideLoop
#cont for first for loop
cont:
        sw $t3,0($t2)              # Store frequence to result
        addi $t1,$t1,1             # check Character go next
        addi $t2,$t2,4             # Go next posistion
        addi $t6,$t6,-1            # round count
        bgtz $t6,OutsideLoop
        jal  palindrome

PrintResult:
#Print result Array
        la $t2,MyArray       # Initialize IntArray pointer
        li $t6,53
        li $v0,4
        la $a0,Upper       #print Upper
        syscall
print:
        li $v0,1
        lw $a0,0($t2)        #print Result Integer
        syscall
        li $v0,4
        la $a0,Space        #print Space
        syscall
        bne $t6,28,contPrint
        li $v0,4
        la $a0,Lower       #print Lower
        syscall
contPrint:        
        addi $t6,$t6,-1      #round count
        addi $t2,$t2,4       # go next position
        bgtz $t6,print
        
end:
       li $v0,10
       syscall 
       
palindrome:      
        la $t8,copyString    # reload copyString
        move $t0,$t8
goback:
        lb $t4,0($t0)
        beq $t4,$zero,prepare
        addi $t0,$t0,1
        b goback
prepare:
        add $t0,$t0,-2  #move back one
        add $t7,$t7,-1
        
check:
        lb $t4,($t0)    # forward string
        lb $t9,0($t8)     #go back work string

        bne $t4,$t9,itNo  # if it is not equal (character)
        add $t8,$t8,1
        add $t0,$t0,-1
        add $t7,$t7,-1
        bgtz $t7,check

itYes:
        li $v0,4
        la $a0,Prompt1        # Print it is palindrome
        syscall
        jr $ra
itNo:
        li $v0,4
        la $a0,Prompt2        # Print it is not palindrome
        syscall
        jr $ra
#Copy a string to other
Copystr:
        lb $t4,0($t0)
        beqz $t4,out
        sb $t4,($t8)
        addi $t0,$t0,1
        addi $t8,$t8,1
        b Copystr
out:
        jr $ra
