.data
askinput: .asciiz "Input: "
askboard: .asciiz "Board: "
notLong: .asciiz "Your word is not 4 letters or longer\n"
notMiddle: .asciiz "Your word does not contain the middle letter\n"
notInWord: .asciiz "Your word is not in the board\n"
.align 2
input: .space 64
.align 2
board: .space 16


.text

main:
	li	$v0, 4
	la	$a0, askinput
	syscall
	li	$v0, 8
	la	$a0, input
	li	$a1, 16
	syscall	
	li	$v0, 4
	la	$a0, askboard
	syscall
	li	$v0, 8
	la	$a0, board
	li	$a1, 64
	syscall
	
	la	$a0, input
	la	$a1, board
	jal	checkLength
	la	$a0, input
	la	$a1, board
	jal	checkMiddleLetter
	la	$a0, input
	la	$a1, board
	jal	checkChars


exit:
	li	$v0, 10
	syscall



#check length
checkLength:
#returns 1 if 4 letters or longer 0 otherwise
	add	$t1, $a0, $0
	li	$t2, 0
numLoop:
	lb	$t3, ($t1)
	beq	$t3, 0xa, end_numLoop
	addi	$t2, $t2, 1
	addi	$t1, $t1, 1
	j	numLoop
end_numLoop:
	bgt	$t2, 3, goodL 
	la	$a0, notLong
	li	$v0, 4
	syscall
	li	$v0, 0
	jr	$ra
goodL:
	li	$v0, 1
	jr	$ra

#check middle letter
checkMiddleLetter:
#returns 1 if input contains the middle letter on the board 0 otherwise
	add	$t0, $a0, $0
	add	$t1, $a1, $0
	lb	$t1, 4($t1)
mLoop:
	lb	$t2, ($t0)
	beq	$t2, 0xa, end_mLoop
	beq	$t2, $t1, goodM
	
	addi	$t0, $t0, 1
	j	mLoop
end_mLoop:
	la	$a0, notMiddle
	li	$v0, 4
	syscall
	li	$v0, 0
	jr	$ra
goodM:
	li	$v0, 1
	jr	$ra

#check characters in word
checkChars:
#returns 1 if input is in the board 0 otherwise
	add	$t0, $a0, $0	
ocLoop:
	lb	$t2, ($t0)
	beq	$t2, 0xa, end_ocLoop
	add	$t1, $a1, $0
	icLoop:
		lb	$t3, ($t1)
		beq	$t3, 0xa, end_icLoop
		bne	$t2, $t3, notEq
		li	$t4, 1
		j	end_icLoop
	notEq:	
		add	$t1, $t1, 1
		j	icLoop
	end_icLoop:
	beq	$t4, 0, badC
	li	$t4, 0
	add	$t0, $t0, 1
	j	ocLoop
end_ocLoop:	
	j	goodC
badC:
	li	$v0, 4
	la	$a0, notInWord
	syscall
	li	$v0, 0
	jr	$ra		
goodC:
	li	$v0, 1
	jr	$ra
	
	
	
	#still needs to check if the input is a real word
	
