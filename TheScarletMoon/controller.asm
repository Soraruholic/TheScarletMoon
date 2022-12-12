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


printf PROTO C :ptr DWORD, :VARARG

.data


.code
;判断点击的坐标或所求点坐标是否在规定矩形框内，是返回1，不是则返回0。
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

; 鼠标事件回调函数
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

; 键盘事件回调函数
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
			mov eax,0
			mov Player.typ,eax
		.endif
		.if key == VK_A
			.if playerPosX > 10
				mov eax,playerPosX
				sub eax,10
				mov playerPosX,eax
			.elseif playerPosX <= 10
				mov eax,0
				mov playerPosX,eax
			.endif
		.endif
		.if key == VK_D
			.if playerPosX < 740
				mov eax,playerPosX
				add eax,10
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
