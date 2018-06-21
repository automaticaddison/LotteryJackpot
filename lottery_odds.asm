.globl main

.text
 main:  
		#############################################
		#   Addison Sears-Collins           		#
		#   EN.605.204.81.FA17 10/12/2017   		#
		#   Module 7 Assignment             		#
		#   Lottery Jackpot Probabilities and Odds	#
		#############################################
		
		#####-----Large Pool Calculation-----#####
        li $v0, 4  				# load system call code for print_string
        la $a0, in_lptot		# load address of in_lptot text into register $a0
        syscall					# call operating system to perform print operation

        li $v0, 5  				# load system call code for reading an integer value
        syscall					# call operating system to perform read integer operation
	    addi $s0, $v0, 0		# value read from the keyboard is stored in $s0

        li $v0, 4  				# load system call code for print_string
        la $a0, in_lpcnt		# load address of in_lpcnt text into register $a0
        syscall					# call operating system to perform print operation
		
        li $v0, 5 				# load system call code for reading an integer value
        syscall					# call operating system to perform read integer operation
        addi $s1, $v0, 0		# value read from the keyboard is stored in $s1

        sub $s2, $s0, $s1  		# large pool size - count, (n - k), in_lptot-in_lpcnt 

        #-----Calculation of n!/(n-k)!
        addi $t1, $s2, 0		# store (n - k) into $t1
        addi $t2, $zero, 1		# store 1 into $t2
loopl:
        slt $t3, $t1, $s0		# if (n-k) < n then $t3 = 1; else $t3 = 0
        beq $t3, $zero, exitl 	# exit loopl if $t3=0 because (n-k) = n
        mul $t2, $t2, $s0 		# multiply $t2 and $s0 and store result into $t2
        addi $s0, $s0, -1		# decrement n by 1 and update value of $s0
        j loopl		
		#-----	

		#-----Calculation of n!/(n-k)!/ k!		
exitl:
        add $a0, $zero, $s1  	# put the value of k into $a0
        jal factrl				# jump and link to factorial subroutine
        addi $s3, $v0, 0 		# put the value of k! into $s3

        div $s4, $t2, $s3  		# compute the value of n!/(n-k)!/k!
		#-----		
		#####-----
		
		#####-----Small Pool Calculation-----#####
        li $v0, 4  				# load system call code for print_string
        la $a0, in_sptot		# load address of in_sptot text into register $a0
        syscall					# call operating system to perform print operation

        li $v0, 5  				# load system call code for reading an integer value
        syscall					# call operating system to perform read integer operation
	    addi $s0, $v0, 0		# value read from the keyboard is stored in $s0

        li $v0, 4  				# load system call code for print_string
        la $a0, in_spcnt		# load address of in_spcnt text into register $a0
        syscall					# call operating system to perform print operation
		
        li $v0, 5 				# load system call code for reading an integer value
        syscall					# call operating system to perform read integer operation
        addi $s1, $v0, 0		# value read from the keyboard is stored in $s1

        sub $s2, $s0, $s1  		# small pool size - count, (n - k), in_sptot-in_spcnt 

        #-----Calculation of n!/(n-k)!
        addi $t1, $s2, 0		# store (n - k) into $t1
        addi $t2, $zero, 1		# store 1 into $t2
loops:
        slt $t3, $t1, $s0		# if (n-k) < n then $t3 = 1; else $t3 = 0
        beq $t3, $zero, exits 	# exit loops if $t3=0 because (n-k) = n
        mul $t2, $t2, $s0 		# multiply $t2 and $s0 and store result into $t2
        addi $s0, $s0, -1		# decrement n by 1 and update value of $s0
        j loops		
		#-----	

		#-----Calculation of n!/(n-k)!/ k!		
exits:
        add $a0, $zero, $s1  	# put the value of k into $a0
        jal factrl				# jump and link to factorial subroutine
        addi $s3, $v0, 0 		# put the value of k! into $s3

        div $s5, $t2, $s3  		# compute the value of n!/(n-k)!/k!
		#-----				
		#####-----
		
        li $v0, 4  				# load system call code for print_string
        la $a0, odds			# load address of odds text into register $a0
        syscall					# call operating system to perform print operation		
   		
        mul $s4, $s4, $s5		# larger pools odds * smaller pool odds

        li $v0, 1  				# load system call code for print_int
        addi $a0, $s4, 0  		# Put the odds into register $a0
        syscall					# call operating system to perform print operation

		li $v0, 4				# load system call code for print_string
        la $a0, stop 			# load address of stop text into register $a0
        syscall					# call operating system to perform print operation
		
		li	$v0, 10				# system call code for exit is 10
		syscall					# call operating system to perform exit operation	

 	######### Factorial Subroutine Fall 2016
#
# Given n, in register $a0;
# calculate n!, store and return the result in register $v0

factrl: sw $ra, 4($sp) 			# save the return address
        sw $a0, 0($sp) 			# save the current value of n
        addi $sp, $sp, -8 		# move stack pointer
        slti $t0, $a0, 2 		# save 1 iteration, n=0 or n=1; n!=1
        beq $t0, $zero, L1 		# not less than 2, calculate n(n-1)!
        addi $v0, $zero, 1 		# n=1; n!=1
        jr $ra 					# now multiply

L1:     addi $a0, $a0, -1 		# n = n-1

        jal factrl 				# now (n-1)!

        addi $sp, $sp, 8 		# reset the stack pointer
        lw $a0, 0($sp) 			# fetch saved (n-1)
        lw $ra, 4($sp) 			# fetch return address
        mul $v0, $a0, $v0 		# multiply (n)*(n-1)
        jr $ra 					# return value n!
# P Snyder 14 August 2016
######### End of the subroutine			

.data
in_lptot: 		.asciiz "Please enter the size of the large pool of possible numbers: "
in_lpcnt:		.asciiz "Please enter the count of the numbers to be selected from the large pool: "
in_sptot: 		.asciiz "\nPlease enter the size of the small pool of possible numbers: "
in_spcnt: 		.asciiz "Please enter the count of the numbers to be selected from the small pool: "
odds:			.asciiz "\nThe odds of this lottery scheme are 1 in "
stop:    		.asciiz "\n\nProgram complete"