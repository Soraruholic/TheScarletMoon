.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib

include include\vars.inc
include include\model.inc
include include\acllib.inc
include include\view.inc

printf PROTO C :ptr DWORD, :VARARG

.data

coord sbyte "����� %d,%d",0ah,0

.code
;�жϵ���������Ƿ��ھ��ο��ڣ��Ƿ���1�������򷵻�0��
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

; ����¼��ص�����
iface_mouseEvent proc C x:dword,y:dword,button:dword,event:dword
	pushad
	mov ecx,event
	cmp ecx,BUTTON_DOWN
	jne not_click

	invoke printf,offset coord,x,y

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


; �����¼��ص�����
iface_keyboardEvent proc C key:dword, event:dword
	pushad
	mov ecx,event
	cmp ecx,KEY_DOWN
	jne not_press

	.if currentWin == 1
	.endif

not_press:
	popad
	ret
iface_keyboardEvent endp

end