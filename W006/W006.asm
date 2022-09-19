# Christopher Rose
# W006 fib.s
# Assembly 356
	.data
	
prompt: .asciiz "Give me an Integer."
Iter:  .asciiz "The iterative result was "
rec:  .asciiz "The recursive result was "
given:  "You gave the number: "
n:  .asciiz "\n"
	.text
	
_start:
  jal   main	#ends program
  li    $v0, 10
  syscall
  
main:

  addi $t4, $t4, 0	#sets two ints 1 and 0
  addi $t5, $t5, 1
  
  li $v0, 4		#asks for n
  la $a0, prompt
  syscall
  
  li $v0, 5		#stores n
  syscall
  move $t0, $v0
  
  li $v0, 4		#displays n
  la $a0, given
  syscall
  
  li $v0, 1
  move $a0, $t0
  syscall
  
  li $v0, 4		
  la $a0, n
  syscall
  
  j iterativeFib
  
  j recursiveFib
  
  
iterativeFib:			#int t1 = 0; int t2 = 1
  li $a2, 0			#for(a2=0;a2<n;a2++) { t3 = t2 + t1; t1 = t2; t2 = t3;}
  addi $t1, $zero, 0
  addi $t2, $zero, 1
loop:  beq $a2, $t0, endLoop
  add  $t3, $t2, $t1
  move  $t1, $t2
  move  $t2, $t3
  addi $a2, $a2, 1
  j loop
  
endLoop:

  li $v0, 4			#print iterative results
  la $a0, Iter
  syscall
  
  li $v0, 1
  move $a0, $t1
  syscall
  
  li $v0, 4		
  la $a0, n
  syscall
  
  
recursiveFib:
  add $t6, $t4, $t5		#Fib(t0) { t6 = t4 + t5; t4= t5; t5 = t6
  move $t4, $t5			# t0--; if (t0 > 0) Fib(t0); else prints recursive result
  move $t5, $t6
  
  addi $t0, $t0, -1
  bgt $t0, 0, recursiveFib
  
  li $v0, 4		
  la $a0, rec
  syscall
  
  li $v0, 1
  move $a0, $t4
  syscall
  
  jr $ra