                                  format PE GUI 4.0
entry start
 
include 'win32ax.inc'
 
;================== code =====================
section '.code' code readable executable
;=============================================
 
proc start
        mov [lpFileOp.wFunc],FO_COPY             ; We want the shell to copy a file
        mov [lpFileOp.fFlags],FOF_SILENT         ; .. silently
        mov [lpFileOp.pFrom],SzFileFrom          ; The file which is going to be copied
        mov [lpFileOp.pTo],SzFileTo              ; The name of the new file
 
        invoke SHFileOperationA,lpFileOp         ; Execute the operation
 
        invoke ExitProcess,NULL                  ; Exit this program
endp
 
;=================== data ====================
section '.data' data readable writeable
;=============================================
 
FO_COPY    = 2
FOF_SILENT = 4
SzFileFrom db 'source.txt',0
SzFileTo   db 'target.txt',0
 
struct  SHFILEOPSTRUCT
        hWnd dd ?
        wFunc dd ?
        pFrom dd MAX_PATH
        pTo dd MAX_PATH
        fFlags dw ?
        fAnyOperationsAborted dd ?
        hNameMappings dd ?
        lpszProgressTitle dd ?
ends
 
lpFileOp SHFILEOPSTRUCT
 
;=============================================
section '.idata' import data readable
;=============================================
 
library         kernel32,'KERNEL32.DLL',\
                shell32,'SHELL32.DLL'
 
import          kernel32,\
                ExitProcess,'ExitProcess'
 
import          shell32,\
                SHFileOperationA,'SHFileOperationA'