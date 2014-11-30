# dictionary of words are stored in files named as the first letter of each word.
.data
.align 2
dictBuffer: .space 700000 #creates a buffer to store words
dict: .space 700000 #allocates space for dict array
dictLength: .space 8
fileName: .space 32
printWord: .space 64
boardWord: .space 8#address of word
endAddr: .space 8#addres of next astric
.text

getNameFile:
	li $v0, 41 #syscall for random number
	syscall		
	
	divu $t0,$a0,26 #div random number by 26 
	mfhi $t0
	addi $t0,$t0,'A' #adds a to get ascii value for letter
	la $t1, fileName #s0 stores file name
	sb $t0,($t1) #stores word in $t1
	sb $zero,1($t1)	#adds null to end of $s0
	jr $ra
	
importWords:
	li $v0, 13 #syscall for opening a file
	la $a0, fileName #load address into $a0
	li $a1,0 #sets flag to 0
	li $a2,0 #sets max characters to read to 0
	syscall
	move $s0, $v0 #save file location
	move $a0, $v0
	li $v0, 14 # syscall for read from file
	la $a1, dictBuffer #address of buffer
	li $a2, 700000
	syscall
	li $v0,16 # Syscall for closing the file
	move $a0,$s0
	syscall
	jr $ra
	
initDict:
	la $a0, dictBuffer	#scanner
	la $a1, dict
	sw $a0, ($a1)		#scanner points to array
	add $v1, $0, $0		#default list size is0
	add $v1, $v1, 1		#increment the length of dict
	add $a1, $a1, 4		#Move the dictionaryArray point over to next storing location
initDictLoop:
	lb $t0, ($a0) #loads byte from dictionary
	beq $t0, 0, initDictLoopExit #exits loop at null 
	bne $t0, 0x2a, noWord
	add $s3, $s3, 1
noWord:
	bne $t0,10, fillSkipped
	sb $zero, ($a0)		#change newline to null
	add $a0, $a0, 1		#increments scanner
	sw $a0, ($a1)		#store scanner in dict
	add $a1, $a1, 4		#advances pointer
	add $v1, $v1, 1		#add 1 to the number of words.
	j initDictLoop
fillSkipped:
	add $a0,$a0,1	#increments scanner
	j initDictLoop
initDictLoopExit:
	sw $v1, dictLength 
	jr $ra
	
pickWord:
	li	$a0, 0
	add	$a1, $s3, -1
	li	$v0, 42
	syscall
	jr	$ra
	
getWord:
	la	$t0, dict
	la	$t2, dictLength
	lw	$t2, ($t2)
	li	$t5, 0
	li	$t6, 0
getWordLoop:
	beq	$t5, $t2, endGetWordLoop
	lw	$t3, ($t0)
	lb	$t4, ($t3)
	bne	$t4, 0x2a, notAst
	add	$t6, $t6, 1
	beq	$t6, $s3, endGetWordLoop
notAst:
	add	$t0, $t0, 4
	add	$t5, $t5, 1
	j	getWordLoop
endGetWordLoop:	
	add	$t0, $t0, 4
	la	$t1, boardWord
	sw	$t0, ($t1)
	jr	$ra
	
findEnd:
	la	$t0, boardWord
	lw	$t0, ($t0)
	add	$t0, $t0, 4
findEndLoop:
	lw	$t2, ($t0)
	lb	$t1, ($t2)
	beq	$t1, 0x2a, endFindEndLoop
	add	$t0, $t0, 4
	j	findEndLoop
endFindEndLoop:
	la	$t1, endAddr
	sw	$t0, ($t1)
	jr	$ra
	
printDict:
	la	$t0, dict
	la	$t2, dictLength
	lw	$t2, ($t2)
	li	$t5, 0
printLoop:
	beq	$t5, $t2, endPrintLoop
	la	$t1, printWord
	sw	$0, ($t1)
	add	$t1, $t1, 4
	sw	$0, ($t1)
	add	$t1, $t1, -4
	lw	$t3, ($t0)
	wordLoop:
		lb	$t4, ($t3)
		beq	$t4, 0x00, endWordLoop
		sb	$t4, ($t1)
		add	$t3, $t3, 1
		add	$t1, $t1, 1
		j	wordLoop
	endWordLoop:
	li	$v0, 4
	la	$a0, printWord
	syscall
	li	$v0, 11
	li	$a0, 0x0a
	syscall
	add	$t0, $t0, 4
	add	$t5, $t5, 1
	j	printLoop
endPrintLoop:		
	jr	$ra
