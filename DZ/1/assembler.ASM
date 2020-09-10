   include "win64ax.inc"

.data
Caption db 'Testing hse programm',0
Message db 'Hello World! Hello HSE!',0

.code
start:
xor r9d,r9d
lea r8,[Caption]
lea rdx,[Message]
xor rcx,rcx
call [MessageBox]
mov ecx,eax
invoke ExitProcess,0
.end start