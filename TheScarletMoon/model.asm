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
extern Bullets:Item
extern InitBrickCoordX:dword
extern InitBrickCoordY:dword

printf PROTO C :ptr DWORD, :VARARG
calDistance PROTO C :dword, :dword, :dword, :dword

.data


.code

timer proc C id:dword
	invoke Flush
	ret
timer endp

initBricks proc C
	mov brickNum, 35
	push ebx					
	push edi
	push ecx
	push esi
	mov edi,0
	mov ecx,0
	mov eax, brickNum; 将ebx设置为brickNum*32
	mov ebx, 32;
	mul ebx;
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
RandLoop:
	

	invoke registerTimerEvent,offset timer
	invoke startTimer,0,100
	popad
	ret
InitGame endp

end
