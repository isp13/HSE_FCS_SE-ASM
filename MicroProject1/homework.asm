format PE console
include 'win32ax.inc'


.code


start:  ;����� ������ 

cinvoke GetCommandLine  ; �������� ��������� �� ��������� ������ � �������� eax
mov [commandLine], eax  ; ���������� ��������� � ����������

; ��������� ������� ������ �� ��������� �� �������
cinvoke sscanf,[commandLine],'%*s %d %d %d %d %d %d %d %d',a,b,c,d,e,f,g,h

;���������� ��� ����������� � ������
;���� ���� ���� �� ���� ���� - �������� ������ �� ���������
; 
cmp [b],0
je DEFAULT
cmp [d],0
je DEFAULT
cmp[f],0
je DEFAULT
cmp[h],0
je DEFAULT
jmp CORRECT

DEFAULT:

cinvoke printf, "incorrect input. Default values are used. ",10, 0

mov [a], 2

mov [b],3

mov [c],4

mov [d], 5

mov [e], 6

mov [f], 7

mov [g],8

mov [h], 9

CORRECT:
; ��������� ����� �� ������������ � ��������� 
;+ �� �������� ��������� �����

call CHANGE_SIGNS

; ��������� ����� ����������� �����
call SUM
call CREATE_RES
cinvoke sprintf,sum_res,res

; ��������� �������� ����������� �����
call SUBSTRACT
call CREATE_RES
cinvoke sprintf,sub_res,res

; ��������� ������������ ����������� �����
call MULT
call CREATE_RES
cinvoke sprintf,mult_res,res

; ��������� ������� ����������� �����
call DIVISION
call CREATE_RES
cinvoke sprintf,div_res,res

; ���������� ��������� � �������� ������ ������
cinvoke sprintf, res_str, form_str,[a],[b],[c],[d],[e],[f],[g],[h],sum_res,\
sub_res,mult_res,div_res

; ������� �������� ���������
cinvoke printf, res_str


cinvoke ExitProcess,0

; ��������� �������� ������ � �������, �������� ����������� �� �������,
; + ��������� �� ����
CREATE_RES:
mov [res],0  ; ������� ��������������� ����������

; ��������� ����� �� ��������� �������� ����� ����
cmp [tmp1],0
je FIRST0

;��������� �������� �� ��������� ������ ����� �����
cmp [tmp3],0
je SECOND0

; ���������  �������� �� ������ ����������� ��������
cmp [tmp2],1
je FIRST1

; ��������� �������� �� ������ ����������� ��������
cmp [tmp4],1
je SECOND1

; � ������ ���� ������� ������ �� ���� ��������������
cinvoke sprintf,res,"%d/%d+(%d/%d)*i",[tmp1],[tmp2],[tmp3],[tmp4]
ret

FIRST0:         ;������ ��������� ��� ����
cmp [tmp3],0    ; �������� �������� �� ������ ��������� �����...
je RET0
cmp [tmp4],1    ;� ������ ����������� ��������
je _01

cinvoke sprintf,res,"(%d/%d)*i",[tmp3],[tmp4]   ;���� ��� - ������� �����
ret

SECOND0:       ;������ ��������� 0 ( � ������ 100% �� 0)
cmp [tmp2],1   ;���������, �������� �� ������ ����������� 1
je _10
cinvoke sprintf,res,"%d/%d",[tmp1],[tmp2]   ;���� ��� - ������� �����
ret

FIRST1:     ;������ ����������� 1 (��������� �� ����)
cmp [tmp4],1  ;��������� ������ ����������� �� 1
je _11
cinvoke sprintf,res,"%d+(%d/%d)*i",[tmp1],[tmp3],[tmp4]
ret

SECOND1:     ;������ ������ ����������� - 1
cinvoke sprintf,res,"%d/%d+(%d)*i",[tmp1],[tmp2],[tmp3]
ret

_01:       ;������ ��������� 0 � ������ ����������� 1
cinvoke sprintf,res,"%d*i",[tmp3]
ret

_10:      ;������ ����������� 1 � ������ ��������� 0
cinvoke sprintf,res,"%d",[tmp1]
ret

_11:     ;��� ����������� 1
cinvoke sprintf,res,"%d+(%d)*i",[tmp1],[tmp3]
ret

RET0:   ; ��� ��������� - ����
cinvoke sprintf,res,"0"
ret

