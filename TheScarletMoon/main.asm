.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib

include include\acllib.inc
include include\msvcrt.inc
include include\windows.inc
include include\vars.inc
include include\model.inc
include include\view.inc
include include\controller.inc

printf PROTO C :ptr sbyte, :VARARG

.data

winTitle byte "幻想绮月谭",0

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

.code

main proc
	invoke init_first
	invoke initWindow,offset winTitle,425,50,1000,600

	mov currentWin,0
	mov Score,0
	mov Life,3
	mov playerPosX,350
	mov playerPosY,550

	invoke Flush
	
	invoke registerMouseEvent,iface_mouseEvent
	invoke registerKeyboardEvent, iface_keyboardEvent
	invoke init_second
	ret
main endp
end main
