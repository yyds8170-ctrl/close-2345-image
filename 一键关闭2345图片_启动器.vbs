' Launcher: force cmd.exe to kill 2345 PicViewer.
' This bypasses the .cmd/.bat file-association hijack.
' All content is pure ASCII, no encoding issues.

On Error Resume Next

Set objShell = CreateObject("WScript.Shell")

' Step 1: stop the guardian service 2345Pic
objShell.Run "cmd.exe /c net stop 2345Pic /y", 0, True

' Step 2: kill all 2345 pic processes
objShell.Run "cmd.exe /c taskkill /F /IM 2345PicViewer.exe /T", 0, True
objShell.Run "cmd.exe /c taskkill /F /IM 2345PicWorker.exe /T", 0, True
objShell.Run "cmd.exe /c taskkill /F /IM PicService.exe /T", 0, True
objShell.Run "cmd.exe /c taskkill /F /IM 2345PicHelper.exe /T", 0, True
objShell.Run "cmd.exe /c taskkill /F /IM 2345PicUpdater.exe /T", 0, True

' Step 3: second pass (catch anything restarted)
WScript.Sleep 1000
objShell.Run "cmd.exe /c taskkill /F /IM 2345PicViewer.exe /T", 0, True
objShell.Run "cmd.exe /c taskkill /F /IM 2345PicWorker.exe /T", 0, True

If Err.Number <> 0 Then
    WScript.Echo "Error: " & Err.Description
Else
    WScript.Echo "Done. 2345 PicViewer closed."
End If