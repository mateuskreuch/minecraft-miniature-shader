set mcpath=%UserProfile%\AppData\Roaming\.minecraft\shaderpacks
del %mcpath%\*.tmp
del %mcpath%\a.zip
del %mcpath%\b.zip
"C:\Programas\7-Zip\7z.exe" a %mcpath%\b.zip %~dp0shaders
"C:\Programas\7-Zip\7z.exe" a %mcpath%\a.zip %~dp0shaders

@echo off
setlocal enabledelayedexpansion

set basePath=%UserProfile%\AppData\Roaming\.minecraft\versions

for /D %%v in ("%basePath%\*") do (
    set mcpath=%%v\shaderpacks
    if exist "!mcpath!" (
        echo Cleaning and updating: !mcpath!

        del /q "!mcpath!\*.tmp"
        del /q "!mcpath!\a.zip"
        del /q "!mcpath!\b.zip"

        "C:\Programas\7-Zip\7z.exe" a "!mcpath!\b.zip" %~dp0shaders
        "C:\Programas\7-Zip\7z.exe" a "!mcpath!\a.zip" %~dp0shaders
    )
)

endlocal