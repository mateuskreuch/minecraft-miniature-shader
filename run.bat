set mcpath=%UserProfile%\AppData\Roaming\.minecraft\shaderpacks
del %mcpath%\*.tmp
del %mcpath%\a.zip
del %mcpath%\b.zip
"C:\Programas\7-Zip\7z.exe" a %mcpath%\b.zip %~dp0\shaders
"C:\Programas\7-Zip\7z.exe" a %mcpath%\a.zip %~dp0\shaders