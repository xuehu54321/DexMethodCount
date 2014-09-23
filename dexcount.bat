@ECHO OFF
IF "%1"=="" GOTO MissingFileNameError
IF EXIST "%1" (GOTO ContinueProcessing) ELSE (GOTO FileDoesntExist)

:ContinueProcessing
set FileNameToProcess=%1
set FileNameForDx=%~n1.dex
IF "%~x1"==".dex" GOTO ProcessWithPowerShell

REM preprocess Jar with dx
IF "%~x1"==".jar" (
	ECHO Processing Jar %FileNameToProcess% with DX!
	CALL dx --dex --output=%FileNameForDx% %FileNameToProcess%
	set FileNameToProcess=%FileNameForDx%
	IF ERRORLEVEL 1 GOTO DxProcessingError
)

:ProcessWithPowerShell
ECHO Counting methods in DEX file %FileNameToProcess%
CALL powershell -noexit -executionpolicy bypass "& ".\printhex.ps1" %FileNameToProcess%
GOTO End

:MissingFileNameError
@ECHO Missing filename for processing
GOTO End

:DxProcessingError
@ECHO Error processing file %1% with dx!
GOTO End

:FileDoesntExist
@ECHO File %1% doesn't exist!
GOTO End

:End