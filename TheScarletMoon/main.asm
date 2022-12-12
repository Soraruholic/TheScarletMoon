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

winTitle byte "»ÃÏëç²ÔÂÌ·",0


.code

main proc
	invoke init_first
	invoke initWindow,offset winTitle,425,50,1000,600
	invoke Flush
	
	invoke registerMouseEvent,iface_mouseEvent
	invoke registerKeyboardEvent, iface_keyboardEvent
	invoke init_second
	ret
main endp
end main