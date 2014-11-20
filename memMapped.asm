.text
main:
	li    $a0, 0xFFFF0000 # Receiver control
        lw    $t0, 0($a0)
        ori   $t0, 0x02       # set bit 1 to enable input interrupts
                              # such a-synchronous I/O (handling of keyboard input in this case) 
                              # this is much more efficient than the "polling" we use for output
                              # In particular, it does not "block" the main program in case there is no input
        sw     $t0, 0($a0)    # update Receiver control

        mfc0   $t0, $12   # load coprocessor0 Status register
        ori    $t0, 0x01  # set interrupt enable bit 
        mtc0   $t0, $12   # move into Status register
   
infinite:
   j	infinite
   
   
   .ktext 0x80000180
   .set	noat
   move	$k0, $at
   .set	at
   la	$k1, ktemp
   sw 	$v0, 0($k1)   # Save $v0 value
   sw 	$a0, 4($k1)   # Save $a0 value
   
   la   $a0, msg  
   li   $v0, 4    
   syscall
   li   $a0, 0xFFFF0004 
   lw   $v0, 0($a0)
   #la	$a0, char
   #sw	$v0, ($a0)
   sw   $v0, 0xFFFF000C
   #la	$a0, char
   #li	$v0, 4
   #syscall
   
   lw   $v0, 0($k1)   # Restore $v0
   lw   $a0, 4($k1)   # Restore $a0
   .set	noat
   move	$at, $k0
   .set at
   
   eret           # Error return; set PC to value in $14
   .kdata	
msg:   
   .asciiz "Interupt generated\n"
ktemp:	.space 16
char:	.ascii	" "