;------
SIMPLIFY_ANS:   ;�������� �����, ����������  � ���� tmp1/tmp2 + (tmp3/tmp4)*i
;����� ����� simplify ��� ����� ������

;��������� ����� ��� �������� �����
mov eax,[tmp1]
mov ebx,[tmp2]

call SIMPLIFY
mov [tmp1],eax
mov [tmp2],ebx
 
;��������� ����� ��� ������ �����
mov eax,[tmp3]
mov ebx,[tmp4]

call SIMPLIFY
mov [tmp3],eax
mov [tmp4],ebx

ret

;----------------------------------
; ������ ����� ������� ( ������), ��������� � �������� eax, ����������� - � �������� ebx
SIMPLIFY: 
mov [x],eax
mov [y],ebx

cmp eax,0       ;���� ��������� 0 - �������� ������
je RETURN

call ABS       ;������� ���
call GCD

cmp eax,1      ;���� ��� 1 - �������� ������
je RETURN

mov edx,0
mov eax, [y]          ;����� ����� ����������� �� ���..
div ebx
mov [y],eax

mov eax, [x]
cdq
idiv ebx         ;..� ��������� ���� �����
mov [x],eax

RETURN:
mov ebx,[y]        ;���������� ���� � ��������� eax � ebx
mov eax,[x]
ret

;---------------------
; �������� ���������
SUBSTRACT:
; ��������� ��� ����� ��� � ��������, �� � �������� ������ ������� �����
neg [g]        ;������ ���� � ��������� 
neg [e]        ;� � �����������

call SUM  ; ������ ����� - ������ � tmp1, tmp2, tmp3 � tmp4 ��� �����

neg [e]        ;���������� �� ����� �����
neg [g]

ret


;------------
;�������� ��������
SUM:
;a/b+(c/d)*i + e/f + (g/h)*i

mov eax,[a]     ;�������� ����� �������� �����
mov ebx,[f]     ;a/b+e/f=(a*f+b*e)/(b*f)
imul ebx
mov [tmp1],eax    ;�������� a � f � �������� � tmp1

mov eax,[e]
mov ebx,[b]
imul ebx
add [tmp1],eax    ;�������� b � e, ��������� � tmp1 - � tmp1
                  ;��������� �������� �����

mov eax,[b]
mov ebx,[f]
imul ebx
mov [tmp2],eax    ;����������� b � f, �������� � tmp2 - ������ ��� ����� ��������� ����������� �������� �����
;-----
;������ ����� ��� ������ �����
;�/d+g/h=(c*h+g*d)/(d*h)
mov eax,[c]
mov ebx,[h]
imul ebx
mov [tmp3],eax     ;����������� c � h, �������� � tmp3

mov eax,[g]
mov ebx,[d]
imul ebx
add [tmp3],eax     ;����������� g � d, ��������� � tmp3, �������� ��������� ������ �����

mov eax,[d]
mov ebx,[h]
imul ebx
mov [tmp4],eax     ;����������� d � h, ������ � tmp4 ��������� ������ �����

call SIMPLIFY_ANS   ; ��������� �����
ret


;-----------
; �������� ���������
MULT:
;(a/b+c/d*i)*(e/f+g/h*i)
; ��� ������ ������ �������� ����� � �������� ����� 
; ����������� �������� ����� �����
mov ebx,[a]
mov eax,[e]        ;(a/b)*(e/f)=a*e/(b*f)
imul ebx            ;����������� a � e � ���������� � x
mov [x],eax

mov ebx,[b]        ;����������� b � f
mov eax,[f]
mul ebx

mov ebx,eax         ;������ � ebx ������� ����������� (b*f)
mov eax,[x]         ;� eax - ��������� (a*e)

call SIMPLIFY       ;�������� ���� �����
mov [tmp1],eax
mov [tmp2],ebx
;--------------
;������ ���������� ������ �����
mov ebx,[c]  ;(c/d)*(g/h)=c*g/(d*h)
mov eax,[g]
imul ebx  ;����������� c � g � ���������� � x
mov [x],eax

mov ebx,[d]           ;����������� d � h
mov eax,[h]
mul ebx

mov ebx,eax  ; ������ � edx ����������� (d*h)
mov eax,[x]  ; � eax - ��������� (c*g)

