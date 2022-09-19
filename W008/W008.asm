  .data
prompt:  .asciiz "Give me an integer: "
str: .space 80

  .text

main:
  la $t0, str
  li $v0, 4		# prompts the user for an integer
  la $a0, prompt	# reads integer as a string that can be 10 characters long
  syscall
  li $v0, 8
  li $a1, 10
  syscall
  
  beq $v0, $zero, end	# ends program if user enters 0 or nothing
  li $t1, 0
  j Loop
Loop:
  move  $t2, $t1	# stores each character from the string into str
  sll  $t2, $t2, 2
  add  $t2, $t2, $t0
  lb  $a1, 0($t2)
  beq $a1, $zero, atoi	# stops storing integers after 0
  sb  $a1, 0($t2)
  
  addi $t1, $t1, 1
  j Loop
  
atoi:
  li $t1, 0
Loop2:
  move  $t2, $t1	# stores each character from the string into str
  sll  $t2, $t2, 2
  add  $t2, $t2, $t0
  lb  $t3, 0($t2)	# $t3 = y
  
  add $t8, $t4, $t4             # multiplies $t4 by 10, $t4 = x
  add $t9, $t8, $t8             # x * 10 + y 
  add $t9, $t9, $t9             
  add $t9, $t9, $t8             
  
  beq $t3, $zero, endLoop2
  add $t9, $t9, $t3
  addi $t1, $t1, 1
  j Loop2
  
endLoop2:
  move $a0, $t9
  li $v0, 1
  syscall
  j main
  
end: 
  li $v0, 10
  syscall
  