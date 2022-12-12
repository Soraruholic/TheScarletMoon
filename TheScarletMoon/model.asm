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

printf PROTO C :ptr DWORD, :VARARG
calDistance PROTO C :dword, :dword, :dword, :dword  ;

; 定义Item类，统一各个实体的格式
Item STRUCT
 exist DWORD ? ; 1存在，0已不存在
 typ DWORD ? ; 具体的类型
 posX DWORD ? ; 位置横坐标
 posY DWORD ? ; 位置纵坐标
 W DWORD ? ; 宽
 H DWORD ? ; 高
 vX DWORD ? ; 横向速度
 vY DWORD ? ; 纵向速度
Item ENDS ; 一个实例占4*8B=32B

extern Bricks :Item
extern brickNum :dword
extern InitBrickCoordX :dword
extern InitBrickCoordY :dword

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
	
IniPlayer:


	push 0
	call crt_time
	add esp,4
	push eax
	call crt_srand
	add esp,4
	
IniBricks:
	invoke initBricks 

	invoke registerTimerEvent,offset timer
	invoke startTimer,0,100
	popad
	ret
InitGame endp

end