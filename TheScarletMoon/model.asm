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
extern bgmChange:dword
extern existBulletNum:dword
extern tmp_exist_bullet:dword
extern hurtable:dword


printf PROTO C :ptr DWORD, :VARARG
calDistance PROTO C :dword, :dword, :dword, :dword

.data
coord sbyte "%d %d %d",0ah,0
coordd sbyte "%d",0ah,0

musicopen byte "..\resource\music\th08_01.mp3",0
musicopenP dd 0
musicgame byte "..\resource\music\th11_02.mp3",0
musicgameP dd 0
musicsuccess byte "..\resource\music\th11_16.mp3",0
musicsuccessP dd 0
musicfail byte "..\resource\music\th10_18.mp3",0
musicfailP dd 0

.code
initBall proc C
	mov Ball.exist,1
	mov Ball.vX,30
	mov Ball.vY,20
	mov ballPosX,100
	mov ballPosY,400
	ret
initBall endp

initBoss proc C
	mov Boss.exist, 1
	mov BossLife,20 
	mov Boss.posX, 350
	mov Boss.posY, 150
	mov Boss.W, 100
	mov Boss.H, 100
	mov Ball.exist, 0
	mov BulletNum, 0
	ret
initBoss endp

HitBrick proc C
	pushad
	mov edi,0
	.if (existBrickNum == 0 && Boss.exist == 0)
		invoke initBall
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
			add Score,100

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

HitBoss proc C
	pushad
	mov edi,0
	.if Boss.exist == 1
		mov eax,260
		mov ebx,400
		mov ecx,110
		mov esi,250
		.if ballPosX >= eax && ballPosX <= ebx && ballPosY >= ecx && ballPosY <= esi
			sub BossLife,1
			;invoke printf,offset coordd,BossLife
			add Score,20
			.if BossLife <= 10
				mov Boss.exist,0
				mov currentWin,3
				mov Score,0
				mov Life,3
				mov playerPosX,350
				mov playerPosY,550
				invoke Flush
			.endif

			mov eax,Ball.vX
			sub Ball.posX,eax
			mov ebx,Ball.vY
			sub Ball.posY,ebx

			mov eax,260
			mov ebx,400
			.if ballPosX >= eax && ballPosX <=ebx
				mov eax,0
				mov ebx,Ball.vY
				sub eax,ebx
				mov Ball.vY,eax
			.endif

			mov eax,110
			mov ebx,250
			.if ballPosY >= eax && ballPosY <=ebx
				mov eax,0
				mov ebx,Ball.vX
				sub eax,ebx
				mov Ball.vX,eax
			.endif
		.endif
	.endif
	popad
	ret
HitBoss endp

clearBullet proc C
	push ebx
	push eax
	push edi
	mov edi,0
	mov eax, BulletNum; 将ebx设置为brickNum*32
	mov ebx, 32;
	mul ebx;
	mov ebx, eax
	.while edi<ebx
		.if Bullets[edi].exist == 1
			mov Bullets[edi].exist,0
		.endif
		add edi, 32
	.endw
	pop edi
	pop eax
	pop ebx
	ret
clearBullet endp

HitPlayer proc C
	pushad
	.if hurtable == 0
		.if (Boss.exist == 1)
			mov eax,existBulletNum
			mov tmp_exist_bullet,eax
			mov eax,BulletNum
			mov ebx,32
			mul ebx
			mov edi,eax
LoopItem:
			sub edi,32
			.if Bullets[edi].exist == 1
				sub tmp_exist_bullet,1
				mov eax,playerPosX
				.if eax < 10
					mov eax, 0
				.else
					sub eax,10
				.endif
				mov ebx,playerPosX
				add ebx,40
				mov ecx,playerPosY
				.if ecx < 10
					mov ecx, 0
				.else
					sub ecx,10
				.endif
				mov esi,playerPosY
				add esi,40
				.if (Bullets[edi].posX >= eax && Bullets[edi].posX <= ebx && Bullets[edi].posY >= ecx && Bullets[edi].posY <= esi)
					mov hurtable,4
					.if Life > 0
						sub Life,1
					.else
						mov Life,0
					.endif 
					.if Life == 0
						mov currentWin,4
						mov Score,0
						mov Life,3
						mov playerPosX,350
						mov playerPosY,550
						invoke Flush
					.endif
					invoke clearBullet
					mov existBulletNum,0
					jmp BallHitPlayer
				.endif
			.endif	
			cmp tmp_exist_bullet,0
			jne LoopItem
			jmp BallHitPlayer
		.endif
BallHitPlayer:
		.if Ball.exist == 1
			mov esi, playerPosX
			.if playerPosX < 30
				mov esi, 30
			.endif
			sub esi, 30
			mov ebx, playerPosX
			add ebx, 80
			.if (ballPosX >= esi && ballPosX <= ebx && ballPosY >= 520 && ballPosY <= 600)
				mov hurtable,4
				.if Life > 0
					sub Life,1
				.else
					mov Life,0
				.endif 
				.if Life == 0
					mov currentWin,4
					mov Score,0
					mov Life,3
					mov playerPosX,350
					mov playerPosY,550
					invoke Flush
				.endif
				invoke initBall
				;mov existBulletNum,0
				jmp Finished
			.endif
		.endif
	.endif
