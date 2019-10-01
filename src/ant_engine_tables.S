#include <regdef.h>

.data
ime: .asciiz "TP1 2Q2019: Implement me!"

.text
.align 2
.globl new_orientation
.ent new_orientation

rotation_rules: .space 32 # 8-element int table

new_orientation:
  .frame fp, 16, ra
	.set noreorder
	.cpload t9
	.set reorder
	addiu sp, sp, (-16)
	.cprestore 8
	sw fp, 12(sp)
	move fp, sp

	move s0, a0
	move s1, a1

    la t0, rotation_rules # Start of table
    li t1, 3
    sw t1, 0(t0)
    sw t1, 12(t0)
    li t1, 2
    sw t1, 4(t0)
    sw t1, 8(t0)
    li t1, 0
    sw t1, 16(t0)
    sw t1, 28(t0)
    li t1, 1
    sw t1, 20(t0)
    sw t1, 24(t0)

    move t4, s0    # Cargo la orientation (Row)
    move t5, s1    # Cargo la rule (Col)

    mul t4, t4, 2  # (Row * Cantidad de columnas)
    addu t4, t5     # Le sumo la columna a la que quiero llegar
    sll t4, 2       # Multiplico por size de int

    addu v0, t0, t4 # Cargo en t4 el valor almacenado en la posicion de la tabla [Row, Col]

  move a0, s0
	move a1, s1
	lw fp, 12(sp)
	addiu sp, sp, 16
	jr ra

.end new_orientation



.text
.align 2
.globl move_forward
.ent move_forward

allowed_forward: .space 4	# 4-element func table

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

    move s0, a0
	move s1, a1
	move s2, a2

	la t0, allowed_forward	# Start of table

	la t1, step_west
	sw t1, 0(t0)
	la t1, step_east
	sw t1, 1(t0)

    move v0, $0     # No deberia llegar aca
	la a0, err
	sw a0, 0(sp)
	jal doPanic
.end move_forward

.text
.align 2
.globl step_west
.ent step_west

step_west:
	.frame fp, 16, ra
	.set noreorder
	.cpload t9
	,set reorder
	addiu sp, sp, (-16)
	.cprestore 0	# No se que va desde aca
	sw fp, 4(sp)
	move fp, sp		# Hasta aca

	move s0, a0
	move s1, a1

	la a0, 0(s0)
	lw t0, 0(s0)
	addiu a1, t0, (-1)
	move a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust
.end step_west

.text
.align 2
.globl step_east
.ent step_east

step_east:
	.frame fp, 16, ra
	.set noreorder
	.cpload t9
	,set reorder
	addiu sp, sp, (-16)
	.cprestore 0	# No se que va desde aca
	sw fp, 4(sp)
	move fp, sp		# Hasta aca

	move s0, a0
	move s1, a1

	la a0, 0(s0)
	lw t0, 0(s0)
	addiu a1, t0, 1
	move a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust
.end step_east

.text
.align 2
.globl step_north
.ent step_north

step_north:
	.frame fp, 16, ra
	.set noreorder
	.cpload t9
	,set reorder
	addiu sp, sp, (-16)
	.cprestore 0	# No se que va desde aca
	sw fp, 4(sp)
	move fp, sp		# Hasta aca

	move s0, a0
	move s1, a1

	la a0, 4(s0)
	lw t0, 4(s0)
	addiu a1, t0, (-1)
	move a2, s2
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust
.end step_north

.text
.align 2
.globl step_south
.ent step_south

step_south:
	.frame fp, 16, ra
	.set noreorder
	.cpload t9
	,set reorder
	addiu sp, sp, (-16)
	.cprestore 0	# No se que va desde aca
	sw fp, 4(sp)
	move fp, sp		# Hasta aca

	move s0, a0
	move s1, a1

	la a0, 0(s0)
	lw t0, 0(s0)
	addiu a1, t0, 1
	move a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust
.end step_south
