.globl	main
.data 	
    	Input:	.string "Input the number:\n"
        Output:	.string "The damage:\n"	
.text
main:
	addi x18, x0, 1
	addi x19, x0, 5
	addi x20, x0, 10
	addi x21, x0, 20
	addi x23, x0, 0 #sum=0
	la a0, Input
	li a7, 4
	ecall
	li a7, 5
	ecall
	add x22, a0, x0 #x22=n
	jal x1, recursive
	la a0, Output
	li a7, 4
	ecall
	mv a0, x23 #x23=sum是最後答案
	li a7, 1
	ecall
	li a7, 10
	ecall
	
	
recursive:  

	bgt  x22, x21, func1 #x>20
	bgt  x22, x20, func2 #x>10
	bgt  x22, x18, func3 #x>1
	beq  x22, x0, func4 #x=0
	beq  x22, x18, func5 #x=1
	beq  x0, x0, func6 #otherwise

func6: #return-1
	addi x23, x23, -1 #sum-=1
	jalr x0, 0(x1)
	
func5: #return 5
	addi x23, x23, 5 #sum+=5
	jalr x0, 0(x1)
	
func4: #return 1
	addi x23, x23, 1 #sum+=1
	jalr x0, 0(x1)
	
func3: #return f(x-1)+f(x-2)
	addi x2, x2, -8 
	sw x1, 4(x2)
	sw x22, 0(x2)
	addi x22, x22, -1 #x22--
	jal x1, recursive
	lw x22, 0(x2) #取原本x22的值
	addi x2, x2, 4
	addi x22, x22, -2
	jal x1, recursive
	lw x1,0(x2)
	addi x2, x2, 4
	jalr x0, 0(x1)
	
func2: #return f(x-2) + f(x-3)
	addi x22, x22, -1 #x22--
	beq  x0, x0, func3
	
func1: #return 2*x + f(x/5)
	addi x2, x2, 8
	sw x1, 4(x2)
	sw x22, 0(x2)
	slli x22, x22, 1 #2*x
	add x23, x23, x22 #sum+=2*x
	lw x22, 0(x2) #取回原本x22的值
	addi x2, x2, 4
	div x22, x22, x19 #x/5
	jal x1, recursive
	lw x1, 0(x2)
	addi x2, x2, 4
	jalr x0, 0(x1)
	
	
	
	
	
