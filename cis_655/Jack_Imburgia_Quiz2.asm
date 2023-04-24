.data 
	# Any globals here
	
.text 

.globl main 

main: 
	# Your main() code here
	addi $t0, $zero, 2
	addi $t1, $zero, 3
	addi $t2, $zero, 5
	
	move $a0, $t0
	move $a1, $t1
	move $a2, $t2	
			
	jal stupid_func
	
	move $a0, $v0
	
	# Terminate program run 
	# syscall 17 is exit2, which takes a return value. 
	# The return value should be loaded into $a0. 
	li $v0, 17 
	syscall

.globl stupid_func 
	stupid_func: 
	# Your stupid_func() code here
	addi $sp,$sp, -28
	sw $ra, 24($sp) 
	sw $s5, 20($sp) # c
	sw $s4, 16($sp) # b
	sw $s3, 12($sp) # a
	sw $s2, 8($sp) # sc
	sw $s1, 4($sp) # sb
	sw $s0, 0($sp) # sa
	
	move $s3,$a0 # a
	move $s4,$a1 # b	
	move $s5,$a2 # c
	
	add $t0, $s3, $s3
	add $s0, $t0, $s3
	
	add $t1, $s4, $s4
	add $s1, $t1, $s4
	
	add $t2, $s5, $s5
	add $s3, $t2, $s5
	
	# return value
	add $t3, $s0, $s1
	add $v0, $t3, $s2
	
	lw $s0, 0($sp) 
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp) 
	lw $s4, 16($sp) 
	lw $s5, 20($sp) 	
	lw $ra, 24($sp) 
	addi $sp,$sp, 28 
	
	jr $ra 