# Christopher Rose
# Assembly 356
# P006
  .data
	
X: .space 24
Y: .space 36
prompt: .asciiz "Give me an integer  "	
fillX:  .asciiz "Fill array X\n"
fillY:  .asciiz "Fill array Y\n"
sumX:	.asciiz "The sum of array X is "
sumY:	.asciiz "The sum of array Y is "
printX: .asciiz "ArrayX: "
printY: .asciiz "ArrayY: "
n:	.asciiz "\n"
comma:	.asciiz ", "
  .text

main:
  
  li $v0, 4		# prompts the user for integers
  la $a0, fillX
  syscall
  la $t0, X	# the array X
  li $a1, 6	# Size of array argument
  li $t1, 0	# i for the for loop
  
  jal fill_array
  li $v0, 4		# prompts the user for integers
  la $a0, sumX
  syscall
  jal sum_array
  li $v0, 4		# displays the sum
  la $a0, printX
  syscall
  jal print_array	# prints the array
	
  la $t0, Y	# the array Y
  li $a1, 9	# Size of array argument
  li $t1, 0	# i for the for loop	
  
  li $v0, 4		# prompts the user for integers
  la $a0, fillY
  syscall
  jal fill_array
  li $v0, 4		# displays the sum
  la $a0, sumY
  syscall
  jal sum_array
  li $v0, 4		# prints the array
  la $a0, printY
  syscall
  jal print_array
	
  li $v0, 10
  syscall

fill_array:
loop: beq $a1, $t1, endLoop

  li $v0, 4		# prompts the user for integers
  la $a0, prompt
  syscall
	
  li $v0, 5		# puts input into temporary register
  syscall
  	
  move  $t2, $t1	
  sll  $t2, $t2, 2
  add  $t2, $t2, $t0
  sw   $v0, 0($t2)	# stores input into the array at an offset
 
  addi $t1, $t1, 1
  j loop
	
endLoop:
  jr $ra
	
sum_array:
  li $t1, 0
  li $a0, 0
loop2:  beq $a1, $t1, endLoop2
  
  move $t2, $t1		# moves i to $t2 and multiplies it by four to get the offset
  sll $t2, $t2, 2
  add $t2, $t2, $t0
  lw $t3, 0($t2)	# puts integer into a register
  
  add $a0, $a0, $t3	# adds integer to the sum
  
  addi $t1, $t1, 1
  j loop2
endLoop2:
  li $v0, 1	# prints the sum
  syscall
  li $v0, 4
  la $a0, n
  syscall
  jr $ra
  
print_array:
  li $t1, 0
  li $a0, 0
loop3: beq $a1, $t1, endLoop3
  
  move $t2, $t1		# moves i to $t2 and multiplies it by four to get the offset
  sll $t2, $t2, 2
  add $t2, $t2, $t0
  lw $a0, 0($t2)
  
  li $v0, 1		# reads the integers from the array
  syscall
  li $v0, 4
  la $a0, comma
  syscall

  addi $t1, $t1, 1
  j loop3
  
endLoop3:
  li $v0, 4
  la $a0, n
  syscall
  jr $ra

  
	
