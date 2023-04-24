.data
	array: .word 0, 5, 15, 3, 18, 7, 20, 2, 16, 1
	newLine: .asciiz "\n"	
.text	
	main:
		#test shell_sort
		la $t0, array 	# put the array in $t0
		addi $t1, $zero, 10
		move $a0, $t0
		move $a1, $t1	
		jal shell_sort
		

		
		jal displayArray
	
		# tell the system the program is done
		li $v0, 10
		syscall 
		
	shell_sort: # int[] array, int n
		addi $sp,$sp, -24 # make room on stack for 6 registers
		sw $ra, 20($sp) # save $ra on stack
		sw $s4, 16($sp) # save $s4 on stack - gap
		sw $s3, 12($sp) # save $s3 on stack - n
		sw $s2, 8($sp) # save $s2 on stack - array
		sw $s1, 4($sp) # save $s1 on stack - j
		sw $s0, 0($sp) # save $s0 on stack - i
		
		move $s2,$a0 # copy parameter $a0 into $s2 (save $a0) - array
		move $s3,$a1 # copy parameter $a1 into $s3 (save $a1) - n

		sra $s4, $s3, 1 # int gap = n / 2;
		
		while:
			# set the arguments		
			move $a0, $s2 
			move $a1, $s3 
			move $a2, $s4
			
			jal insert_shell

			# if insert_shell returns 0, exit the loop
			beq $v0, $zero, exitWhile
			
			sra $s4, $s4, 1 # gap = gap / 2;
			
			j while

		exitWhile:
			lw $s0, 0($sp) # restore $s0 from stack
			lw $s1, 4($sp)# restore $s1 from stack
			lw $s2, 8($sp) # restore $s2 from stack
			lw $s3, 12($sp) # restore $s3 from stack
			lw $s4, 16($sp) # restore $s4 from stack
			lw $ra, 20($sp) # restore $r5 from stack
			addi $sp,$sp, 24 # restore stack pointer		
		
		jr $ra # return to calling routine
		
		
	insert_shell: # int *array, int n, int gap
		addi $sp,$sp, -24 # make room on stack for 6 registers
		sw $ra, 20($sp)# save $ra on stack
		sw $s4, 16($sp) # save $s4 on stack - gap
		sw $s3, 12($sp) # save $s3 on stack - n
		sw $s2, 8($sp) # save $s2 on stack - array
		sw $s1, 4($sp) # save $s1 on stack - j
		sw $s0, 0($sp) # save $s0 on stack - i
		
		move $s2,$a0 # copy parameter $a0 into $s2 (save $a0) - array
		move $s3,$a1 # copy parameter $a1 into $s3 (save $a1) - n
		move $s4,$a2 # copy parameter $a2 into $s4 (save $a2) - gap
		
		addi $v0, $zero, 0 # by default the return value is 0
				
		beq $s4, $zero, exitOuter # if 0 is returned, exit the loop
		
		addi $v0, $zero, 1 # set the return value to 0 since it will begin the loop
		
		move $s0, $s4	# i counter = gap	
		
		outerLoop:
			slt $t0, $s0, $s3
			beq $t0, $zero, exitOuter	
									
			move $s1, $s0 # j = i	
			
			innerLoop:
				slt $t1, $s1, $s4
				bne $t1, $zero, exitInner # j >= gap
				
				# array[j]
				sll $t2, $s1, 2
				add $t3, $s2, $t2
				lw $t4, 0($t3) 
				
				# array[j - gap]
				sub $t2, $s1, $s4
				sll $t2, $t2, 2
				add $t3, $s2, $t2
				lw $t5, 0($t3) 
					
				slt $t7, $t4, $t5 # array[j - gap] > array[j] = 0/false				
				beq $t7, $zero, exitInner				
						
				sub $t7, $s1, $s4 # j - gap			
					
				# get the arguments
				move $a0, $s2 
				move $a1, $t7 
				move $a2, $s1

				jal swap
				

				sub $s1, $s1, $s4 # j = j - gap
				j innerLoop
							
			exitInner:
				addi $s0, $s0, 1
				j outerLoop
		exitOuter:
		
			lw $s0, 0($sp) # restore $s0 from stack
			lw $s1, 4($sp)# restore $s1 from stack
			lw $s2,8($sp) # restore $s3 from stack
			lw $s3,12($sp) # restore $s3 from stack
			lw $s4,16($sp) # restore $s3 from stack
			lw $ra,20($sp) # restore $ra from stack
			addi $sp,$sp,24 # restore stack pointer

			jr $ra # return to calling routine
	
		
	swap: # int *array, int i1, int i2
		addi $sp,$sp, -8 # make room on stack for 6 registers
		sw $ra, 4($sp)# save $ra on stack
		sw $s0, 0($sp) # save $s0 on stack - temp
	
		sll $t1, $a1, 2 
		add $t1, $a0, $t1 
		
		sll $t2, $a2, 2  
		add $t2, $a0, $t2 
		
		# get the values from the array
		lw $s0, 0($t1) # int temp = array[i1];
		lw $t3, 0($t2) # array[i2];

		
		# save the values to the array
		sw $s0, 0($t2) # array[i1] = array[i2];
		sw $t3, 0($t1) # array[i2] = temp;
		
		
		lw $s0, 0($sp) # restore $s0 from stack - temp
		lw $ra, 4($sp) # restore $ra from stack
		addi $sp,$sp, 8 # restore stack pointer		
		
		jr $ra 		
		
		
		
	displayArray:
		move $t0, $a0 
		
		# print the items in the array
		
		addi $t1, $zero, 10 # t1 is the number of elements in the array = 10
		addi $t2, $zero, 0 # t2 is the counter which starts at 0
		
		loop:
			slt $t3, $t2, $t1
			beq $t3, $zero, exitLoop # if it's zero, it is equal to 10
			
			lw $s0, 0($t0)
			
			move $a0, $s0
			li $v0, 1 # print integer
			syscall
			
			
			li $v0, 4
			la $a0, newLine
			syscall
			
			addi $t2, $t2, 1
			addi $t0, $t0, 4
			
			j loop
		exitLoop:
			jr $ra		