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
extern BulletNum:dword
extern Boss:Item
extern BulletSpeedX:dword


printf PROTO C :ptr DWORD, :VARARG
calDistance PROTO C :dword, :dword, :dword, :dword

.data
coord sbyte "%d",0ah,0
coordd sbyte "1",0ah,0

.code

initBoss proc C
	mov Boss.exist, 1
	mov Boss.posX, 350
	mov Boss.posY, 150
	mov Boss.W, 100
	mov Boss.H, 100
	;mov Ball.exist, 0
	mov BulletNum, 0
	ret
initBoss endp

HitBrick proc C
	pushad
	mov edi,0
	.if (existBrickNum == 0 && Boss.exist == 0)
		invoke initBoss
		invoke Flush
	.endif
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
	push ebx					
	push edi
	push ecx
	push esi
	mov brickNum, 35
	mov existBrickNum, 35
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
	pop esi
	pop ecx
	pop edi
	pop ebx
	ret
initBricks endp

moveBullet proc C
	pushad
	mov edi,0
	mov eax, BulletNum
	mov ebx, 32
	mul ebx
	mov ebx, eax
	.while edi<ebx
		.if Bullets[edi].exist == 1
			invoke printf,offset coord, Bullets[edi].posX
			mov eax, Bullets[edi].vX
			add Bullets[edi].posX, eax
			mov eax, Bullets[edi].vY
			add Bullets[edi].posY, eax

			.if (Bullets[edi].posX <= 0 || Bullets[edi].posX >= 700 || Bullets[edi].posY <= 0 || Bullets[edi].posY >= 600)
				mov Bullets[edi].exist, 0
				invoke printf,offset coord, Bullets[edi].posX
			.endif
		.endif 
		add edi, 32
	.endw
	popad
	ret
moveBullet endp

loadDirectiveBullets proc C
	push edi
	mov BulletSpeedX, 30

	mov eax, BulletNum
	mov edi, 32;
	mul edi;
	mov edi, eax

	mov Bullets[edi].exist, 1
	mov Bullets[edi].W, 10
	mov Bullets[edi].H, 10
	mov Bullets[edi].posX, 50
	mov Bullets[edi].posY, 100
	mov Bullets[edi].vY, 15
	mov t1, edi
	.if playerPosX > 50
		mov eax, playerPosX
		sub eax, 50
		div BulletSpeedX
		mov edi, t1
		mov Bullets[edi].vX, eax
	.else
		mov eax, 50
		sub eax, playerPosX
		div BulletSpeedX
		mov edi, eax
		mov eax, 0
		sub eax, edi
		mov edi, t1
		mov Bullets[edi].vX, eax
	.endif

	add edi, 32
	mov Bullets[edi].exist, 1
	mov Bullets[edi].W, 10
	mov Bullets[edi].H, 10
	mov Bullets[edi].posX, 250
	mov Bullets[edi].posY, 100
	mov Bullets[edi].vY, 5
	mov t1, edi
	.if playerPosX > 250
		mov eax, playerPosX
		sub eax, 250
		div BulletSpeedX
		mov edi, t1
		mov Bullets[edi].vX, eax
	.else
		mov eax, 250
		sub eax, playerPosX
		div BulletSpeedX
		mov edi, eax
		mov eax, 0
		sub eax, edi
		mov edi, t1
		mov Bullets[edi].vX, eax
	.endif


	add edi, 32
	mov Bullets[edi].exist, 1
	mov Bullets[edi].W, 10
	mov Bullets[edi].H, 10
	mov Bullets[edi].posX, 450
	mov Bullets[edi].posY, 100
	mov Bullets[edi].vY, 5
	mov t1, edi
	.if playerPosX > 450
		mov eax, playerPosX
		sub eax, 450
		div BulletSpeedX
		mov edi, t1		
		mov Bullets[edi].vX, eax
	.else
		mov eax, 450
		sub eax, playerPosX
		div BulletSpeedX
		mov edi, eax
		mov eax, 0
		sub eax, edi
		mov edi, t1
		mov Bullets[edi].vX, eax
	.endif

	add edi, 32
	mov Bullets[edi].exist, 1
	mov Bullets[edi].W, 10
	mov Bullets[edi].H, 10
	mov Bullets[edi].posX, 650
	mov Bullets[edi].posY, 100
	mov Bullets[edi].vY, 5
	mov t1, edi
	.if playerPosX > 650
		mov eax, playerPosX
		sub eax, 650
		div BulletSpeedX
		mov edi, t1
		mov Bullets[edi].vX, eax
	.else
		mov eax, 650
		sub eax, playerPosX
		div BulletSpeedX
		mov edi, eax
		mov eax, 0
		sub eax, edi
		mov edi, t1
		mov Bullets[edi].vX, eax
	.endif

	add BulletNum, 4

	pop edi

	ret
loadDirectiveBullets endp

bossAttack proc C 
	.if (timeCount == 0)
		invoke printf,offset coord, BulletNum
		.if BulletNum < 800
			invoke loadDirectiveBullets
			;invoke printf,offset coord, BulletNum
		.endif
	.elseif (timeCount >= 100 && timeCount <= 150)
		.if BulletNum < 800
			;invoke loadCutBullets
		.endif
	.endif
	ret
bossAttack endp

timeCounter proc C
	add timeCount,1
	.if timeCount >= 200
		sub timeCount,200
	.endif
	;invoke printf,offset coord,timeCount
	ret
timeCounter endp

timer proc C id:dword
	invoke timeCounter
	invoke moveBall
	.if Boss.exist == 0
		invoke HitBrick
	.endif
	.if Boss.exist == 1
		invoke bossAttack
		invoke moveBullet
	.endif
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
