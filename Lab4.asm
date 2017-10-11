.data
Emp:       .space 480
Temp1:     .space 48
Temp2:     .space 48
Message1:  .asciiz "\nEmployee Name: "
Message2:  .asciiz "    Age: "
Message3:  .asciiz "    Salary: "
Message4:  .asciiz "\nSwap from ? "
Message5:  .asciiz "Swap to ? "
newline:   .asciiz "\n"
           .globl main
           .text
main:
        li $t1,10   #10 records
        la $a0,Emp
loop:

        li $a1,40
        li $v0,8         # Read a String (Name) 
        syscall
        
        li $v0,5         # Read a number (Age)
        syscall
        sw $v0,40($a0)
        
        add $a0,$a0,4
        li $v0,5        # Read a number (salary)
        syscall
        sw $v0,40($a0)
        
        addi $a0,$a0,44    # move to next Index to store the record
        add $t1,$t1,-1     # round count
        bgtz $t1,loop
        
        li $t2,10         # round Initialize
        la $t3,Emp        # load the array
        move $t1,$t3        # for Print Integer
        jal PrintLoop
 
Swap:
        li $v0,4
        la $a0,Message4       # Print Swap from?
        syscall
        
        li $v0,5
        syscall
        move $t4,$v0       # From Index
        
        la $t3,Emp
        la $t5,Temp1        # Copy the Given Index Information from Emp to Temp1
        move $t6,$t4
        jal copyThemAll
        
        li $v0,4
        la $a0,Message5      # Print Swap to?
        syscall
        
        li $v0,5
        syscall
        move $t2,$v0       # To Index
        
        la $t3,Emp
        la $t5,Temp2       # Copy the Given Index Information from Emp to Temp2
        move $t6,$t2
        jal copyThemAll
        
        ######## copy Last to 1st########
        la $t3,Emp
        la $t5,Temp2
        move $t6,$t4            # Swap Temp2 to first Index
        jal swapThemAll
        
        la $t3,Emp
        la $t5,Temp1            # Swap Temp1 to other Index
        move $t6,$t2
        jal swapThemAll

        li $t2,10         # round Initialize
        la $t3,Emp        # load the array
        move $t1,$t3        # for Print Integer
        jal PrintLoop            # print result
end:
        li $v0,10       # STOP
        syscall
################## Swap Funtion#############
################## Argu $t6(Index),$t5(Temp),$t3(Emp)#########
################## Used register $t6 and $t7 #############
swapThemAll:
        add $t6,$t6,-1     # user type and Index diff 1 
copyRun:
        beqz $t6,prepareCopyLoop
        add $t6,$t6,-1        # move to Index(Emp)
        add $t3,$t3,48
        b copyRun   
prepareCopyLoop:
        li $t6,0             # count length
copyLoop:
        lb $t7,0($t5)
        beq $t7,$zero,walkCopyBack   # store Emp from Temp
        sb $t7,($t3)
        add $t5,$t5,1
        add $t3,$t3,1
        add $t6,$t6,1
        b copyLoop
walkCopyBack:
        add $t3,$t3,-1            # walk back to start posion
        add $t5,$t5,-1
        add $t6,$t6,-1
        bgtz $t6,walkCopyBack
copyNumber:
        li $t6,2                # store two numbers
copyNumberLoop:
        beqz $t6,copyFinish
        lw $t7,40($t5)         # store numbers back to Emp
        sw $t7,40($t3)
        add $t3,$t3,4
        add $t5,$t5,4
        add $t6,$t6,-1
        b copyNumberLoop
copyFinish:
        jr $ra
        
        
################# PRINT FUNCRTION #####################
################## Argu $t2(round count) $t3 (Emp) $t1(number Index)##########
################## Used register $t4 and $t5 #############
PrintLoop:
        li $v0,4
        la $a0,Message1       # Print Employee name:
        syscall
############Print a string without make newLine#####
Print:  
        li $t5,0           # count length (Initialize)
ploop:
        lb $t4,0($t3)         # load byte from the string(Name)
        beq $t4,10,walkBack   # If found \n, the point will walk back to the first Index
        li $v0,11
        move $a0,$t4          # Print the character
        syscall
        add $t3,$t3,1         # go next byte
        add $t5,$t5,1         # length count
        b ploop               # back to loop 
walkBack:
        add $t3,$t3,-1        # move back to last Index
        add $t5,$t5,-1        # round count
        bgtz $t5,walkBack
#################################################### 
        li $v0,4
        la $a0,Message2       # Print Age:
        syscall
        
        li $v0,1
        lw $a0,40($t1)        # Print Age number
        syscall
        
        li $v0,4
        la $a0,Message3       # Print salary:
        syscall
        
        add $t1,$t1,4
        li $v0,1
        lw $a0,40($t1)       # Print salary number
        syscall
        
        add $t1,$t1,44       # move to next age number(Index)
        add $t3,$t3,48       # move to next Name string (Index)
        add $t2,$t2,-1       # round count
        bgtz $t2,PrintLoop
        jr $ra               # function return
        
#################  Copy to temp############################  
################# Function argu $t3(Emp)$t5(Temp)$t6(Index)###################### 
#################  Used register $t7 ##########################
copyThemAll:
        add $t6,$t6,-1  # user and Index diff 1  
storeTemp:
        beqz $t6,prepareStoreLoop     
        add $t6,$t6,-1
        add $t3,$t3,48              # Let Emp move to given position
        b storeTemp
prepareStoreLoop:
        li $t6,0                 #  Count string length
storeLoop:
        lb $t7,0($t3)
        beq $t7,$zero,walkStoreBack   # store to  Temp
        sb $t7,($t5)
        add $t3,$t3,1
        add $t5,$t5,1
        add $t6,$t6,1
        b storeLoop
walkStoreBack:                 # move back to begining position
        add $t3,$t3,-1
        add $t5,$t5,-1
        add $t6,$t6,-1
        bgtz $t6,walkStoreBack
storeNumber:              
        li $t6,2              # store 2 numbers
StoreNumberLoop:
        beqz $t6,storeFinish
        lw $t7,40($t3)         # read a number
        sw $t7,40($t5)         # store this number to temp
        add $t3,$t3,4
        add $t5,$t5,4
        add $t6,$t6,-1
        b StoreNumberLoop
storeFinish:
        jr $ra
