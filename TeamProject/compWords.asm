.data
ask1: .asciiz "Word 1: "
ask2: .asciiz "Word 2: "
.align 2
word1: .space 32
.align 2
word2: .space 32


.text

compareWords:
#currently case sensitive
#$a0 word 1
#$a1 word 2
#compares word 1 and word 2 and returns 1 if they are equal and 0 otherwise
	add	$t0, $a0, $0
	add	$t1, $a1, $0
	
cwLoop:
	lb	$t2, ($t0)
	lb	$t3, ($t1)
	bne	$t2, $t3, wbadC
	beq	$t2, 0xd, end_cwLoop
	add	$t0, $t0, 1
	add	$t1, $t1, 1
	j	cwLoop
end_cwLoop:	
	j	wgoodC
wbadC:
	li	$v0, 0	
	jr	$ra	
wgoodC:
	li	$v0, 1
	jr	$ra
