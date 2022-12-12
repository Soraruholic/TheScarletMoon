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

Life DWORD 0
public Life
Score DWORD 0
public Score

existBrickNum DWORD 0
public existBrickNum

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
Ball Item {}
public Ball
Bricks Item 50 DUP({})
public Bricks
brickNum DWORD 0
public brickNum
Bullets Item 50 DUP({})
public Bullets
BulletNum DWORD 0
public BulletNum

InitBrickCoordX DWORD 40,80,120,40,120,40,80,120,160,40,160,40,80,120,160,320,360,400,360,360,360,320,360,400,560,600,640,680,720,560,640,720,640,640,640,0
InitBrickCoordY DWORD 50,50,50,90,90,130,130,130,130,170,170,210,210,210,210,50,50,50,90,130,170,210,210,210,50,50,50,50,50,90,90,90,130,170,210,0
public InitBrickCoordX
public InitBrickCoordY



end