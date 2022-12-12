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

.data


.code

timer proc C id:dword
	invoke Flush
	ret
timer endp

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
	

	invoke registerTimerEvent,offset timer
	invoke startTimer,0,100
	popad
	ret
InitGame endp

end