call SIMPLIFY   ;�������� ���� �����
;------
;������ ������ ���������� �� ���������� ����� ����� � ������� �������� �����
;��������� ������
;tmp1/tmp2 + x/y = (tmp1*y + tmp2*x)/(tmp2*y)
mov eax, [tmp1]    ;� [tmp1] ��������� ����� ������ �����
mov ebx, [y]       ;� y ������ ����������� ������ ���������� �����
imul ebx
mov [tmp1],eax     ;���������� tmp1 � y, ��� ���������� � tmp1

mov eax,[x]
mov ebx,[tmp2]    ;���������� tmp2 � x
imul ebx
sub[tmp1],eax     ;������ ��������� �� tmp1 � �������� ��������� �������� ����� 

mov eax,[y]       ;���������� tmp2 �  y
imul ebx
mov [tmp2],eax    ;�������� ����������� �������� ����� � ���������� ��� � tmp2


;--------------------
;(a/b+c/d*i)*(e/f+g/h*i)
; ����� ������ ������ �����
; ����������� �������� ����� ������� ����� � ������ ������ �������
mov ebx,[a]       ;a/b*g/h=(a*g)/(b*h)
mov eax,[g]       ;����������� a � g, ���������� � x
imul ebx 
mov [x],eax

mov ebx,[b]     ;����������� b � h
mov eax,[h]
mul ebx

mov ebx,eax       ;������ � edx ����������� b*h
mov eax,[x]       ;� eax ��������� a*g 

call SIMPLIFY     ;�������� �����
mov [tmp3],eax    ;���������� �� � ��������������� ����������
mov [tmp4],ebx
;--------------
; ������ ���������� �������� ����� ������� ����� � ������ ������ �������
mov ebx,[c]    ;(c/d)*(e/f)=(c*e)/(d*f)
mov eax,[e]
imul ebx        ;����������� c � e, ��������� ������ � x
mov [x],eax

mov ebx,[d]    ;����������� d � f
mov eax,[f]
mul ebx

mov ebx,eax
mov eax,[x]

call SIMPLIFY   ;�������� �����
;------
;������ ������ �����, ���������� �����, � ������� ������ ����� ������
;tmp3/tmp4 + x/y = (tmp3*y + tmp4*x)/(tmp4*y)
mov eax, [tmp3]
mov ebx, [y]
imul ebx
mov [tmp3],eax     ;����������� tmp3 � y � ������ ��������� � tmp3

mov eax,[x]        ;����������� tmp4 � x
mov ebx,[tmp4]
imul ebx
add[tmp3],eax      ;���������� ���������  � tmp3 � �������� ���������
                   ;������ �����

mov eax,[y]
imul ebx          ;����������� tmp4 � y � �������� ����������� ������ �����
mov [tmp4],eax

call SIMPLIFY_ANS 

ret

;----------------------------
DIVISION:
;��� ���������� ������� ����� ��������� ��������� � ����������� �� ����������� 
;=> ����� ��������� ������ ������� �����
;�� ����, (a/b+(c/d)*i)/(e/f + (g/h)*i) = (a/b+(c/d)*i)*(e/f -(g/h)*i)/(e^2/f^2 + g^2/h^2)

;��� ���� ����� �������� ������� ����� ���������, ������� ���������, �������� ���� 
;����� ������ ������ ��� ������� �����
neg [g]
call MULT
neg [g] 

;��������� ��, ��� �����: (e^2/f^2 + g^2/h^2) = (e^2*h^2+g^2*f^2)/(f^2*h^2)
mov eax,[e]        ;�������� e �� e
mov ebx,[e]
imul ebx
imul [h]          ;��������� �������� �� h^2
imul [h]

mov [x],eax       ; � x e^2*h^2

mov eax,[g]      ;������� g �� g
mov ebx,[g]
imul ebx
imul [f]
imul [f]         ;� �� f^2
add [x],eax       ;�������� � x, ������ � x ��������� �����

mov eax,[f]
mov ebx,[f]
mul ebx         ;������� ����������� - ������� f^2 �� h^2
mul [h]
mul [h]

mov ebx,eax
mov eax,[x]

call SIMPLIFY      ;�������� �������� �����

; �������� ������� ����� �� ������������ ����� � ������� �����
;(tmp1/tmp2+(tmp3/tmp4)*i)/(x/y)=tmp1*y/(tmp2*x)+(tmp3*y/(tmp4*x))*i


mov eax,[tmp1]
mul [y]            ;�������� ��������� �������� ����� �� y
mov [tmp1],eax    



mov eax,[tmp2]    ;�������� ����������� �������� ����� �� x
mul [x]
mov [tmp2],eax


