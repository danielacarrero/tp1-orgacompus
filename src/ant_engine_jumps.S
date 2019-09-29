#include <regdef.h>

.data
ime: .asciiz "TP1 2Q2019: Implement me!"


decide:
	.frame fp, 8, ra
	.set noreorder
	.cpload t9
	.set reorder
	subu sp, sp, 8
	cpstore 0
	sw fp, 4(sp)
	move fp, sp

	beq a0, RIGHT, go_right
	
	move v0, a1
	j fin

go_right:	
	move v0, a2	

fin:	
	lw fp, 4(sp)
	addu sp, sp, 8
	jr ra
.end decide




.text
.align 2
.globl new_orientation
.ent new_orientation

new_orientation:
	.frame fp, 16, ra
	.set noreorder
	.cpload t9
	.set reorder
	subu sp, sp, 16
	cpstore 0
	sw fp, 4(sp)
	sw ra, 8(sp)
	move fp, sp

	beq a0, NORTH, N
	beq a0, SOUTH, S
	beq a0, EAST, E
	beq a0 WEST, W

	move v0, $0
	jal doPanic

fin:
	lw fp, 4(sp)
	lw ra, 8(sp)
	addu sp, sp, 16
	jr ra
	
N:
	jal decide
	j fin
S:
	jal decide
	j fin
E:
	jal decide
	j fin
W:
	jal decide
	j fin

		 	
	

.end new_orientation

.text
.align 2
.globl move_forward
.ent move_forward
move_forward:
    la a0, ime
    jal doPanic
.end move_forward
