.data
#board: .space 8#board
.align 2
notInDict: .asciiz "You word is not a real word"
.align 2
invalid: .asciiz "Your word is invalid"
.align 2 
valid: .asciiz "Your word is valid"
.text


.globl main
.include "dictionary.asm"
.include "Shuffle_Randomize_Words.asm"
.include "checkinput.asm"
.include "compWords.asm"

main:
jal	getNameFile
jal	importWords
li	$s3, 0
jal	initDict
jal	pickWord
add	$s3, $a0, $0
jal 	getWord

li	$v0, 4
la	$t0, boardWord
lw	$t1, ($t0)
lw	$t2, ($t1)
add	$a0, $t2, $0
syscall
li	$v0, 11
li	$a0, 0x0a
syscall

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
mainLoop:
li	$v0, 11
li	$a0, 0x0a
syscall

li	$v0, 4
la	$a0, askinput
syscall

li	$v0, 8
la	$a0, input
li	$a1, 16
syscall	

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
li	$v0, 4
la	$a0, notInDict
syscall
j	iV
goodCLM:
li	$v0, 4
la	$a0, valid
syscall
j	mainLoop

iV:
li	$v0, 4
la	$a0, invalid
syscall
j	mainLoop	


exit:
li	$v0, 10
syscall
