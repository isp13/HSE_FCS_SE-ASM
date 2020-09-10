include 'win32ax.inc'

.code

  start:

        invoke  MessageBox,HWND_DESKTOP,"How are you doing today?",invoke GetCommandLine,MB_YESNO

        .if eax = IDYES
                invoke  MessageBox,HWND_DESKTOP,"I am happy that you are happy","Hello!",MB_OK
        .endif
        .if eax = IDNO
                invoke  MessageBox,HWND_DESKTOP,"Dont worry be happy","Hello!",MB_OK
        .endif


        invoke  ExitProcess,0

.end start