.data
	array: .word 0, 5, 15, 3, 18, 7, 20, 2, 16, 1
	newLine: .asciiz "\n"
.text	
	main:
	
		la $t0, array 	# put the array in $t0
		


		#move $s0, $t0
		addi $s1, $zero, 10 	# n 
		addi $s2, $zero, 5	# gap
		
		move $t2, $s2	# i counter = gap

		# 0, 5, 2, 3, 1, 7, 20, 15, 16, 18
		outerLoop:
			slt $t3, $t2, $s1
			beq $t3, $zero, exitOuterLoop
			
			move $t4, $t2 # j = i
			
			innerLoop:
				#move $a0, $t4
				#jal printNum	
				
				#move $a0, $s2
				#jal printNum					
			
				slt $t6, $t4, $s2
				
				#move $a0, $t6
				#jal printNum
				
				bne $t6, $zero, exitInner # j >= gap = 0/false
				
				addi $t1, $zero, 4
				mul $t1, $t4, $t1
				add $t1, $t0, $t1
				lw $t1, 0($t1) # array[j]
				
				addi $t5, $zero, 4
				sub $t7, $t4, $s2
				mul $t5, $t7, $t5
				add $t5, $t0, $t5
				lw $t5, 0($t5) # array[j - gap]	
				
				slt $t7, $t1, $t5# array[j - gap] > array[j] = 0/false				
				beq $t7, $zero, exitInner	
				
				sub $t7, $t4, $s2 # j - gap
				
				#move $a0, $t7 # j - gap
				#jal printNum	
				#move $a0, $t4 # j
				#jal printNum	
				#move $a0, $t4
				#jal printNum
				
				#move $s6, $t7
				#move $s7, $t4
				
				#move $a0, $t0
				#move $a1, $t7
				#add $a1, $t7, $zero
				#move $a2, $t4
				#jal swap
				
				move $a0, $t7
				#jal swap2
				
				move $a0, $t7 # j - gap
				jal printNum	
				move $a0, $t4 # j
				jal printNum	
				
				# 2, 7
				# 4, 9
				
				sub $t4, $t4, $s2 # j -= gap or j = j - gap
				
		# test swap
		#move $a0, $t0
		#addi $a1, $zero, 2
		#addi $a2, $zero, 7		
		#jal swap
		
		#move $a0, $t0
		#addi $a1, $zero, 4
		#addi $a2, $zero, 9		
		#jal swap
				
				j innerLoop
			
			exitInner:
						
			#move $a0, $t2
			#jal printNum			
			

			
			addi $t2, $t2, 1
			j outerLoop
			
		exitOuterLoop:
		


	#addi $t3, $zero, 1
	#sll $t4, $t0, $t3
	
	#add $t2, $t0, 8
	#lw $t1, 0($t2)
	#addi $t1, $t1, 88
	#sw $t1, 0($t2)
	
		move $a0, $t0
		jal displayArray
		


		#li $v0, 1 # print integer
		#addi $t0, $t0, 4
		#lw $s0, 0($t0)
		#move $a0, $s0
		#addi $a0, $zero, 43
		#syscall
		
	
		# tell the system the program is done
		li $v0, 10
		syscall 
		
	printNum:
		#move $a0, $s0
		li $v0, 1 # print integer
		syscall
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		jr $ra
		
		
	swap2:
    move    $t0,$a0                 # get a
    #move    $t1,$a1                 # get b
    #move    $t2,$a2                 # get c

#mul $t4, $t0, $t3

		jr $ra
		
	swap:
    addiu   $sp,$sp,-4
    sw      $ra,0($sp)
	
	#lw $a0, 0($a0)
	
		# TODO - save register to stack
		addi $t3, $zero, 4

    move    $t0,$a0                 # get a
    move    $t1,$a1                 # get b
    move    $t2,$a2                 # get c
    
    		#mul $t4, $t1, $t3
    
		#mul $t4, $a1, $t3
		#mul $t5, $a2, $t3
		
		#add $t6, $a0, $t4
		#add $t7, $a0, $t5
		
		#lw $t1, 0($t6)
		#move $t3, $t1 # switch $t3 with $s0
		#lw $t2, 0($t7)
		
		#sw $t2, 0($t6)
		
		#sw $t3, 0($t7)# switch $t3 with $s0
			
    lw      $ra,0($sp)
    addiu   $sp,$sp,4

						
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
