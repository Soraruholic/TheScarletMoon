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

; ����Brick�ṹ�壬������Ϊpublic����
;Brick STRUCT
;	exist DWORD ?; 1���ڣ�0�Ѳ�����
;	posX DWORD ?; λ�ú�����
;	posY DWORD ?; λ��������
;	height DWORD ?; ��
;	width DWORD ?; ��
;Brick ENDS; һ��ʵ��ռ4*5=20B
;Bricks Brick 100 DUP({}); �����б�(�����100������)
;public Bricks
;brickNum DWORD 10; ��������
;public brickNum

; ����Item�࣬ͳһ����ʵ��ĸ�ʽ
Item STRUCT
 exist DWORD ? ; 1���ڣ�0�Ѳ�����
 typ DWORD ? ; ���������
 posX DWORD ? ; λ�ú�����
 posY DWORD ? ; λ��������
 W DWORD ? ; ��
 H DWORD ? ; ��
 vX DWORD ? ; �����ٶ�
 vY DWORD ? ; �����ٶ�
Item ENDS ; һ��ʵ��ռ4*8B=32B

Bricks Item 50 DUP({}) ; brick�б�(�����50��Brick)
public Bricks
brickNum DWORD 10; brick����
public brickNum

InitBrickCoordX DWORD 000,40,80,00,80,00,40,80,120,00,120,00,40,80,120,320,360,400,360,360,360,320,360,400,600,640,680,720,760,600,680,760,680,680,680,0
InitBrickCoordY DWORD 50,50,50,90,90,130,130,130,130,170,170,210,210,210,210,50,50,50,90,130,170,210,210,210,50,50,50,50,50,90,90,90,130,170,210,0
public InitBrickCoordX
public InitBrickCoordY

life DWORD 0
public life

.code

end