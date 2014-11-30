.data
#board: .space 8#board
.align 2
notInDict: .asciiz "You word is not a real word"
.align 2
invalid: .asciiz "Your word is invalid"
.align 2 
valid: .asciiz "Your word is valid"
.align 2
shuffle: .asciiz "1\n"

.text


.globl main
.include "dictionary.asm"
.include "Shuffle_Randomize_Words.asm"
.include "checkinput.asm"
.include "compWords.asm"
.include "Timer.asm"

main:
jal	getNameFile
jal	importWords
li	$s3, 0
jal	initDict
jal	pickWord
add	$s3, $a0, $0
jal 	getWord

la	$t0, boardWord
lw	$t1, ($t0)
lw	$t2, ($t1)

la	$t3, wordArray
l:
lb	$t4, ($t2)
beq	$t4, 0x00, e
sb	$t4, ($t3)
add	$t3, $t3, 1
add	$t2, $t2, 1
j	l
e:
jal	findEnd


jal	Shuffle
jal	time#################################################
jal	compareTime
mainLoop:

li	$v0, 4
la	$a0, askinput
syscall

li	$v0, 8
la	$a0, input
li	$a1, 16
syscall	

la	$t0, input
lw	$t0, ($t0)
la	$t1, shuffle
lw	$t1, ($t1)
beq	$t0, $t1, Shuffle

la	$t0, input
capsLoop:
lb	$t1, ($t0)
beq	$t1, 0x0a, endCapsLoop
li	$t2, 0x60
bgt	$t2, $t1, isCaps
	add	$t1, $t1, -32
	sb	$t1, ($t0)
isCaps:
add	$t0, $t0, 1
j	capsLoop
endCapsLoop:


la	$a0, input
la	$a1, wordArray
jal	checkLength
beq	$v0, 0, iV
la	$a0, input
la	$a1, wordArray
jal	checkMiddleLetter
beq	$v0, 0, iV
la	$a0, input
la	$a1, wordArray
jal	checkChars
beq	$v0, 0, iV

la	$t0, input
l2:
lb	$t1, ($t0)
beq	$t1, 0x0a, e2
add	$t0, $t0, 1
j	l2
e2:
li	$t1, 0x0d
sb	$t1, ($t0)

la	$t0, boardWord
lw	$s1, ($t0)
la	$t0, endAddr
lw	$s0, ($t0)
add	$s1, $s1, 4
compLoop:
beq	$s0, $s1, endCompLoop
lw	$a0, ($s1)
la	$a1, input
jal	compareWords
beq	$v0, 1, goodCLM
add	$s1, $s1, 4
j	compLoop
endCompLoop:
j	iV
goodCLM:
li	$v0, 4
la	$a0, valid
syscall

jal	wordCorrect
jal	compareTime
jal	disBoard
j	mainLoop

iV:
jal	compareTime
li	$v0, 4
la	$a0, invalid
syscall
li	$v0, 11
la	$a0, 0x0a
syscall
jal	disBoard
j	mainLoop	


exit:
li	$v0, 10
syscall
