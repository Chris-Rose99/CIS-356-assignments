# Christopher Rose
# Assembly 356
# P007
  .data
	
A: .space 600
prompt: .asciiz "Give me an integer  "	
fill:  .asciiz "Fill the array 
sum: .asciiz "The sum of array A is "
print: .asciiz "Array A: "
n:	.asciiz "\n"
search: .asciiz "Search for an element: "
space: .asciiz " "
index: .asciiz "It's lowest spot in the array is index "
  .text

main:
  
  li $v0, 4		# prompts the user for integers
  la $a0, fill
  syscall
  la $a0, n
  syscall
  	
  la $t0, A		# the array A
  li $a1, 150		# Size of array argument
  li $t1, 0		# i for the for loop
  jal fill_array
  
  move $a2, $t1		# $a2 = the number of elements used
  jal sort_array	#countdown from $t1
  
  li $v0, 4		
  la $a0, n
  syscall
  la $a0, sum
  syscall
  jal sum_array		# prints sum
  
  la $a0, n
  syscall
  la $a0, print
  syscall
  jal print_array	# prints the array
  
  li $v0, 4
  la $a0, n
  syscall
  la $a0, search
  syscall
  li $v0, 5
  syscall		# prompts user for a integer to search for
  
  li $a3, -1		# lowest index of value, $a2 is the max element
  li $t1, 0		# $t1 is the min element
  jal find_in_array
  li $v0, 4
  la $a0, index
  syscall
  li $v0, 1
  move $a0, $a3
  syscall
	
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
  blt $v0, $zero, endLoop	# allows negative number for sentinel value
   
  addi $t1, $t1, 1
  j loop
	
endLoop:
  jr $ra
	
sort_array:
  li $t1, 1
Loop4: 
  bgt $t1, $a1, endLoop4
  
  move  $t2, $t1	# $t3 = A[i], $t[4] = A[i-1]
  sll  $t2, $t2, 2
  add  $t2, $t2, $t0
  lw  $t3, 0($t2)
  blt $t3, $zero, endLoop4	# picks up sentiel value and ends sorting process
  addi $t2, $t2, -4
  lw  $t4, 0($t2)
  
  blt $t3, $t4, swap
  
  addi $t1, $t1, 1
  j Loop4
  
swap:
  sw $t3, 0($t2)	#swaps A[i] and A[i-1]
  addi $t2, $t2, 4
  sw $t4, 0($t2)
  beq $t1, 1, Loop4	#if we are checking the beginning of the array it doesn't decrement i
  addi $t1, $t1, -1
  j Loop4
  
endLoop4:
  jr $ra	
	
sum_array:
  li $t1, 0
  li $a0, 0
loop2:  
  beq $a1, $t1, endLoop2
  
  move $t2, $t1		# moves i to $t2 and multiplies it by four to get the offset
  sll $t2, $t2, 2
  add $t2, $t2, $t0
  lw $t3, 0($t2)	# puts integer into a register
  
  blt $t3, $zero, endLoop2
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
  
  blt $a0, $zero, endLoop3
  li $v0, 1		# reads the integers from the array
  syscall
  li $v0, 4
  la $a0, space
  syscall

  addi $t1, $t1, 1
  j loop3
  
endLoop3:
  li $v0, 4
  la $a0, n
  syscall
  jr $ra
  
find_in_array:

  sub $t9, $a2, $t1	# sets $t9 to the halfway point
  srl $t9, $t9, 1
  add $t9, $t9, $t1	
  
  move $t2, $t9		# gets index of i
  sll $t2, $t2, 2
  add $t2, $t2, $t0
  lw $t8, 0($t2)
  
  beq $t8, $v0, equal
  blt $t8, $v0, less_than
  bgt $t8, $v0, more_than
  
equal:
  move $a3, $t9		# moves end of array marker to half way and sets new lowest index
  move $a2, $t9
  beq $a2, $t1, return
  j find_in_array
less_than:
  move $t1, $t9		# moves starting marker to halfway point
  beq $a2, $t1, return
  addi $t1, $t1, 1
  j find_in_array
more_than:
  move $a2, $t9		# moves end of array marker to half way
  beq $a2, $t1, return
  j find_in_array
return:
  jr $ra
  
  

  
  