Finished:
	popad
	ret
HitPlayer endp

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
			mov eax, Bullets[edi].vX
			add Bullets[edi].posX, eax
			mov eax, Bullets[edi].vY
			add Bullets[edi].posY, eax

			.if (Bullets[edi].posX <= 0 || Bullets[edi].posX >= 700 || Bullets[edi].posY <= 0 || Bullets[edi].posY >= 600)
				mov Bullets[edi].exist, 0
				sub existBulletNum,1
			.endif
		.endif 
		add edi, 32
	.endw
	popad
	ret
moveBullet endp

loadDirectiveBullets proc C
	push edi
	mov BulletSpeedX, 50

	mov eax, BulletNum
	mov edi, 32;
	mul edi;
	mov edi, eax

	mov Bullets[edi].exist, 1
	mov Bullets[edi].W, 10
	mov Bullets[edi].H, 10
	mov Bullets[edi].posX, 50
	mov Bullets[edi].posY, 100
	mov Bullets[edi].vY, 9
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
	mov Bullets[edi].vY, 9
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
	mov Bullets[edi].vY, 9
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
	mov Bullets[edi].vY, 9
	mov t1, edi
	.if playerPosX > 650
		mov eax, playerPosX
		sub eax, 650
		div BulletSpeedX
		mov t1, eax
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
	add existBulletNum,4

	pop edi

	ret
loadDirectiveBullets endp

loadCutBullets proc C
	push edi
	mov eax, BulletNum
	mov edi, 32
	mul edi
	mov edi, eax

	mov Bullets[edi].exist, 1
	mov Bullets[edi].W, 10
	mov Bullets[edi].H, 10
	mov Bullets[edi].posX, 50
	mov Bullets[edi].posY, 100
	mov Bullets[edi].vX, 0
	mov Bullets[edi].vY, 15

	add edi, 32
	mov Bullets[edi].exist, 1
	mov Bullets[edi].W, 10
	mov Bullets[edi].H, 10
	mov Bullets[edi].posX, 250
	mov Bullets[edi].posY, 100
	mov Bullets[edi].vX, 0
	mov Bullets[edi].vY, 15
	
	add edi, 32
	mov Bullets[edi].exist, 1
	mov Bullets[edi].W, 10
	mov Bullets[edi].H, 10
	mov Bullets[edi].posX, 450
	mov Bullets[edi].posY, 100
	mov Bullets[edi].vX, 0
	mov Bullets[edi].vY, 15

	add edi, 32
	mov Bullets[edi].exist, 1
	mov Bullets[edi].W, 10
	mov Bullets[edi].H, 10
	mov Bullets[edi].posX, 650
	mov Bullets[edi].posY, 100
	mov Bullets[edi].vX, 0
	mov Bullets[edi].vY, 15

	add BulletNum, 4
	add existBulletNum,4

	pop edi
	ret
loadCutBullets endp

bossAttack proc C 
	.if (timeCount == 0 || timeCount == 50)
		;invoke printf,offset coord, BulletNum
		.if BulletNum < 1000
			invoke loadDirectiveBullets
		.endif
	.elseif (timeCount >= 100 && timeCount <= 150)
		.if BulletNum < 1000
			invoke loadCutBullets 
		.endif
		;mov BulletNum, 0
	.endif
	.if BulletNum >= 1000
		mov BulletNum, 0
	.endif
	ret
bossAttack endp

bgmChanger proc C
	.if bgmChange == 1
		invoke loadSound,addr musicopen,addr musicopenP
		invoke playSound,musicopenP,SND_LOOP
		mov bgmChange,0
	.elseif bgmChange == 2
		invoke loadSound,addr musicgame,addr musicgameP
		invoke playSound,musicgameP,SND_LOOP
		mov bgmChange,0
	.elseif bgmChange == 3
		invoke loadSound,addr musicsuccess,addr musicsuccessP
		invoke playSound,musicsuccessP,SND_LOOP
		mov bgmChange,0
	.elseif bgmChange == 4
		invoke loadSound,addr musicfail,addr musicfailP
		invoke playSound,musicfailP,SND_LOOP
		mov bgmChange,0
	.endif
	ret
bgmChanger endp

unhurtable proc C
	.if hurtable > 0
		sub hurtable,1
		mov Player.typ,2
		invoke Flush
	.elseif hurtable == 0
		mov Player.typ,0
	.endif
	ret
unhurtable endp

timeCounter proc C
	add timeCount,1
	.if timeCount >= 200
		sub timeCount,200
	.endif
	ret
timeCounter endp

timer proc C id:dword
	;invoke printf,offset coordd,BulletNum
.if currentWin == 1
	invoke timeCounter
	invoke unhurtable
	invoke moveBall
	invoke HitPlayer
	.if Boss.exist == 1
		invoke HitBoss
		invoke bossAttack
		invoke moveBullet
	.endif
	.if Ball.exist == 1
		invoke HitBrick
	.endif
	invoke Flush
.endif
	ret
timer endp

InitGame proc C
	pushad
IniPlayer:
	mov Player.typ,0
	mov hurtable,0
	mov Life,3

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
IniBulletNum:
	mov BulletNum,0
	mov existBulletNum,0

	invoke registerTimerEvent,offset timer
	invoke startTimer,0,50
	popad
	ret
InitGame endp

end
