# Written by Jalen Hardy 21 Feb 2022
# Python code to multiply variable length matricies stored as variables a & b 
# The number of columns of matrix  must equal the number of rows of matrix b


# b = [[3, 1,  5], [6, 9, 7]]
# a = [[3,4], [7,2], [5,9]]

b= [[1,2,3,4]]
a = [[9], [8], [7], [6]]

common = 0

if len(a[0]) == len(b):
	common = len(a[0])

print("Common factor is:", common)

mat = [[0] * len(b[0]) for i in range(len(a))]
print(mat)

for i in range(len(a)):
	for j in range(len(b[0])):
		cell = 0
		for k in range(common):
			cell += a[i][k] * b[k][j]

		mat[i][j] = int(cell)

print("Finish calculating")
print(mat)