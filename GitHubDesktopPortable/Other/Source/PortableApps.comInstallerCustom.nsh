!macro CustomCodePostInstall
    ; Move to correct directories
    CreateDirectory $INSTDIR\App\GithubDesktop
    CreateDirectory $INSTDIR\App\GithubDesktop\bin
    CreateDirectory $INSTDIR\App\GithubDesktop\app-3.1.1
    CopyFiles /silent "$INSTDIR\App\setup\lib\net45\*" "$INSTDIR\App\GithubDesktop\app-3.1.1"
    CopyFiles /silent "$INSTDIR\App\setup\lib\net45\GitHubDesktop_ExecutionStub.exe" "$INSTDIR\App\GithubDesktop\GitHubDesktop.exe"
    RMDir /r "$INSTDIR\App\setup"
    ; Create Trampoline
    FileOpen $9 $INSTDIR\App\GithubDesktop\bin\github.bat w ;Opens a Empty File and fills it
    FileWrite $9 "@echo off$\r$\n"
    FileWrite $9 "$\"%~dp0\..\app-3.1.1\resources\app\static\github.bat$\" %*$\r$\n"
    FileClose $9 ;Closes the filled file
!macroend


