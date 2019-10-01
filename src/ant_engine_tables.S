#include <regdef.h>

.data
ime: .asciiz "TP1 2Q2019: Implement me!"

.text
.align 2
.globl new_orientation
.ent new_orientation

rotation_rules: .space 32 # 8-element int table

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

    li t4, 0(s0)    # Cargo la orientation (Row)
    li t5, 0(s1)    # Cargo la rule (Col)
    li t6, 2        # Cantidad de columnas de la tabla

    mul t4, t4, t6  # (Row * Cantidad de columnas)
    addu t4, t5     # Le sumo la columna a la que quiero llegar
    sll t4, 2       # Multiplico por size de int

    la t4, (t4)(t0) # Cargo en t4 el valor almacenado en la posicion de la tabla [Row, Col]

    move a0, s0
	move a1, s1
	lw fp, 28(sp)
	lw ra, 32(sp)
	addiu sp, sp, 40
	jr ra

    move v0, $0     # No deberia llegar aca
	la a0, err
	sw a0, 0(sp)
	jal doPanic
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

    move s0, a0
	move s1, a1
	move s2, a2


    la a0, ime
    jal doPanic
.end move_forward