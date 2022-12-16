:: Clean project and project plugins Binaries Intermediate Saved dirs.
::
:: **WARNING!**
::
:: This script will permanently delete folders and files from project.
:: Should be used with caution!
::
:: Dirs deleted from project:
:: - .vs
:: - Binaries
:: - Build
:: - DerivedDataCache
:: - Intermediate
:: - Saved\\Autosaves
:: - Saved\\Cooked
:: - Saved\\Logs
:: - Saved\\MaterialStats
:: - Saved\\MaterialStatsDebug
:: - Saved\\Shaders
:: - Saved\\SourceControl
:: - Saved\\StagedBuilds
:: - Saved\\Temp
:: - Saved\\Config\\CrashReportClient
::
:: Files deleted from project:
:: - *.sln
::
:: Dirs deleted from project plugins:
:: - Plugins\\*\\Binaries
:: - Plugins\\*\\Intermediate
:: - Plugins\\*\\Saved
::
:: ***NOTE - currently ignoring project plugins in sub dirs (like `Plugins\GameFeatures`)***
::
:: ***TODO - this list should be autogenerated***


call "%~dp0\Core\config.bat"

echo.
call %UTILS_PATH% echo_red "WARNING!!"
echo.
call %UTILS_PATH% echo_red "This script will permanently delete some folders and files from project."
echo.
CHOICE /C YN /M "Press Y to continue, N for for cancel."
if %errorlevel%==1 goto :perform_cleaning_with_timeout
echo.
call %UTILS_PATH% echo_yellow "Exiting..."
timeout 3 >nul
exit /b

:perform_cleaning_with_timeout
cls
setlocal enabledelayedexpansion
set "_spc=          "
set "_bar==========="
<con: color 0A

for /f %%a in ('copy/Z "%~dpf0" nul')do for /f skip^=4 %%b in ('echo;prompt;$H^|cmd')do set "BS=%%b" & set "CR=%%a"
for /l %%L in (1 1 10)do (
    set /A _sec=10-%%L
    <con: set/p "'=!CR!!BS!!CR![!_bar:~0,%%~L!!BS!!_spc:~%%L!] Starting cleaning in !_sec! seconds"<nul
    >nul timeout.exe 1
)
endlocal & color
cls
echo.

rem Can be called from other batch file to perform cleaning without prompt with 'call clean_intermediate_files.bat perform_cleaning'
:perform_cleaning
pushd "%PROJECT_ROOT_PATH%"


set DIRS_TO_REMOVE=^
.vs ^
Binaries ^
Build ^
DerivedDataCache ^
Intermediate ^
Saved\Autosaves ^
Saved\Cooked ^
Saved\Logs ^
Saved\MaterialStats ^
Saved\MaterialStatsDebug ^
Saved\Shaders ^
Saved\SourceControl ^
Saved\StagedBuilds ^
Saved\Temp ^
Saved\Config\CrashReportClient

echo.
call %UTILS_PATH% echo_blue "Processing root project directories..."
echo.

for %%f in (%DIRS_TO_REMOVE%) do (
    call :SUB_RemoveDir "%%f"
)

echo.
call %UTILS_PATH% echo_blue "Processing plugins..."
echo.

for /D %%I in ("Plugins\*") do (
    for %%f in (Binaries Intermediate Saved) do (
    call :SUB_RemoveDir "%%I\%%f"
    )
)

echo.
call %UTILS_PATH% echo_blue "Processing files..."
echo.

set FILES_TO_REMOVE=*.sln
for %%f in (%FILES_TO_REMOVE%) do (
    call :SUB_RemoveFile "%%f"
)

call %UTILS_PATH% task_finished %errorlevel%

popd

exit /b

:SUB_RemoveDir
if exist "%~1\" (
    call %UTILS_PATH% echo_red "Directory %~1 exist. Removing"
    rmdir /s /q %1
) else (
    call %UTILS_PATH% echo_yellow "Directory %~1 not exist. Skipping."
)

exit /b

:SUB_RemoveFile
if exist "%~1" (
    call %UTILS_PATH% echo_red "File %~1 exist. Removing"
    del /q %1
    )
)

exit /b