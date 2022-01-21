---
title: "汇编指令"
date: 2021-08-01
timezone: UTC+8
tags: ["操作系统"]
categories: ["操作系统"]
---


## 汇编指令 

### 1. 赋值操作

- mov 

> mov ax, 0x1

1）将值赋给寄存器：mov 寄存器,寄存器|内存单元|立即数

```assembly
mov ax,0x0018H  		;ax = 0x0018H
mov ax,[0x0c200H] 	;ax = [ds:0x0c200H]
mov ax,bx  	 	  		;ax = bx
```

1）将值赋给内存单元：mov 内存单元,寄存器|内存单元|立即数

```assembly
mov [0x0a200H],0x0018H   	;ax = 0x0018H
mov [0x0a200H],[0x0c200H] 	;ax = [ds:0x0c200H]
mov [0x0a200H],bx   	  		;ax = bx
```



### 2. 算术操作

下面是算术操作指令的简单列表：

- add —— 整数加

  sub —— 减法: 

  mul —— 无符号乘法(无符号):	

- IMUL —— 有符号乘

- DIV —— 无符号除

  div 寄存器|内存单元(除数).

- IDIV —— 有符号除

- INC —— 自增

- DEC —— 自减

- NEG —— 取反

- CMP —— 比较大小



### 3. 转移操作

- JE —— 如果相等
- JZ —— 如果为零
- JNE —— 如果不相等
- JNZ —— 如果不为零
- JG —— 如果第一个操作数比第二个大
- JGE —— 如果第一个操作数比第二个大或者相等
- JA —— 与 JG 指令相同，只不过比较的是无符号数
- JAE —— 与 JGE 指令相同，只不过比较的是无符号数



### 4. 跳转指令

**jmp指令**

> cs寄存器，ip寄存器

通过修改 [cs，ip] 内容，达到跳转效果。

- jmp near 短转移 ： [ ip <- new ip val]
- jmp far 远转移 ： [ cs<- new cs val, ip <- new ip val]
- jmp word 段间转移，可从32位跳转64位指令



**call指令**

> cs寄存器，ip寄存器，栈寄存器

1）压栈当前指令位置   [ss, sp] <-  [cs, ip] 

2)  跳转到函数执行

3）返回，出栈当前指令位置   [cs, ip] <-   [ss, sp]

4）继续执行指令

- call
- call far
- call world



**ret指令**

> cs寄存器，ip寄存器，栈寄存器

3）返回，出栈当前指令位置   [cs, ip] <-   [ss, sp]

4）继续执行指令



**loop指令**

> cx寄存器

判断 [cs] 寄存器值是否为0，为0停止循环，不为0继续循环。

每次执行  [cs=cx-1]



### 5. 栈操作

- push：入栈，将寄存器的数据入栈

- pop： 栈，数据存储到寄存器中

  栈寄存器

  首先CPU进行出栈入栈操作时，需要先分配一段栈空间的内存，来存储数据使用。

  这段内存的位置由栈段寄存器SS和栈指针寄存器SP来指定。

  ```
    栈顶地址 = 栈段寄存器SS << 4 + 栈指针寄存器SP
  ```

   每次进行出栈入栈操作时，SS和SP会更新得到新的栈顶位置。

   我们可以通过指定	栈段寄存器SS和栈指针寄存器SP的值来初始化栈空间分配。









## 栈操作

栈顶元素： [ss:sp]    (默认 [ss:0xf] )

栈空间  ：  [ss:0] -> [ss:0xf]



**push指令**

> ss寄存器，sp寄存器

通过修改 [ss，sp] 内容，改变栈顶位置

[cs, sp] <- 栈顶位置

执行后, 栈值增加，指向新的地址

[cs,sp+2] <- 栈顶位置



**pop指令**

> ss寄存器，sp寄存器

通过修改 [ss，sp] 内容，改变栈顶位置

执行后, 栈值减少，指向上一个地址

[cs,sp-2] <- 栈顶位置



### 其他指令

CLI ： Clear Interupt

STI ：Set Interupt

CLD ： Clear Director

STD ：Set Director

REP：

Loop：



# CPU指令

## 赋值

1）将值赋给寄存器：mov 寄存器,寄存器|内存单元|立即数

	mov ax,0x0018H  		;ax = 0x0018H
	mov ax,[0x0c200H] 	;ax = [ds:0x0c200H]
	mov ax,bx  	 	  		;ax = bx

1）将值赋给内存单元：mov 内存单元,寄存器|内存单元|立即数

	mov [0x0a200H],0x0018H   	;ax = 0x0018H
	mov [0x0a200H],[0x0c200H] 	;ax = [ds:0x0c200H]
	mov [0x0a200H],bx   	  		;ax = bx

## 运算

1）加法: add 寄存器,寄存器|立即数

	add ax,0x0017H 	;ax=ax+0x0017H
	add ax,bx			;ax=ax+bx

2) 减法: sub 寄存器,寄存器|立即数

	sub ax,0x0017H 	;ax=ax-0x0017H
	sub ax,bx			;ax=ax-bx

3) 乘法(无符号):	mul 寄存器.

使用寄存器: AX存放目标操作数，操作后AX和DX存放结果。

		mov eax 0x0100H
		mul 寄存器

4) 除法:	div 寄存器|内存单元(除数).

使用寄存器: AX和DX存放被除数，操作后AX和DX存放商和余数。
​		div 寄存器|内存单元

5) 自增1:inc 寄存器

	 inc ax

6) 自减1:dec 寄存器

	 dec ax

 7）取补码：nec

## 栈寄存器

首先CPU进行出栈入栈操作时，需要先分配一段栈空间的内存，来存储数据使用。

这段内存的位置由栈段寄存器SS和栈指针寄存器SP来指定。

	栈顶地址 = 栈段寄存器SS << 4 + 栈指针寄存器SP

每次进行出栈入栈操作时，SS和SP会更新得到新的栈顶位置。

我们可以通过指定	栈段寄存器SS和栈指针寄存器SP的值来初始化栈空间分配。

## 栈操作

栈的操作主要有2个:

1. 入栈 push

push 寄存器

将寄存器的数据入栈

2. 出栈 pop

pop 寄存器

出栈，数据存储到寄存器中