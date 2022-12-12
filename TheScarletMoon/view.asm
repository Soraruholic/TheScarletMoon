.386
.model flat,stdcall
option casemap:none

includelib acllib.lib
includelib lrfLib.lib
includelib StaticLib1.lib

include include\acllib.inc
include include\vars.inc
include include\model.inc
include include\msvcrt.inc

myitoa PROTO C :dword, :ptr sbyte
printf proto C :dword,:vararg

colorBLACK EQU 00000000h
colorWHITE EQU 00ffffffh
colorEMPTY EQU 0ffffffffh


.data
coord sbyte "%d",0ah,0

srcgame byte "..\resource\icon\game.jpg",0
imggame ACL_Image <>
srcback byte "..\resource\icon\back.jpg",0
imgback ACL_Image <>

titlescore byte "µÃµã£º",0
strscore byte 10 dup(0)
titlelife byte "²Ð»ú£º",0
strlife byte 10 dup(0)

.code
DrawItem proc C x:dword,y:dword,w:dword,h:dword
	ret
DrawItem endp
	
Flush proc C
		mov ebx,currentWin
		cmp ebx,0
		jz open
		cmp ebx,1
		jz mainwindow
	open:
		invoke loadImage,offset srcgame,offset imggame
		invoke beginPaint
		invoke putImageScale,offset imggame,0,0,1000,600
		invoke endPaint
		jmp finish

	mainwindow:
		
		invoke loadImage,offset srcback,offset imgback
		invoke beginPaint

		invoke putImageScale,offset imgback,0,0,1000,600

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,850,50,offset titlescore

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,850,70,offset strscore

		invoke setTextSize,20
		invoke setTextColor,00cc9988h
		invoke setTextBkColor,colorWHITE
		invoke paintText,850,150,offset titlelife

		invoke endPaint
		jmp finish


	finish:
		ret
	Flush endp
end Flush