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

; 定义Brick结构体，并设置为public变量
;Brick STRUCT
;	exist DWORD ?; 1存在，0已不存在
;	posX DWORD ?; 位置横坐标
;	posY DWORD ?; 位置纵坐标
;	height DWORD ?; 长
;	width DWORD ?; 宽
;Brick ENDS; 一个实例占4*5=20B
;Bricks Brick 100 DUP({}); 物体列表(最多有100个物体)
;public Bricks
;brickNum DWORD 10; 物体数量
;public brickNum

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

Bricks Item 50 DUP({}) ; brick列表(最多有50个Brick)
public Bricks
brickNum DWORD 10; brick数量
public brickNum

InitBrickCoordX DWORD 000,40,80,00,80,00,40,80,120,00,120,00,40,80,120,320,360,400,360,360,360,320,360,400,600,640,680,720,760,600,680,760,680,680,680,0
InitBrickCoordY DWORD 50,50,50,90,90,130,130,130,130,170,170,210,210,210,210,50,50,50,90,130,170,210,210,210,50,50,50,50,50,90,90,90,130,170,210,0
public InitBrickCoordX
public InitBrickCoordY

life DWORD 0
public life

.code

end