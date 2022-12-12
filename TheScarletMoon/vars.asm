.386
.model flat,stdcall
option casemap:none

.data

currentWin DWORD 0
public currentWin

gameX DWORD 0
public gameX
gameY DWORD 0
public gameY

score DWORD 0
public score

playerPosX DWORD ?
public playerPosX
playerPosY DWORD ?
public playerPosY

ballPosX DWORD ?
public ballPosX
ballPosY DWORD ?
public ballPosY

life DWORD 0
public life

.code

end