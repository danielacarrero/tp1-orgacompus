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
	.frame fp, 32, ra
	.set noreorder
	.cpload t9
	.set reorder
	subu sp, sp, 32
	cpstore 16
	sw fp, 20(sp)
	sw ra, 24(sp)
	move fp, sp
	
	move s0, a0
	move s1, a1

	move a0, s1 //El primer argumento de decide sea rule
	sw a0, 0(sp)// Ya lo pongo en el stack

	beq s0, NORTH, N
	beq s0, SOUTH, S
	beq s0, EAST, E
	beq s0 WEST, W

	move v0, $0
	jal doPanic

fin:
	lw fp, 20(sp)
	lw ra, 24(sp)
	addu sp, sp, 32
	jr ra
	
N:	
	lw a1, WEST
	lw a2, EAST
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal decide
	j fin
S:
	lw a1, EAST
	lw a2, WEST
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal decide
	j fin
E:
	lw a1, NORTH
	lw a2, SOUTH
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal decide
	j fin
W:
	lw a1, SOUTH
	lw a2, NORTH
	sw a1, 4(sp)
	sw a2, 8(sp)
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
