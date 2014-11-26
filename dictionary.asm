# dictionary of words are stored in files named as the first letter of each word.
.data
dictBuffer: .space 50000 #creates a buffer to store words
dict: .space 50000 #allocates space for dict array
dictLength: .space 8
fileName: .space 32
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
	li $v0, 14 # syscall for read from file
	la $a1, dictBuffer #address of buffer
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
