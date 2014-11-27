.data
testWord: .asciiz "abandoned"
wordArray: .space 9
.text

Shuffle:
addi	$sp, $sp, -4			#Make room on the stack
sw	$ra, ($sp)			#Store the return addess on the stack	
add	$t0, $zero, $zero		#Counter
la	$s2, wordArray	

RandomizeProcess:

beq $t0, 8, EndRandomizeProcess 	#When counter equals 9, exit Randomize process. 

li $v0, 42				#Will put a pseudorandom number in $a0
li $a1, 9				#Upperbound of returned values. 
syscall

move $a3, $a0				#Put pseudorandom number in $a3
addi $t0, $t0, 1			#Update counter
beq $a3, 4, RandomizeProcess
bne $t0, 4, Swap

j RandomizeProcess	

Swap:
beq $t0, $a3, RandomizeProcess		#If the random number generated is equal the counter,  repeat randomize process
					#If not equal, then swap the the letter that $t0 index points too in the 9 letter word array with the letter that the value in $a3 points to in the array					
lb 	$t2, wordArray($t0)	#load the letter at t0 into t2
lb 	$t3, wordArray($a3)	#load character at t1 into t3
sb 	$t3, wordArray($t0)	#store character in t3 into location at t0
sb 	$t2, wordArray($a3)	#store character in t2 into location at t1

j RandomizeProcess					
EndRandomizeProcess:

DisplayWord:			#Display's Randomized Word in three lines
la $a3, wordArray
li $a2, 0

loop:
lb $s1, ($a3)
addi $a2, $a2, 1
addi $a3, $a3, 1

move $a0, $s1
li $v0, 11 
syscall

beq $a2, 3, newLine
beq $a2, 6, newLine
beq $a2, 9, ReturntoCaller
j loop

endLoop:
li $v0, 10
syscall

newLine:
li $v0, 11
li $a0, 10
syscall
j loop	

ReturntoCaller:			#clean up the stack
lw	$ra, ($sp)		#restore return address
addi	$sp, $sp, 4	
jr	$ra





