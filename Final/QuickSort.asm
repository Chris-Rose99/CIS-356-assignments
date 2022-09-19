# Christopher Rose
# Assembly 356
# P007
  .data
	
A: .space 124
prompt: .asciiz "Give me an integer  "	
fill:  .asciiz "Fill the array 
print: .asciiz "Array A: "
n:	.asciiz "\n"
space: .asciiz " "
T:  .asciiz "The array is sorted."
F: .asciiz "The array is not sorted."
  .text
main:
  
  li $v0, 4		# prompts the user for integers
  la $a0, fill
  syscall
  la $a0, n
  syscall
  	
  la $t0, A		# the array A
  li $a1, 31		# Size of array argument
  li $t1, 0		# i for the for loop
  jal fill_array
  move $t3, $t1
  		
  jal check_sort	# Checks to see if the array is sorted
  
  addi $s1, $t3, -1	# $s1 = the number of elements used (j)
  li  $s0, 0		# $s0 = the beginning of the array (i)
  sll $t3, $t3, 2
  jal sort_array	
  
  li $v0, 4
  la $a0, n
  syscall
  la $a0, print
  syscall
  jal print_array	# prints the array
	
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
	
check_sort:
  li $t1, 1
  li $t4, 0
  li $a3, 1	# returned value if array is sorted
Loop2:
  bgt   $t1, $a0, endLoop2
  
  move  $t2, $t4	
  sll  $t2, $t2, 2
  add  $t2, $t2, $t0
  lw  $a1, 0($t2)
  move  $t2, $t1	
  sll  $t2, $t2, 2
  add  $t2, $t2, $t0
  lw  $a2, 0($t2)
  blt $a2, $zero, endLoop2
  
  blt $a2, $a1, unsorted
  addi $t1, $t1, 1
  addi $t4, $t4, 1
  j Loop2 
unsorted:
  li $a3, 0
  j endLoop2
endLoop2:
  beq $a3, 0, False	# If check_sort returned 0 then the array isn't sorted
  beq $a3, 1, True	# If check_sort returned 1 then the array is sorted
False:
  li $v0, 4
  la $a0, F
  syscall
  jr $ra
True:
  li $v0, 4
  la $a0, T
  syscall
  jr $ra
  
sort_array:
  move $s7, $t0
quick:
  add $sp , $sp , 16
  sw $ra , 0($sp) # return address
  
  sw $t3 , 4($sp) # elements in the array
  sw $t0 , 8($sp) # array address
  sw $s0 , 12($sp) # i
  
  add $s2, $s1, $s0	# the middle element in the array is the partition
  srl $s2, $s2, 1
  sll $s2, $s2, 2
  add $s2, $s2, $t0
  lw  $s3, 0($s2)	# $s3 is the pivot 
while:
  bgt $s0, $s1, swap
while_i:
  sll $t5, $s0, 2
  add $t6, $t5, $t0
  lw  $t5, 0($t6)
  bge $t5, $s3, while_j
  addi $s0, $s0, 1
  j while_i
while_j:
  sll $t7, $s1, 2
  add $t8, $t7, $t0
  lw  $t7, 0($t8)
  ble $t7, $s3, swap
  addi $s1, $s1, -1
  j while_j
swap:  
  bgt $s0, $s1, after
  sw $t5, 0($t8)
  sw $t7, 0($t6)
  addi $s0, $s0, 1
  addi $s1, $s1, -1
  j while
after:
  sw $s0, 12($sp)
r1:
  blez $s1, r2
  add $t3, $s1, 1
  jal quick
r2:
  lw $t3, 4($sp)
  lw $s0, 12($sp)
  add $s6, $t3, -1
  bge $s0, $s6, end_sort  
  sll $t2, $s0, 2
  add $s6, $s6, $t2
  sub $t3, $t3, $s0
  jal quick
end_sort:
  lw $ra, 0($sp)
  lw $t3, 4($sp) 
  lw $t0, 8($sp) 
  lw $s0, 12($sp) 
  j print_array
  
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