mov eax,[tmp3]    ;� ��������� ������
mul [y]
mov [tmp3],eax

call ABS
mov ebx,[tmp4]
cmp eax,0
je S

call GCD
mov eax,[tmp3]
cdq
idiv ebx
mov [tmp3],eax
mov eax,[tmp4]
cdq
idiv ebx
mov [tmp4],eax

S:
mov eax,[tmp4]     ;� ����������� ������
mul [x]
mov [tmp4],eax

call SIMPLIFY_ANS   ;�������� �����
ret

;----------------------
;��������� ����� ����� � ���������
CHANGE_SIGNS:

mov eax, [b]      ;����������� �������� ����� 1 �����
mov edx,[a]
call SIGN
mov [a],edx
mov [b],eax

mov ebx, eax

mov eax, [f]      ;����������� �������� ����� 2 �����
mov edx,[e]
call SIGN
mov [e],edx
mov[f],eax

mov eax, [d]      ;����������� ������ ����� 1 �����
mov edx,[c]
call SIGN
mov [c],edx
mov [d],eax

mov ebx, eax

mov eax, [h]      ;����������� ������ ����� 2 �����
mov edx,[g]
call SIGN
mov [g],edx
mov[h],eax

mov eax, [a]
mov ebx,[b]
call SIMPLIFY
mov [a], eax
mov [b],ebx

mov eax, [c]
mov ebx,[d]
call SIMPLIFY
mov [c], eax
mov [d],ebx

mov eax, [e]
mov ebx,[f]
call SIMPLIFY
mov [e], eax
mov [f],ebx

mov eax, [g]
mov ebx,[h]
call SIMPLIFY
mov [g], eax
mov [h],ebx

ret

;--------------------

;��������� ���� ����������� � ���������
SIGN:
cmp eax,0    ;������� ����� � �����
jl N         ;���� ������ - ������� ���� � � ���������, � � �����������
ja R          ;���� ������ - ��� ��
N:
neg edx
neg eax
R:
ret 

;�������� � eax ������������� ��������(������) �����
ABS:
cmp eax, 0
jl M        ;���� ����� ������ ���� - ������� ��� ����
ret
M:
neg eax
ret
;-----------------------

;�������� ������ ��� ���� ������������� ����� ( �������� �������)
GCD:
N1: cmp eax, ebx        ;���������� ��� �����
je N3                   ;���� ����� - ������������
ja N2                   ; ���� ������ ������ - N2

xchg eax,ebx            ;���� ������ ������ - ������ �������
N2: sub eax, ebx        ;�������� �� ������� (��������) ����� ������
jmp N1                  ;��������� � ������ �����

N3: ret
;-----------

.data
commandLine dd ? ;��������� �� ��������� ������
a dd 0     ;a-��������� �������� ����� ������������ �����
b dd 0     ;b - �����������
c dd 0     ;c - ��������� ������ ����� ������������ �����
d dd 0     ;d - �����������

e dd 0    ;���������� ��� ������� �����
f dd 0
g dd 0
h dd 0


tmp1 dd ?    ;����� ������ �������� ����� ������������ � ��� ����������
tmp2 dd ?    ;� ���� tmp1/tmp2+(tmp3/tmp4)*i
tmp3 dd ?
tmp4 dd ?

x dd ?      ;��������������� ����������
y dd ?
u dd 1
v dd 1

sub_res db 512 dup(?)        ;���������� ���������� ��� ������ �� ��������
sum_res db 512 dup(?) 
mult_res db 512 dup(?) 
div_res db 512 dup(?) 

res db 512 dup(?)

res_str db 512 dup(?)     ;������ ��������� ������
form_str db "your input:",10,10,"m = %d/%d + (%d/%d)*i",10,10,\
"n = %d/%d + (%d/%d)*i",10,10, "result:",10,10,\
"m + n = %s",10,10,"m - n = %s", 10, 10, "m * n = %s",10,10,"m / n = %s", 0



data import

library user32,'USER32.DLL',\
msvcrt, 'MSVCRT.DLL',\
kernel32, 'KERNEL32.DLL',\
shell32, 'SHELL32.DLL'

import user32,\
MessageBox, 'MessageBoxA'

import msvcrt, \
sprintf, 'sprintf', sscanf, 'sscanf', printf, 'printf'

import kernel32, \
ExitProcess, 'ExitProcess'  ,\
GetCommandLine, 'GetCommandLineA'



end data
