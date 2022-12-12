.386
.model flat,stdcall
option casemap:none

includelib acllib.lib
includelib lrfLib.lib
includelib StaticLib1.lib

include include\acllib.inc
include include\vars.inc
include include\model.inc
include include\msvcrt.inc

myitoa PROTO C :dword, :ptr sbyte
printf proto C :dword,:vararg

colorBLACK EQU 00000000h
colorWHITE EQU 00ffffffh
colorEMPTY EQU 0ffffffffh

; 定义Item类，统一各个实体的格式
Item STRUCT
 exist DWORD ? ; 1存在，0已不存在
 typ DWORD ? ; 具体的类型
 posX DWORD ? ; 位置横坐标
 posY DWORD ? ; 位置纵坐标
 W DWORD ? ; 宽
 H DWORD ? ; 高
 vX DWORD ? ; 横向速度
 vY DWORD ? ; 纵向速度
Item ENDS ; 一个实例占4*8B=32B

extern Bricks :Item
extern brickNum :dword

.data
coord sbyte "%d",0ah,0
debug sbyte "命中！",0ah,0
debugTwoInts sbyte "%d | %d",0ah,0

srcgame byte "..\resource\icon\game.jpg",0
imggame ACL_Image <>
srcback byte "..\resource\icon\back.jpg",0
imgback ACL_Image <>
srcbrick byte "..\resource\icon\block.jpg",0
imgbrick ACL_Image <>

titlescore byte "得点：",0
strscore byte 10 dup(0)
titlelife byte "残机：",0
strlife byte 10 dup(0)

.code
DrawItem proc C x:dword,y:dword,w:dword,h:dword
	ret
DrawItem endp
	
drawBrick proc C x: dword, y: dword, h: dword, w: dword, t: dword	;只能在启动了paintBricks时调用此函数
	push eax

	mov eax,t
	;invoke printf,offset debug
	;invoke printf,offset debugTwoInts, x, y
	;invoke printf,offset debugTwoInts, w, h
	invoke loadImage, offset srcbrick, offset imgbrick
	invoke putImageScale, offset imgbrick, x, y, w, h
	
	pop eax
	ret
drawBrick endp

; 定义绘制Bricks函数
paintBricks proc C
	push ebx					
	push edi
	mov edi,0
	mov eax, brickNum; 将ebx设置为brickNum*32
	mov ebx, 32;
	mul ebx;
	mov ebx, eax
	;mov Bricks[0].exist, 1
	;mov Bricks[0].W, 50
	;mov Bricks[0].H, 50
	;mov Bricks[0].posX, 0
	;mov Bricks[0].posY, 0
	.while edi<ebx
		;invoke printf,offset debug
		.if Bricks[edi].exist == 1
			;invoke printf,offset debug
			invoke drawBrick, Bricks[edi].posX, Bricks[edi].posY, Bricks[edi].H, Bricks[edi].W,Bricks[edi].typ
		.endif
		add edi, 32
	.endw
	pop edi
	pop ebx

	finish:
		ret
	paintBricks endp

Flush proc C
		mov ebx,currentWin
		cmp ebx,0
		jz open
		cmp ebx,1
		jz mainwindow
	open:
		invoke loadImage,offset srcgame,offset imggame
		invoke beginPaint
		invoke putImageScale,offset imggame,0,0,1000,600
		invoke endPaint
		jmp finish

	mainwindow:
		
		invoke loadImage,offset srcback,offset imgback
		invoke beginPaint

		invoke putImageScale,offset imgback,0,0,1000,600

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,850,50,offset titlescore

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,850,70,offset strscore

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,850,150,offset titlelife

		invoke endPaint
		jmp bricks

	bricks:
		invoke beginPaint
		;invoke printf,offset debug
		invoke paintBricks
		invoke endPaint
		jmp finish


	finish:
		ret
	Flush endp
end Flush