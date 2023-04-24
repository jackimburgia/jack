.data
	array: .word 0, 5, 15, 3, 18, 7, 20, 2, 16, 1
	message: .asciiz "Hello world"
.text	
	main:
		#jal doSomething1
	
		add $a1, $zero, 50
		add $a2, $zero, 25
		
		jal addNumbers
		
		li $v0, 1
		addi $a0, $v1, 0
		syscall
	
		# tell the system the program is done
		li $v0, 10
		syscall 
	
	doSomething1:
		li $v0, 4
		la $a0, message
		syscall
		
		jr $ra
		
	addNumbers:
		add $v1, $a1, $a2
		
		jr $ra