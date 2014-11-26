.data 
TimesUp: .asciiz "Time's up!" 

.text
main:

jal time

li $v0, 5
syscall

jal compareTime
jal displayTime


return:
li $v0, 10
syscall

#Get initial time
time:
li $v0, 30		#Put lower 32 bits in $a0
syscall
move $s1, $a0		#Make a copy of the value in $a0 and store in $s1

jr $ra

#Get current time
compareTime:
li $t0, 60		#holds "60" seconds
li $v0, 30		#Put lower 32 bits in $a0
syscall
move $s2, $a0		#Make a copy of the value in $a0 and store in $s2

#Find difference between the times
sub $s2, $s2, $s1
div $s2, $s2, 1000
bgt $s2, $t0, EndGame
jr $ra

EndGame:		#After 60 seconds, game timer ends
la $a0, TimesUp
li $v0,4
syscall

j return

displayTime:		
move $a0, $s2
li $v0,1
syscall
jr $ra

wordCorrect:			#Adds 20 seconds to the clock when a valid word is entered
add $t0, $t0, 20
jr $ra
