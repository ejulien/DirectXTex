@echo off
rem Copyright (c) Microsoft Corporation. All rights reserved.
rem Licensed under the MIT License.

setlocal
set error=0

set FXCOPTS=/nologo /WX /Ges /Zi /Zpc /Qstrip_reflect /Qstrip_debug

set PCFXC="%WindowsSdkBinPath%%WindowsSDKVersion%\x86\fxc.exe"
if exist %PCFXC% goto continue
set PCFXC="%WindowsSdkDir%bin\%WindowsSDKVersion%\x86\fxc.exe"
if exist %PCFXC% goto continue
set PCFXC="%WindowsSdkDir%bin\x86\fxc.exe"
if exist %PCFXC% goto continue

set PCFXC=fxc.exe

:continue
@if not exist Compiled mkdir Compiled
call :CompileShader BC7Encode TryMode456CS
call :CompileShader BC7Encode TryMode137CS
call :CompileShader BC7Encode TryMode02CS
call :CompileShader BC7Encode EncodeBlockCS

call :CompileShader BC6HEncode TryModeG10CS
call :CompileShader BC6HEncode TryModeLE10CS
call :CompileShader BC6HEncode EncodeBlockCS
echo.

if %error% == 0 (
    echo Shaders compiled ok
) else (
    echo There were shader compilation errors!
)

endlocal
exit /b

:CompileShader
set fxc=%PCFXC% %1.hlsl %FXCOPTS% /Tcs_5_0 /E%2 /FhCompiled\%1_%2.inc /FdCompiled\%1_%2.pdb /Vn%1_%2
set fxc4=%PCFXC% %1.hlsl %FXCOPTS% /Tcs_4_0 /DEMULATE_F16C /E%2 /FhCompiled\%1_%2_cs40.inc /FdCompiled\%1_%2_cs40.pdb /Vn%1_%2
echo.
echo %fxc%
%fxc% || set error=1
%fxc4% || set error=1
exit /b
