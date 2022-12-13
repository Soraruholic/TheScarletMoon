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


printf PROTO C :ptr DWORD, :VARARG

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
			mov eax,1
			mov currentWin,eax
			invoke InitGame
		.endif
	.elseif currentWin == 1
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

	;invoke printf,offset coord, ballPosX, ballPosY
	;invoke printf,offset coord, ecx, playerPosX
	;invoke printf,offset coord, edi, ebx
	;invoke printf,offset coord, esi, edx
	.if (ballPosX <= edi && ballPosX >= ebx && ballPosY <= 560 && ballPosY >= 420)
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
