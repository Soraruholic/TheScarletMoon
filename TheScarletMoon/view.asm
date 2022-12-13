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

Item STRUCT
	exist DWORD ?
	typ DWORD ?
	posX DWORD ?
	posY DWORD ?
	W DWORD ?
	H DWORD ?
	vX DWORD ?
	vY DWORD ?
Item ENDS
extern Player:Item
extern Ball:Item
extern Bricks:Item
extern brickNum:dword
extern existBrickNum:dword
extern BulletNum:dword
extern Bullets:Item
extern InitBrickCoordX:dword
extern InitBrickCoordY:dword
extern Boss:Item

.data
coord sbyte "1",0ah,0
coordd sbyte "2",0ah,0

srcgame byte "..\resource\icon\game.jpg",0
imggame ACL_Image <>

srcback byte "..\resource\icon\back.jpg",0
imgback ACL_Image <>

srcintroduce byte "..\resource\icon\introduce.jpg",0
imgintroduce ACL_Image <>

srcsuccess byte "..\resource\icon\success.jpg",0
imgsuccess ACL_Image <>

srcfail byte "..\resource\icon\fail.jpg",0
imgfail ACL_Image <>

srcplayer1 byte "..\resource\icon\player1.jpg",0
imgplayer1 ACL_Image <>

srcplayer2 byte "..\resource\icon\player2.jpg",0
imgplayer2 ACL_Image <>

srcball byte "..\resource\icon\ball.jpg",0
imgball ACL_Image <>

srcbrick byte "..\resource\icon\brick.jpg",0
imgbrick ACL_Image <>

srcboss byte "..\resource\icon\bosss.jpg",0
imgboss ACL_Image <>

srcbullet1 byte "..\resource\icon\bullet1.jpg",0
imgbullet1 ACL_Image <>
srcbullet2 byte "..\resource\icon\bullet2.jpg",0
imgbullet2 ACL_Image <>

titlescore byte "Score :",0
strscore byte 10 dup(0)
titlelife byte "Residual :",0
strlife byte 10 dup(0)

.code
FlushScore proc C num: dword
	push ebx
	mov ebx,num
	mov Score,ebx
	invoke myitoa,ebx,offset strscore
	pop ebx
	ret
FlushScore endp
FlushLife proc C num: dword
	push ebx
	mov ebx,num
	mov Life,ebx
	invoke myitoa,ebx,offset strlife
	pop ebx
	ret
FlushLife endp
	
drawBrick proc C x: dword, y: dword, h: dword, w: dword, t: dword 	;只能在启动了paintBricks时调用此函数
	push eax

	mov eax,t
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
	.while edi<ebx
		;invoke printf,offset debug
		.if Bricks[edi].exist == 1
			invoke drawBrick, Bricks[edi].posX, Bricks[edi].posY, Bricks[edi].H, Bricks[edi].W,Bricks[edi].typ
		.endif
		add edi, 32
	.endw
	pop edi
	pop ebx

	finish:
		ret
paintBricks endp

paintBoss proc C
	.if Boss.exist == 1
		invoke putImageScale, offset imgboss, Boss.posX, Boss.posY, Boss.W, Boss.H
	.endif
	ret
paintBoss endp

paintBullets proc C
	push ebx					
	push edi
	mov edi,0
	mov eax, BulletNum; 将ebx设置为brickNum*32
	mov ebx, 32;
	mul ebx;
	mov ebx, eax
	.while edi<ebx
		;invoke printf,offset debug
		.if Bullets[edi].exist == 1
			invoke putImageScale, offset imgbullet1, Bullets[edi].posX, Bullets[edi].posY, Bullets[edi].W, Bullets[edi].H
		.endif
		add edi, 32
	.endw
	pop edi
	pop ebx
	ret
paintBullets endp

Flush proc C
		mov ebx,currentWin
		cmp ebx,0
		jz open
		cmp ebx,1
		jz mainwindow
		cmp ebx,2
		jz introduce
		cmp ebx,3
		jz success
	open:
		invoke loadImage,offset srcgame,offset imggame
		invoke beginPaint
		invoke putImageScale,offset imggame,0,0,1000,600
		invoke endPaint
		jmp finish

	mainwindow:
		
		invoke FlushScore,Score
		invoke FlushLife,Life

		invoke loadImage,offset srcback,offset imgback
		invoke loadImage,offset srcplayer1,offset imgplayer1
		invoke loadImage,offset srcplayer2,offset imgplayer2
		invoke loadImage,offset srcball,offset imgball
		invoke loadImage,offset srcbrick, offset imgbrick
		invoke loadImage,offset srcboss, offset imgboss
		invoke loadImage,offset srcbullet1, offset imgbullet1

		invoke beginPaint

		invoke putImageScale,offset imgback,0,0,1000,600

		.if Player.typ == 0
			invoke putImageScale,offset imgplayer1,playerPosX,playerPosY,50,50
		.elseif Player.typ == 1
			invoke putImageScale,offset imgplayer2,playerPosX,playerPosY,50,50
		.endif

		.if existBrickNum > 0
			invoke paintBricks
		.endif

		.if (existBrickNum == 0 && Boss.exist == 1)
			invoke paintBoss
			invoke paintBullets
		.endif
		
		invoke putImageScale,offset imgball,ballPosX,ballPosY,40,40

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,830,50,offset titlescore

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,830,70,offset strscore

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,830,150,offset titlelife

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,830,170,offset strlife


		invoke endPaint
		jmp finish

	introduce:
		invoke loadImage,offset srcintroduce,offset imgintroduce
		invoke beginPaint
		invoke putImageScale,offset imgintroduce,0,0,1000,600
		invoke endPaint
		jmp finish

	success:
		invoke loadImage,offset srcsuccess,offset imgsuccess
		invoke beginPaint
		invoke putImageScale,offset imgsuccess,0,0,1000,600
		invoke endPaint
		jmp finish
		
	finish:
		ret
	Flush endp
end Flush
