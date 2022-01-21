
---
title: "二进制文件"
date: 2021-08-01
timezone: UTC+8
tags: ["操作系统"]
categories: ["操作系统"]
---


## 二进制文件

[TOC]

###  所需工具

所需工具

> 操作系统：Linux : Ubuntu18:http://releases.ubuntu.com/18.04/
>
> 汇编编译器：nasm: https://www.nasm.us/
>
> 虚拟机：vitualbox:  [https://www.virtualbox.org/wiki/Linux_Downloads ]
>
> 文本编辑器：
>
> - vscode: https://code.visualstudio.com/ 
> - 插件：hexdump for vscode
> - 插件：x86 and x86_64 Assembly
> - 插件：**Beautify** 



### 二进制编码表

英文字符的二进制码（16进制表示）：

| 英文 | 十六进制 | 英文 | 十六进制 | 英文 | 十六进制 | 英文 | 十六进制 |
| ---- | -------- | ---- | -------- | ---- | -------- | ---- | -------- |
| A=65 | 41       | H    | 48       | O    | 4F       | V    | 56       |
| B    | 42       | I    | 49       | P    | 50       | W    | 57       |
| C    | 43       | J    | 4A       | Q    | 51       | X    | 58       |
| D    | 44       | K    | 4B       | R    | 52       | Y    | 59       |
| E    | 45       | L    | 4C       | S    | 53       | Z    | 60       |
| F    | 46       | M    | 4D       | T    | 54       |      |          |
| G    | 47       | N    | 4E       | U    | 55       |      |          |



###  使用汇编生成二进制文件

接下来，我们使用汇编语言生成一个二进制文件。这个二进制文件包含一个极其简单的boot引导程序。整个二进制文件可以作为1.44M软盘在虚拟机上运行。

整个程序只做一件事情，就是在屏幕上输出"ratsos"这6个字。

**1. 新建汇编文件**

新建一个ratsos.asm的文件。打开文本编辑器，写出如下汇编代码：

```
db 0xEB, 0x09, 0x90, 0x52, 0x41, 0x54, 0x53, 0x42 
db 0x4F, 0x4F, 0x54, 0xB8, 0x00, 0xB8, 0x8E, 0xE8   
db 0x65, 0xC6, 0x06, 0x00, 0x00, 0x72, 0x65, 0xC6 
db 0x06, 0x01, 0x00, 0x74, 0x65, 0xC6, 0x06, 0x02    
db 0x00, 0x61, 0x65, 0xC6, 0x06, 0x03, 0x00, 0x74 
db 0x65, 0xC6, 0x06, 0x04, 0x00, 0x74, 0x65, 0xC6  
db 0x06, 0x05, 0x00, 0x74, 0x65, 0xC6, 0x06, 0x06 
db 0x00, 0x73, 0X65, 0xC6, 0x06, 0x07, 0x00, 0x74 
db 0xEB, 0xFE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
resb 432
db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x55, 0xAA
db 0xF0, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00
resb 4600
db 0xF0, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00
resb 1469432
```

**2. 编译**

在命令行执行

> nasm -f bin -o ratsos.ima ratsos.asm

编译。编译时有warning。但是不用去管他。

上面的命令将ratsos.asm编译编译成一个二进制文件ratsos.ima。

这个ratsos.ima文件是最基本的二进制bin格式，并且大小为1.44M（1440x1024= 1474560），我们可以将这个ratsos.ima文件直接当做1.44M软盘镜像来使用。



**3. 虚拟机运行镜像**

使用vitualbox创建一个系统，添加一个软盘驱动器。

使用软盘驱动器加载镜像文件ratsos.ima。

![images/1.7_1.png](images/1.7.1.png)

启动系统

输出如下：

![images/1.7_2.gif](images/1.7.2.gif)





### 二进制文件分析

以二进制的方式查看文件内容

使用xxd命令分析二进制文件（以16进制方式输出文件的前512字节）

> xxd -l 512 ratsos.ima

如图：

![images/1.7_3.png](images/1.7.3.png)

其实上面的内容和以下汇编文件生成的内容是一致的

```assembly
;RatsOS
;TAB=4
[bits 16]
	org     0x7c00 				;指明程序的偏移的基地址

;boot程序
	jmp     Entry

;程序核心内容
Entry:
	mov ax,0xb800
	mov gs,ax                   ;显存段地址
	mov byte [gs:0x00],'h'      ;输出字符
	mov byte [gs:0x01],0x74     ;设置颜色(背景色蓝，前景色白)
	mov byte [gs:0x02],'e'
	mov byte [gs:0x03],0x74
	mov byte [gs:0x04],'l'
	mov byte [gs:0x05],0x74
	mov byte [gs:0x06],'l'
	mov byte [gs:0x07],0x74
	mov byte [gs:0x08],'o'

                 	
	jmp $						;进入死循环，不再往下执行。

Fill_Sector:
	resb    510-($-$$)       	;处理当前行$至结束(1FE)的填充
	db      0x55, 0xaa
Fill_Disk:	
	resb    1474560-($-$$)       	;处理当前行$至结束(1440KB)的填充
```



代码地址：

[https://github.com/sxt102400/ratsos/tree/master/chapter1.7](https://github.com/sxt102400/ratsos/tree/master/chapter1.7)