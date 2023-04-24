.data

.text
.globl main
main:
	# load arguments
	addi $a0, $zero, 2
	addi $a1, $zero, 2
	
	jal addit
	
	li $v0, 17
	syscall
addit:
	addi $sp, $sp, -4 	# get space on the stack
	sw $s0, 0($sp) 		# int r
	
	add $s0, $a0, $a1
	
	add $v0, $zero, $s0
	
	lw $s0, 0($sp)		# restore registers
	
	addi $sp, $sp, 4
	
	jr $ra
	
	