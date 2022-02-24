default:
	arm-linux-gnueabi-as arm_mat_mult.S -o mat_mult.o
	arm-linux-gnueabi-gcc -g mat_mult.o -o exe -nostdlib -static
	qemu-arm ./exe