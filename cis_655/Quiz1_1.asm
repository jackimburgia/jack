.data # Defines variable section of an assembly routine.
	array: .word 1,3,5,7,9,11,13,15,17
.text # Start the instructions of the program.
	la $s0, array # Moves the address of array into register $s0.
	
	# A	$s3
	# x 	$s0
	# y	$s1
	
	# A[x] = y	--> sw - Store Word
	sll $t0, $s0, 2		# Get the index of the array = x * 4
	add $t0, $s0, $t0	# add (x * 4) bytes to the array
	sw $s1, 0($t0)
	
	# y = A[x]	--> lw - Load Word
	lw $s1, 0($t0)
