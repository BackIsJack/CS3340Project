.data 
TimesUp: .asciiz "Time's up!"
.align 2
scoreIs: .asciiz "Your score is: "
.align 2
timeLeft: .asciiz "Time left: "

.text
#main:

#jal time

#li $v0, 5
#syscall

#jal compareTime
#jal displayTime


return:
li $v0, 10
syscall

#Get initial time
time:
li $s6, 60
li $v0, 30		#Put lower 32 bits in $a0
syscall
move $s4, $a0		#Make a copy of the value in $a0 and store in $s4

jr $ra

#Get current time
compareTime:
li $v0, 30		#Put lower 32 bits in $a0
syscall
move $s5, $a0		#Make a copy of the value in $a0 and store in $s5
li $v0, 1

#Find difference between the times
sub $s5, $s5, $s4
div $s5, $s5, 1000
bgt $s5, $s6, EndGame
sub $t0, $s6, $s5
li $v0, 11
li $a0, 0x0a
syscall
li $v0, 4
la $a0, timeLeft
syscall
li $v0, 1
add $a0, $0, $t0
syscall
li $v0, 11
li $a0, 0x0a
syscall
jr $ra

EndGame:		#After 60 seconds, game timer ends
la $a0, TimesUp
li $v0,4
syscall
li $v0, 11
li $a0, 0x0a
syscall
la $a0, scoreIs
li $v0, 4
syscall
add $a0, $s7, $0
li $v0, 1
syscall

j return

displayTime:		
move $a0, $s5
li $v0,1
syscall
jr $ra

wordCorrect:			#Adds 20 seconds to the clock when a valid word is entered
add $s6, $s6, 20
add $s7, $s7, 10
jr $ra
