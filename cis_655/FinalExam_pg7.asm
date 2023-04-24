
# Assume two variables, x and y, stored in $s0 and $s1, respectively.
	addi $s0, $0, 0 # x = 0
	addi $s1, $0, 0 # y = 0
label1: 
	slti $t0, $s0, 10 	# if (x < 10)
	beq $t0, $0, exit  	# FALSE - break / exit loop
	addi $s0, $s0, 1  	# TRUE - x = x + 1
	addi $t0, $0, 5 	# t0 = 5
	slt $t1, $t0, $s0 	# if (5 < x)
	bne $t1, $0, label2 	# TRUE - 
	j label1 
label2: 
	addi $s1, $s1, 1 	# y =  y +1
	j label1 
exit:
