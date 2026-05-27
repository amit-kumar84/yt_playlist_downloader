@echo off
chcp 65001 >nul
title [ SYSTEM BREACH ] YOUTUBE DOWNLOADER
mode con: cols=95 lines=35
color 0A

if not exist "Downloads" mkdir Downloads
if not exist "Logs" mkdir Logs

:: =========================
:: HACKER INTRO
:: =========================

:boot
cls

echo.
echo.
echo              ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗
echo              ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
echo              ███████║███████║██║     █████╔╝ █████╗  ██████╔╝
echo              ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
echo              ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
echo              ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
echo.
echo                    [ YOUTUBE EXTRACTION SYSTEM ]
echo.
echo ===============================================================
echo.
echo [✓] Initializing Neural Network...
ping localhost -n 2 >nul
echo [✓] Connecting To YouTube Servers...
ping localhost -n 2 >nul
echo [✓] Injecting yt-dlp Engine...
ping localhost -n 2 >nul
echo [✓] Activating FFmpeg Modules...
ping localhost -n 2 >nul
echo [✓] System Ready.
ping localhost -n 1 >nul

goto menu

:: =========================
:: MENU
:: =========================

:menu
cls
color 0A

echo.
echo ======================================================================
echo                     [ CYBER DOWNLOADER CONTROL PANEL ]
echo ======================================================================
echo.
echo     [1] DOWNLOAD PLAYLIST 720P
echo     [2] DOWNLOAD PLAYLIST 1080P
echo     [3] DOWNLOAD MAX QUALITY
echo     [4] EXTRACT AUDIO MP3
echo     [5] UPDATE yt-dlp
echo     [6] OPEN DOWNLOADS FOLDER
echo     [7] EXIT SYSTEM
echo.
echo ======================================================================
echo.

set /p choice=[ROOT@SYSTEM] SELECT OPTION: 

if "%choice%"=="1" goto p720
if "%choice%"=="2" goto p1080
if "%choice%"=="3" goto best
if "%choice%"=="4" goto audio
if "%choice%"=="5" goto update
if "%choice%"=="6" start Downloads & goto menu
if "%choice%"=="7" exit

goto menu

:: =========================
:: QUALITY MODES
:: =========================

:p720
set quality=bv*[height<=720]+ba/b[height<=720]/best
set mode=video
goto start

:p1080
set quality=bv*[height<=1080]+ba/b[height<=1080]/best
set mode=video
goto start

:best
set quality=bv*+ba/best
set mode=video
goto start

:audio
set mode=audio
goto start

:: =========================
:: DOWNLOAD START
:: =========================

:start
cls
color 0A

echo.
echo ======================================================================
echo                     [ TARGET ACQUISITION ]
echo ======================================================================
echo.

set /p URL=[ENTER TARGET PLAYLIST URL] : 

echo.
echo ======================================================================
echo                    [ INITIALIZING DOWNLOAD ]
echo ======================================================================
echo.

del Logs\errors.txt >nul 2>&1
del Logs\broken_videos.txt >nul 2>&1

echo [✓] Bypassing Restrictions...
ping localhost -n 2 >nul

echo [✓] Establishing Secure Connection...
ping localhost -n 2 >nul

echo [✓] Access Granted.
ping localhost -n 1 >nul

echo.
echo ===================== DOWNLOAD LIVE FEED ============================
echo.

if "%mode%"=="audio" (

    yt-dlp ^
    --extract-audio ^
    --audio-format mp3 ^
    --audio-quality 0 ^
    --yes-playlist ^
    --ignore-errors ^
    --newline ^
    --progress ^
    --concurrent-fragments 5 ^
    --js-runtimes node ^
    -o "Downloads/%%(playlist_title)s/%%(playlist_index)s - %%(title)s.%%(ext)s" ^
    "%URL%" ^
    2>Logs\errors.txt

) else (

    yt-dlp ^
    -f "%quality%" ^
    --merge-output-format mp4 ^
    --yes-playlist ^
    --ignore-errors ^
    --newline ^
    --progress ^
    --concurrent-fragments 5 ^
    --js-runtimes node ^
    -o "Downloads/%%(playlist_title)s/%%(playlist_index)s - %%(title)s.%%(ext)s" ^
    "%URL%" ^
    2>Logs\errors.txt

)

:: =========================
:: ERROR CHECK
:: =========================

findstr /i "ERROR unavailable private deleted forbidden" Logs\errors.txt > Logs\broken_videos.txt

echo.
echo ======================================================================
echo                      [ OPERATION COMPLETED ]
echo ======================================================================
echo.

if exist Logs\broken_videos.txt (
    color 0C
    echo.
    echo [WARNING] SOME TARGETS FAILED TO DOWNLOAD
    echo.
    type Logs\broken_videos.txt
    echo.
    echo [LOG LOCATION]
    echo Logs\broken_videos.txt
    echo.
) else (
    color 0A
    echo.
    echo [SUCCESS] ALL FILES DOWNLOADED SUCCESSFULLY
    echo.
)

echo ======================================================================
echo.
pause
goto menu

:: =========================
:: UPDATE SYSTEM
:: =========================

:update
cls
color 0B

echo.
echo ======================================================================
echo                      [ SYSTEM UPDATE ]
echo ======================================================================
echo.

echo [✓] Connecting To GitHub Servers...
ping localhost -n 2 >nul

echo [✓] Downloading Latest yt-dlp Build...
echo.

yt-dlp -U

echo.
echo [✓] UPDATE COMPLETE
echo.

pause
goto menu