
# 題目

This project is about Demon Slayer (鬼滅之刃). The Sun Breathing (日之呼吸) is the first breath which is also the strongest technique against demons (鬼). Tanjiro Kamado (竈門炭治郎), the main character, is the only one who can use Sun Breathing.

In Chapter 192 of the Demon Slayer manga, the thirteenth type of sun breathing is finally ready to appear. The twelve types of sun breathing correspond to twelve o’clock one by one, and every twelve o’clock is a cycle, so it must be repeated. The mysterious thirteenth form (日之呼吸十三之型) is the form by repeating the sun breathing with the twelve forms to form a circle.
In order to predict the strength of the “Upper Moons”, the Demon Slayer Corps (鬼殺隊) recorded the damage formula that Tanjiro could cause by using the breath of the sun, and calculated the damage that could be caused by 
x
 times of use.

To defeat the final boss, a.k.a Muzan Kibutsuji (鬼舞辻無慘), Tanjiro needs to use the sun breathing by 100 times, but he still needs to defeat multiple forces in Infinity Tower (無限城) before he sees Muzan.
Assuming that Tanjiro needs to activate x times of sun breathing to defeat his opponent, the damage caused by Tanjiro’s activation of 
x
 times Sun Breathing to the opponent can be calculated by the following method:


<img width="316" alt="111" src="https://user-images.githubusercontent.com/103658997/163421967-e56e60dc-0eb7-48b4-9cda-bb27c279bbdd.png">


Here we assume x is an integer. You are now asked to write a Recursive RISC-V Assembly Programming to calculate the damage of sun breathing. The program must use recursion as described above. It should only print the final value of F(x). The basic range of x is set x ≦ 99 (total 100 times).

***

# 輸入輸出範例
#### 1.  x=0
<img width="150" alt="o1" src="https://user-images.githubusercontent.com/103658997/163430144-c22eb802-57e9-4fab-b834-86d7d3894d64.png">

#### 2.  x=1
<img width="150" alt="o5" src="https://user-images.githubusercontent.com/103658997/163430788-78df6ad3-8bc0-47e5-a8a1-bf0285b4d2f4.png">

#### 3.  x=3
<img width="150" alt="o2" src="https://user-images.githubusercontent.com/103658997/163430801-48c04ce0-fcaa-46fb-9c21-8a58986b1bf7.png">

#### 4.  x=11
<img width="150" alt="o3" src="https://user-images.githubusercontent.com/103658997/163430811-7e328923-da14-4cff-ac9e-61fb2d3cb7f9.png">

#### 5.  x=20
<img width="150" alt="o4" src="https://user-images.githubusercontent.com/103658997/163430819-cad3be36-5ca5-4158-bf1c-36efff1bd415.png">

#### 6. x=21
<img width="150" alt="o6" src="https://user-images.githubusercontent.com/103658997/163430827-29553b47-fab8-4f40-90fd-b86f0a201b57.png">

***

# 說明文件
### 大意說明
###### 讓使用者輸入 x ，做 recursive 並用 stack 來存放 x 的值以及指令的位置，
###### 將答案加總到 sum ，並 output 最後答案
***
### 詳細說明
- ###### 先把 Input 和 Output 定義好，等等會使用到。
```
.data 
    	Input:	.string "Input the number:\n"
        Output:	.string "The damage:\n"	
.text
```

***
- ###### 把 1 , 5 , 10 , 20 先存好，後面比大小時能使用
- ###### x23是最後的答案，最一開始定義為 0
```
main:
	addi x18, x0, 1
	addi x19, x0, 5
	addi x20, x0, 10
	addi x21, x0, 20
	addi x23, x0, 0 #sum=0	
```
***
- ###### 把 Input 印出來，並把使用者輸入的數字存入 x22
- ###### 執行 recursive，並將下一個指令的 address 存入 x1
```
	la a0, Input
	li a7, 4
	ecall
	li a7, 5
	ecall
	add x22, a0, x0 #x22=n
	jal x1, recursive
```
***
- ###### 判斷使用者輸入的 x 符合哪一種 case 。
```
recursive:  
	bgt  x22, x21, func1 #x>20
	bgt  x22, x20, func2 #x>10
	bgt  x22, x18, func3 #x>1
	beq  x22, x0, func4 #x=0
	beq  x22, x18, func5 #x=1
	beq  x0, x0, func6 #otherwise
```
***
- ###### 先將 x1 當前存的位置以及 x 的值存入 stack 中
- ###### 將 x * 2 並加到 sum 
- ###### 從 stack 中取回原本 x 的值
- ###### 將 x / 5 後再做 recursive ，並將下一指令的位置存入 x1
- ###### 從 stack 中取回原先 x1 的值 ，並跳到該位置
```
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
```
***
- ###### 將 x-1 後做 func3 ，因為 func2 和 func3 只差在 x 的值
```
func2: #return f(x-2) + f(x-3)
	addi x22, x22, -1 #x22--
	beq  x0, x0, func3
```
***
- ###### 先將 x1 當前存的位置以及 x 的值存入 stack 中
- ###### x - 1 後做 recursive 
- ###### 從 stack 中取回原本 x 的值
- ###### x - 2 後做 recursive 
- ###### 從 stack 中取回原先 x1 的值 ，並跳到該位置

```
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
```
***
- ###### sum += 1 並跳到 x1 的位置
```
func4: #return 1
	addi x23, x23, 1 #sum+=1
	jalr x0, 0(x1)
```
***
- ###### sum += 5 並跳到 x1 的位置
```
func5: #return 5
	addi x23, x23, 5 #sum+=5
	jalr x0, 0(x1)
```
***
- ###### sum -= 1 並跳到 x1 的位置
```
func6: #return-1
	addi x23, x23, -1 #sum-=1
	jalr x0, 0(x1)
```
***
- ###### 將 Output 列印出來 , 並把最後答案顯示出來
```
la a0, Output
	li a7, 4
	ecall
	mv a0, x23 #x23=sum是最後答案
	li a7, 1
	ecall
	li a7, 10
	ecall
	
