.global _start
.section .text

_start:
	push {r4-r11} @ Freeing r0-r11
	ldr r4, =colA
	ldr r5, =rowB
	ldr r5, [r5] @ dereferencing
	ldr r4, [r4]
	cmp r4, r5
	bne incom_exit

	@ r4 = common_factor see matMul.py for algorithm
	@ r5 = # of rows of resultant mat
	@ r6 = # of cols of resultant mat
	ldr r5, =rowA @ length
	ldr r6, =colB @ width
	ldr r5, [r5] @ de-ref
	ldr r6, [r6]

	@ r7 = counter1 (i), r8 = counter2 (j), r9 = counter3 (k)
	@ ... r10 = cell
	mov r7, #0
	forloop1:
		cmp r7, r5 @ for (int i = 0; i < length; i++)
		beq exit 


		mov r8, #0
		forloop2:
			cmp r8, r6
			beq .cntLP1
			
			mov r9, #0
			mov r10, #0 @ clear cell
			forloop3: @ coumter = k = r9
				cmp r9, r4 @ for (int k = 0; k < common; k++)
				beq .cntLP2

				@ cell = cell + (A[i][k]*B[k][j])

				@ use fmap to get A[i][k] => I
				@ fmap(width, i, j)
				mov r0, r4 @ the common factor or A-width
				mov r1, r7 @ i
				mov r2, r9 @ k
				bl fmap
				push {r0} @ save result to stack
				@ use fmap to get B[k][j] => I
				ldr r0, =colB @ B-width
				ldr r0, [r0]
				mov r1, r9 @ k
				mov r2, r8 @ j
				bl fmap
				
				@ get value for b save in r3
				ldr r1, =b_ @ matrix b (start)address
				LSL r0, r0, #2 @ multiply index by 4 (4-byte addressing)
				add r3, r1, r0 @ r3 = *b[I] = start + index
				ldr r3, [r3]
				@ get value for A, save in r2
				pop {r0} @ fmapped index for A
				ldr r1, =a_ @ matrix a (start)address
				LSL r0, r0, #2 @ multiply index by 4 (4-byte addressing)
				add r2, r1, r0 @ r2 = *A[I] = start + index
				ldr r2, [r2]

				mul r0, r2, r3 @ A[i][k] * B[k][j]
				add r10, r10, r0 @ cell += ..


			.cntLP3: @ incrament k for loop3
				add r9, r9, #1
				bl forloop3
			

		.cntLP2: @ incrament j loop2
			@ call fmap to get result index
			mov r0, r6 @ r0 = width
			mov r1, r7
			mov r2, r8
			bl fmap @ fmap(width, i, j)
			ldr r1, =c_ @ matrix a (start)address
			LSL r0, r0, #2 @ multiply index by 4 (4-byte addressing)
			add r2, r1, r0 @ r3 = b[I] = start + index
			@ ldr r10, [r10]
			str r10, [r2]


			add r8, r8, #1
			bl forloop2

	.cntLP1: @incrament i
		add r7, r7, #1 @ incrament forloop1
		bl forloop1





exit:
	mov r7, #0x4 @ print sys call
	mov r0, #1
	ldr r1, =bye
	mov r2, #65
	swi 0

	mov r7, #0x1 @ exit 0 
	mov r0, #0
	swi 0

incom_exit:
	mov r7, #0x4 @ print error
	mov r0, #1 
	ldr r1, =error
	mov r2, #13
	swi 0

	mov r7, #0x1 @ exit 2
	mov r0, #2
	swi 0

fmap:
	@ map 2d array (row, col) => index {1d array}
	@ int fmap(int Width, int Ri, int Ci)
	@ params r0-r2
	@ reteurn r0 (faked index) 
	@ formula = (width * row) + col

	push {lr} @ return address
	push {r11}
	mul r11, r0, r1 
	add r0, r11,  r2
	pop {r11}

	pop {pc} @ return to return caller



.section .data
	error:
	.ascii "rowA != colB\n" @len = 13

	bye: @len = 65
	.ascii "Before you go, break point exit. Use gdb command 'p {int[1]}&c_'\n"



	@ To change default arrays change below settings, 
	@ enter arrays seperated by commas row by row. Your row and col params 
	@ dynamically map the arrays you entered.

	.balign 4
	rowA: .4byte 1
	colA: .4byte 4
	rowB: .4byte 4
	colB: .4byte 1
	common: .4byte 0
	length: .4byte 0
	width:  .4byte 0
	
	.balign 4
	a_:	.word 1, 2, 3, 4
	.balign 4
	b_:	.4byte 	9, 8, 7, 6
	.balign 4
	c_: .skip 400 @ max of 100 ints


	@ .balign 4
	@ rowA: .4byte 3
	@ colA: .4byte 2
	@ rowB: .4byte 2
	@ colB: .4byte 3

	
	@ .balign 4
	@ a_:	.word 3,4,7,2,5,9
	@ .balign 4
	@ b_:	.4byte 	3,1,5,6,9,7
	@ .balign 4
	@ c_: .skip 400 @ max of 100 ints
