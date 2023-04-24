.data # Defines variable section of an assembly routine.
	array: .word 1,3,5,7,9,11,13,15,17 # Defines an array of integers (the input).
.text # Start the instructions of the program.
	la $s0, array # Moves the address of array into register $s0.
	
	lw $s1, 0($s0)		# int temp = array[0];
	lw $t0, 32($s0)
	addi $t0, $t0, 1	# array[8] + 1; --> 17 + 1
	sw $t0, 0($s0)
	addi $t0, $s1, -1	# temp - 1;
	sw $t0, 32($s0)
	
	lw $s1, 4($s0)
	lw $t0, 28($s0)
	addi $t0, $t0, 3
	sw $t0, 4($s0)
	addi $t0, $s1, -3	# temp - 3;
	sw $t0, 28($s0)
	
		
	lw $s1, 8($s0)
	lw $t0, 24($s0)
	addi $t0, $t0, 5
	sw $t0, 8($s0)
	addi $t0, $s1, -5	# temp - 3;
	sw $t0, 24($s0)	
		
						
	lw $s1, 12($s0)				
	lw $t0, 20($s0)
	sll $t0, $t0, 3
	sw $t0, 12($s0)
	srl $t0, $s1, 3		# temp - 3;
	sw $t0, 20($s0)	
	

