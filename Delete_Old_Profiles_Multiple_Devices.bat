@ECHO OFF
SET ThisScriptsDirectory=\\USALPLATP01\DropBox\Sidt_Saunders\Scripts\Script_Files\Delete_Old_Profiles_Multiple_Devices\
SET PowerShellScriptPath=%ThisScriptsDirectory%Delete_Old_Profiles_Multiple_Devices.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%PowerShellScriptPath%""' -Verb RunAs}";