#include <regdef.h>


.data
ime: .asciiz "TP1 2Q2019: Implement me!"
err: .asciiz "Unknown orientation %d"

.text
.align 2
.globl decide
.ent decide

decide:
	.frame fp, 8, ra
	.set noreorder
	.cpload t9
	.set reorder
	addiu sp, sp, (-8)
	.cprestore 0
	sw fp, 4(sp)
	move fp, sp

	beq a0, 1, go_right

	move v0, a1
	j fin3

go_right:
	move v0, a2

fin3:
	lw fp, 4(sp)
	addiu sp, sp, 8
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
	addiu sp, sp, (-40)
	.cprestore 24
	sw fp, 28(sp)
	sw ra, 32(sp)
	move fp, sp

	move s0, a0
	move s1, a1

	beq s0, 0, N
	beq s0, 1, S
	beq s0, 2, E
	beq s0, 3, W

	move v0, $0
	la a0, err
	sw a0, 0(sp)
	jal doPanic

fin:
	sw v0, 16(sp)
	move a0, s0
	move a1, s1
	lw fp, 28(sp)
	lw ra, 32(sp)
	addiu sp, sp, 40
	jr ra

N:
	move a0, s1
	lw a1, 3
	lw a2, 2
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal decide
	j fin
S:
	move a0, s1
	lw a1, 2
	lw a2, 3
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal decide
	j fin
E:
	move a0, s1
	lw a1, 0
	lw a2, 1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal decide
	j fin
W:
	move a0, s1
	lw a1, 1
	lw a2, 0
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
	addiu sp, sp, (-32)
	.cprestore 16
	sw fp, 20(sp)
	sw ra, 24(sp)
	move fp, sp

	move v0, a0

	move s0, a0
	move s1, a1
	move s2, a2

	lw t0, 8(s0)
	beq t0, 0, N2
	beq t0, 1, S2
	beq t0, 2, E2
	beq t0, 3, W2

	la a0, err
	sw a0, 0(sp)
	jal doPanic

fin2:
	move a0, s0
	move a1, s1
	move a2, s2
	lw fp, 20(sp)
	lw ra, 24(sp)
	addiu sp, sp, 32
	jr ra

N2:
	lw a0, 4(s0)
	addiu a1, a0, (-1)
	move a2, s2
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust
	j fin2
S2:
	lw a0, 4(s0)
	addiu a1, a0, 1
	move a2, s2
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust
	j fin2
E2:
	lw a0, 0(s0)
	addiu a1, a0, 1
	move a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust
	j fin2
W2:
	lw a0, 0(s0)
	addiu a1, a0, (-1)
	move a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust
	j fin2

.end move_forward
