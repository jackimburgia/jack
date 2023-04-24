.data 							# Defines variable section of an assembly routine.
	array: .word 0, 5, 15, 3, 18, 7, 20, 2, 16, 1 	# Define a variable named array as a word (integer) array.
							# After your program has run, the integers in this array should be sorted.
.text 							# Defines the start of the code section for the program.
.globl main
	main:
	la $t0, array 					# Moves the address of array into register $t0.
	addi $a0, $t0, 0 				# Set argument 1 to the base address of the array.
	addi $a1, $zero, 10 				# Set argument 2 to (n = 10).
	#jal shell_sort 				# Call shell_sort (you need to implement this method).


	li $v0, 1 					# tells syscall that we are printing an integer
	#move $a0, $t1
	syscall


	# Terminate program run.
	li $v0, 10 					
	syscall



