.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib

include include\vars.inc
include include\model.inc
include include\acllib.inc
include include\view.inc

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
extern Bullets:Item
extern InitBrickCoordX:dword
extern InitBrickCoordY:dword
extern hitRange:dword
extern hitBallAcc:dword
extern bgmChange:dword

printf PROTO C :ptr DWORD, :VARARG
ExitProcess proto stdcall , :dword

.data
coord sbyte "%d | %d", 0ah, 0
coordd sbyte "1",0ah,0

.code
is_inside_the_rect proc C x:dword,y:dword,left:dword,right:dword,up:dword,bottom:dword
	mov eax,x
	mov ebx,y
	.if	eax <= left
		mov eax,0
	.elseif	eax >= right
		mov eax,0
	.elseif ebx >= bottom
		mov eax,0
	.elseif ebx <= up
		mov eax,0
	.else	
		mov eax,1
	.endif	
	ret
is_inside_the_rect endp

iface_mouseEvent proc C x:dword,y:dword,button:dword,event:dword
	pushad
	mov ecx,event
	cmp ecx,BUTTON_DOWN
	jne not_click

	.if currentWin == 0
		invoke is_inside_the_rect,x,y,800,1000,100,200
		.if eax == 1
			mov currentWin,1
			invoke bgmStop
			mov bgmChange, 9
			invoke bgmPlay
			mov bgmChange, 2
			invoke bgmPlay
			invoke InitGame
		.endif
		invoke is_inside_the_rect,x,y,800,1000,250,350
		.if eax == 1
			mov currentWin,2
			invoke Flush
		.endif
		invoke is_inside_the_rect,x,y,800,1000,400,500
		.if eax == 1
			call ExitProcess
		.endif
	.elseif currentWin == 1
		invoke is_inside_the_rect,x,y,800,1000,500,600
		.if eax == 1
			invoke bgmStop
			mov bgmChange, 10
			invoke bgmPlay
			mov bgmChange, 1
			invoke bgmPlay
			mov currentWin,0
			mov Score,0
			mov Life,30
			mov playerPosX,350
			mov playerPosY,550
			invoke Flush
		.endif
	.elseif currentWin == 2
		invoke is_inside_the_rect,x,y,800,1000,500,600
		.if eax == 1
			invoke bgmStop
			mov bgmChange, 1
			invoke bgmPlay
			mov currentWin,0
			invoke Flush
		.endif
	.elseif currentWin == 3
		invoke is_inside_the_rect,x,y,800,1000,500,600
		.if eax == 1
			invoke bgmStop
			mov bgmChange, 1
			invoke bgmPlay
			mov currentWin,0
			invoke Flush
		.endif
	.elseif currentWin == 4
		invoke is_inside_the_rect,x,y,800,1000,500,600
		.if eax == 1
			invoke bgmStop
			mov bgmChange, 1
			invoke bgmPlay
			mov currentWin,0
			invoke Flush
		.endif
	.endif

not_click:
	popad
	ret
iface_mouseEvent endp

ballHit proc C
	push edx
	push esi

	mov hitBallAcc, 10

	mov edx, 0
	mov esi, Ball.vX
	;invoke printf,offset coord, Ball.vX, Ball.vY
	sub edx, esi
	mov Ball.vX, edx

	mov Ball.vY, -50
	;invoke printf,offset coord, Ball.vX, Ball.vY

	pop esi
	pop edx
	ret
ballHit endp

hitBallJudge proc C 
	push eax
	push ebx
	push edi
	
	mov hitRange, 100
	mov eax, playerPosX
	sub eax, hitRange
	mov ebx, eax
	mov eax, playerPosX
	add eax, 50
	add eax, hitRange
	mov edi, eax

	.if ebx < 40
		mov ebx, 40
	.endif
	sub ebx, 40

	.if (ballPosX <= edi && ballPosX >= ebx && ballPosY <= 560 && ballPosY >= 420)
		mov bgmChange, 6
		invoke bgmPlay
		mov bgmChange, 2
		invoke ballHit
	.endif

	pop edi
	pop ebx
	pop eax
	ret
hitBallJudge endp

iface_keyboardEvent proc C key:dword, event:dword
	pushad
	mov ecx,event
	cmp ecx,KEY_DOWN
	jne not_press

	.if currentWin == 1
		.if key == VK_SPACE
			mov eax,1
			mov Player.typ,eax
			invoke Flush
			invoke hitBallJudge
			mov eax,0
			mov Player.typ,eax
		.endif
		.if key == VK_A
			.if playerPosX > 10
				mov eax,playerPosX
				sub eax,25
				mov playerPosX,eax
			.elseif playerPosX <= 10
				mov eax,0
				mov playerPosX,eax
			.endif
		.endif
		.if key == VK_D
			.if playerPosX < 740
				mov eax,playerPosX
				add eax,25
				mov playerPosX,eax
			.elseif playerPosX >= 740
				mov eax,750
				mov playerPosX,eax
			.endif
		.endif
	.endif

not_press:
	popad
	ret
iface_keyboardEvent endp

end
