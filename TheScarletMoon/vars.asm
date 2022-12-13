.386
.model flat,stdcall
option casemap:none

.data

currentWin DWORD 0
public currentWin

hitRange DWORD 0
public hitRange

hitBallAcc DWORD 0
public hitBallAcc

playerPosX DWORD ?
public playerPosX
playerPosY DWORD ?
public playerPosY

ballPosX DWORD ?
public ballPosX
ballPosY DWORD ?
public ballPosY

timeCount DWORD ?
public timeCount

Life DWORD 0
public Life
Score DWORD 0
public Score

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

Player Item {}
public Player
Boss Item {}
public Boss
Ball Item {}
public Ball
Bricks Item 50 DUP({})
public Bricks
brickNum DWORD 0
public brickNum
existBrickNum DWORD 5
public existBrickNum
Bullets Item 800 DUP({})
public Bullets
BulletNum DWORD 0
public BulletNum


InitBrickCoordX DWORD 050,90,130,50,130,50,90,130,170,50,170,50,90,130,170,320,360,400,360,360,360,320,360,400,550,590,630,670,710,550,630,710,630,630,630,0
InitBrickCoordY DWORD 50,50,50,90,90,130,130,130,130,170,170,210,210,210,210,50,50,50,90,130,170,210,210,210,50,50,50,50,50,90,90,90,130,170,210,0
public InitBrickCoordX
public InitBrickCoordY

BulletSpeedX DWORD 1
public BulletSpeedX 

t1 DWORD 0
public t1

t2 DWORD 0
public t2

t3 DWORD 0
public t3

t4 DWORD 0
public t4

end
