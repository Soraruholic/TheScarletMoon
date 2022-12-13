.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib
includelib StaticLib1.lib

include include\vars.inc
include include\acllib.inc
include include\msvcrt.inc
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
extern timeCount:dword

printf PROTO C :ptr DWORD, :VARARG
calDistance PROTO C :dword, :dword, :dword, :dword

.data
coord sbyte "%d",0ah,0
coordd sbyte "1",0ah,0

.code


HitBrick proc C
	pushad
	mov edi,0
LoopTraverseItem:
	.if Bricks[edi].exist == 1
		mov eax,Bricks[edi].posX
		.if eax < 40
			mov eax, 0
		.else
			sub eax,40
		.endif
		mov ebx,Bricks[edi].posX
		add ebx,40
		mov ecx,Bricks[edi].posY
		.if ecx < 40
			mov ecx, 0
		.else
			sub ecx,40
		.endif
		mov esi,Bricks[edi].posY
		add esi,40
		.if ballPosX >= eax && ballPosX <= ebx && ballPosY >= ecx && ballPosY <= esi
			sub existBrickNum,1
			mov Bricks[edi].exist,0

			mov eax,Ball.vX
			sub Ball.posX,eax
			mov ebx,Ball.vY
			sub Ball.posY,ebx

			mov eax,Bricks[edi].posX
			sub eax,40
			mov ebx,Bricks[edi].posX
			add ebx,40
			.if ballPosX >= eax && ballPosX <=ebx
				mov eax,0
				mov ebx,Ball.vY
				sub eax,ebx
				mov Ball.vY,eax
			.endif

			mov eax,Bricks[edi].posY
			sub eax,40
			mov ebx,Bricks[edi].posY
			add ebx,40
			.if ballPosY >= eax && ballPosY <=ebx
				mov eax,0
				mov ebx,Ball.vX
				sub eax,ebx
				mov Ball.vX,eax
			.endif
		.endif
	.endif
	add edi,32
	mov eax,brickNum
	mov ebx,32
	mul ebx
	cmp edi,eax
	jne LoopTraverseItem
	jmp Finish
Finish:
	popad
	ret
HitBrick endp


initBall proc C
	push eax
	mov eax,1
	mov Ball.exist,eax
	mov eax,30
	mov Ball.vX,eax
	mov eax,20
	mov Ball.vY,eax
	mov eax,100
	mov ballPosX,eax
	mov eax,400
	mov ballPosY,eax
	pop eax
initBall endp

moveBall proc C
	pushad
	add Ball.vY,2
	mov eax,Ball.vX
	add ballPosX,eax
	mov eax,Ball.vY
	add ballPosY,eax

	.if (ballPosX <= 0 || ballPosX > 2000)
		mov eax,0
		mov ebx,Ball.vX
		sub eax,ebx
		mov Ball.vX,eax
		mov ballPosX,0
	.endif
	.if ballPosX >= 760
		mov eax,0
		mov ebx,Ball.vX
		sub eax,ebx
		mov Ball.vX,eax
		mov ballPosX,760
	.endif

	.if (ballPosY <= 0 || ballPosY > 1000)
		mov eax,0
		mov ebx,Ball.vY
		sub eax,ebx
		mov Ball.vY,eax
		mov ballPosY,0
	.endif
	.if ballPosY >= 560
		mov eax,0
		mov ebx,Ball.vY
		sub eax,ebx
		mov Ball.vY,eax
		mov ballPosY,560
	.endif
	popad
	ret
moveBall endp

initBricks proc C
	mov brickNum, 35
	mov existBrickNum, 35
	push ebx					
	push edi
	push ecx
	push esi
	mov edi,0
	mov ecx,0
	mov eax, brickNum
	mov ebx, 32
	mul ebx
	mov ebx, eax
	.while edi<ebx
		mov esi, InitBrickCoordX[ecx]
		mov Bricks[edi].posX, esi
		mov esi, InitBrickCoordY[ecx]
		mov Bricks[edi].posY, esi
		mov Bricks[edi].exist, 1
		mov Bricks[edi].W, 40
		mov Bricks[edi].H, 40
		add edi, 32
		add ecx, 4
	.endw
	pop edi
	pop ebx
	pop ecx
	pop esi
	ret
initBricks endp

timeCounter proc C
	add timeCount,1
	.if timeCount >= 200
		sub timeCount,200
	.endif
	invoke printf,offset coord,timeCount
	ret
timeCounter endp

timer proc C id:dword
	invoke timeCounter
	invoke moveBall
	invoke HitBrick
	invoke Flush
	ret
timer endp

InitGame proc C
	pushad

IniGameSize:
	
IniScore:
		
IniLife:
	
	
IniPlayer:
	mov eax,0
	mov Player.typ,eax

	push 0
	call crt_time
	add esp,4
	push eax
	call crt_srand
	add esp,4
	
	mov edi,0
IniBricks:
	invoke initBricks
IniBall:
	invoke initBall
IniTime:
	mov timeCount,0

	invoke registerTimerEvent,offset timer
	invoke startTimer,0,50
	popad
	ret
InitGame endp

end
