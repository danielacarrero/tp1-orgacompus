#include <regdef.h>


.data
ime: .asciiz "TP1 2Q2019: Implement me!"
allowed_forward: .word step_north, step_south, step_east, step_west
rotation_rules: .word 3, 2
                .word 2, 3
                .word 0, 1
                .word 1, 0
relevant_bounds: .space 16 # 4-element int vector

.text
.align 2
.globl new_orientation
.ent new_orientation

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

    move t4, s0    # Cargo la orientation (Row)
    move t5, s1    # Cargo la rule (Col)

    mul t4, t4, 2  # (Row * Cantidad de columnas)
    addu t4, t5     # Le sumo la columna a la que quiero llegar
    sll t4, 2       # Multiplico por size de int

    la t0, rotation_rules

    addu t6, t0, t4 # Cargo en t4 el valor almacenado en la posicion de la tabla [Row, Col]
    lw v0, 0(t6)

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


move_forward:
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
	move s2, a2

  la t0, relevant_bounds # Start of vector

  sw s2, 0(t0)
  sw s2, 4(t0)
  sw s1, 8(t0)
  sw s1, 12(t0)

  lw t1, 8(s0)
  sll t1, 2

  addu t2, t0, t1
  lw a1, 0(t2) #en a1 guardo el valor de bound

  la t3, allowed_forward

  addu t4, t3, t1
  lw t9, 0(t4)

  sw a0, 0(sp)
  sw a1, 4(sp)

  jal t9

  move a0, s0
	move a1, s1
  move a2, s2
  move v0, a0
	lw fp, 28(sp)
  lw ra, 32(sp)
	addiu sp, sp, 40
	jr ra
.end move_forward

.text
.align 2
.globl step_west
.ent step_west

step_west:
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

	la a0, 0(s0)
	lw t0, 0(s0)
	addiu a1, t0, (-1)
	move a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust

  move a0, s0
	move a1, s1
	lw fp, 20(sp)
  lw ra, 24(sp)
	addiu sp, sp, 32
	jr ra
.end step_west

.text
.align 2
.globl step_east
.ent step_east

step_east:
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

	la a0, 0(s0)
	lw t0, 0(s0)
	addiu a1, t0, 1
	move a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust

  move a0, s0
	move a1, s1
	lw fp, 20(sp)
  lw ra, 24(sp)
	addiu sp, sp, 32
	jr ra
.end step_east

.text
.align 2
.globl step_north
.ent step_north

step_north:
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

	la a0, 4(s0)
	lw t0, 4(s0)
	addiu a1, t0, (-1)
	move a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust

  move a0, s0
	move a1, s1
	lw fp, 20(sp)
  lw ra, 24(sp)
	addiu sp, sp, 32
	jr ra
.end step_north

.text
.align 2
.globl step_south
.ent step_south

step_south:
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

	la a0, 4(s0)
	lw t0, 4(s0)
	addiu a1, t0, 1
	move a2, s1
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	jal doAdjust

  move a0, s0
	move a1, s1
	lw fp, 20(sp)
  lw ra, 24(sp)
	addiu sp, sp, 32
	jr ra
.end step_south
