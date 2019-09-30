#include <regdef.h>
#include "ant_engine.h"


.data
ime: .asciiz "TP1 2Q2019: Implement me!"
err: .asciiz "Unknown orientation %d"

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
	.frame fp, 40, ra
	.set noreorder
	.cpload t9
	.set reorder
	subu sp, sp, 40
	cpstore 24
	sw fp, 28(sp)
	sw ra, 32(sp)
	move fp, sp
	
	move s0, a0
	move s1, a1

	beq s0, NORTH, N
	beq s0, SOUTH, S
	beq s0, EAST, E
	beq s0 WEST, W

	move v0, $0
	move a0, err
	move a1, s0
	sw a0, 0(sp)
	sw a1, 4(sp)
	jal panicd

fin:
	sw v0, 16(sp)//guardo en la posicion de la var local el rtdo
	lw a0, s0	
	lw a1, s1 //Vuelvo a dejar los regs $a como estaban
	lw fp, 28(sp)
	lw ra, 32(sp)
	addu sp, sp, 40
	jr ra
	
N:	
	move a0, s1
	lw a1, WEST
	lw a2, EAST
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal decide
	j fin
S:
	move a0, s1
	lw a1, EAST
	lw a2, WEST
	sw a0, 0(sp)	
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal decide
	j fin
E:
	move a0, s1
	lw a1, NORTH
	lw a2, SOUTH
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal decide
	j fin
W:
	move a0, s1
	lw a1, SOUTH
	lw a2, NORTH
	sw a0, 0(sp)	
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
    .frame fp, 32, ra
	.set noreorder
	.cpload t9
	.set reorder
	subu sp, sp, 32
	cpstore 16
	sw fp, 20(sp)
	sw ra, 24(sp)
	move fp, sp
	
	move v0, a0//voy poniendo ant en lo que se devuelve

	move s0, a0
	move s1, a1
	move s2, a2

	beq 8(s0), NORTH, N
	beq 8(s0), SOUTH, S
	beq 8(s0), EAST, E
	beq 8(s0), WEST, W
	
	move a0, err
	move a1, 8(s0)
	sw a0, 0(sp)
	sw a1, 4(sp)
	jal panicd

fin:
	lw a0, s0	
	lw a1, s1 //Vuelvo a dejar los regs $a como estaban
	lw a2, s2
	lw fp, 20(sp)
	lw ra, 24(sp)
	addu sp, sp, 32
	jr ra
	
N:	
	move a0, 4(s0)
	subu a1, 4(s0), 1
	lw a2, s2
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal adjust
	j fin
S:
	move a0, 4(s0)
	addu a1, 4(s0), 1
	lw a2, s2
	sw a0, 0(sp)	
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal adjust
	j fin
E:
	move a0, (s0)
	addu a1, (s0), 1
	lw a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal adjust
	j fin
W:
	move a0, (s0)
	subu a1, (s0), 1
	lw a2, s1
	sw a0, 0(sp)	
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal adjust
	j fin
	
.end move_forward
