@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
title [ YOUTUBE PLAYLIST DOWNLOADER - amit-kumar84 ]
mode con: cols=100 lines=35
color 0A

:: ==================================================
:: GLOBAL CONFIGURATION
:: ==================================================
set "SP1=|"
set "SP2=/"
set "SP3=-"
set "SP4=\"
set "ACCENT=0B"
set "HILITE=0F"
set "INFO=0E"
set "WARN=0C"
set "GOOD=0A"
set "OWNER_NAME=amit-kumar84"
set "COPYRIGHT_TEXT=Copyright (c) 2026 amit-kumar84"

set "DOWNLOAD_ROOT=Downloads"
set "LOG_ROOT=Logs"
set "VIDEO_ARCHIVE=%LOG_ROOT%\downloaded_videos.txt"
set "AUDIO_ARCHIVE=%LOG_ROOT%\downloaded_audio.txt"
set "OUTPUT_TEMPLATE=%DOWNLOAD_ROOT%/%%(playlist_title)s/%%(playlist_index)02d→ %%(title)s.%%(ext)s"

:: Prefer the bundled downloader and FFmpeg shipped with this script.
set "PATH=%~dp0;%PATH%"
set "JS_RUNTIME_ARG="
set "YOUTUBE_CLIENT_ARG=--extractor-args youtube:player_client=web_embedded"
where node >nul 2>&1
if not errorlevel 1 set "JS_RUNTIME_ARG=--js-runtimes node"

:: Cookie configuration (default = none)
set "COOKIES_OPTION=none"
set "COOKIES_ARG="
set "COOKIES_FILE="
set "COOKIES_BROWSER="

if not exist "%DOWNLOAD_ROOT%" mkdir "%DOWNLOAD_ROOT%"
if not exist "%LOG_ROOT%" mkdir "%LOG_ROOT%"

:: Check for FFmpeg (critical for merging and audio extraction)
where ffmpeg >nul 2>&1
if errorlevel 1 (
    color %WARN%
    echo [WARNING] FFmpeg not found in PATH. Merging video+audio or audio extraction will fail.
    echo Please install FFmpeg and add it to your system PATH.
    echo.
    pause
)

:: ==================================================
:: BOOT SCREEN
:: ==================================================
:boot
cls
call :spinner "[INITIALIZING INTERFACE]"
call :spinner "[SYNCING TERMINAL COLORS]"
call :spinner "[LOADING YT-DLP CONTROL LAYER]"

color %GOOD%
call :show_header
echo [YOUTUBE EXTRACTION SYSTEM]
echo.
echo               ██╗  ██╗ █████╗  ██████╗██╗  ██╗
echo               ██║  ██║██╔══██╗██╔════╝██║ ██╔╝
echo               ███████║███████║██║     █████╔╝
echo               ██╔══██║██╔══██║██║     ██╔═██╗
echo               ██║  ██║██║  ██║╚██████╗██║  ██╗
echo               ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
echo.
echo                [ YOUTUBE EXTRACTION SYSTEM ]
echo.
echo ==============================================================
echo                Owner: !OWNER_NAME!
echo        !COPYRIGHT_TEXT!
echo.
call :boot_step "[✓] Loading Neural Engine..." "%GOOD%"
call :boot_step "[✓] Connecting To YouTube..." "%ACCENT%"
call :boot_step "[✓] Injecting yt-dlp Modules..." "%HILITE%"
call :boot_step "[✓] Activating FFmpeg Core..." "%ACCENT%"
call :boot_step "[✓] Bypass Successful." "%GOOD%"
goto menu

:: ==================================================
:: MENU
:: ==================================================
:menu
cls
color %ACCENT%
echo.
echo ===============================================================
echo                 YOUTUBE PLAYLIST DOWNLOADER
echo ===============================================================
color %INFO%
echo.
echo ===================================================================
echo                     [ CONTROL PANEL ]
echo ===================================================================
echo.
color %HILITE%
echo   [1] DOWNLOAD PLAYLIST 720P
echo   [2] DOWNLOAD PLAYLIST 1080P
echo   [3] DOWNLOAD MAX QUALITY
echo   [4] EXTRACT AUDIO MP3
echo   [5] UPDATE yt-dlp
echo   [6] OPEN DOWNLOADS FOLDER
echo   [7] OPEN LOGS FOLDER
echo   [8] EXIT
echo   [9] RETRY FAILED ITEMS (custom range)
echo  [10] CONFIGURE COOKIES
color %GOOD%
echo.
echo   Owner: %OWNER_NAME%
echo   %COPYRIGHT_TEXT%
echo   Cookies: %COOKIES_OPTION%
echo.
echo ===================================================================
echo.

set /p choice=[ROOT@SYSTEM] SELECT OPTION:

if "%choice%"=="1" goto p720
if "%choice%"=="2" goto p1080
if "%choice%"=="3" goto best
if "%choice%"=="4" goto audio
if "%choice%"=="5" goto update
if "%choice%"=="6" start "" "%DOWNLOAD_ROOT%" & goto menu
if "%choice%"=="7" start "" "%LOG_ROOT%" & goto menu
if "%choice%"=="8" exit
if "%choice%"=="9" goto retry_range
if "%choice%"=="10" goto cookies_menu
goto menu

:: ==================================================
:: COOKIES CONFIGURATION
:: ==================================================
:cookies_menu
cls
color %INFO%
echo.
echo ===================================================================
echo                     [ COOKIES CONFIGURATION ]
echo ===================================================================
echo.
echo Current: %COOKIES_OPTION%
echo.
echo Choose an option:
echo   [1] None (no cookies)
echo   [2] From browser (Chrome)
echo   [3] From browser (Firefox)
echo   [4] From browser (Edge)
echo   [5] From file (provide path)
echo   [6] Back to main menu
echo.
set /p cookie_choice=[COOKIES] SELECT:
if "%cookie_choice%"=="1" (
    set "COOKIES_OPTION=none"
    set "COOKIES_ARG="
    set "COOKIES_FILE="
    set "COOKIES_BROWSER="
    echo Cookies disabled.
    pause
    goto menu
)
if "%cookie_choice%"=="2" (
    set "COOKIES_OPTION=browser (Chrome)"
    set "COOKIES_ARG=--cookies-from-browser chrome"
    set "COOKIES_BROWSER=chrome"
    echo Using Chrome cookies.
    pause
    goto menu
)
if "%cookie_choice%"=="3" (
    set "COOKIES_OPTION=browser (Firefox)"
    set "COOKIES_ARG=--cookies-from-browser firefox"
    set "COOKIES_BROWSER=firefox"
    echo Using Firefox cookies.
    pause
    goto menu
)
if "%cookie_choice%"=="4" (
    set "COOKIES_OPTION=browser (Edge)"
    set "COOKIES_ARG=--cookies-from-browser edge"
    set "COOKIES_BROWSER=edge"
    echo Using Edge cookies.
    pause
    goto menu
)
if "%cookie_choice%"=="5" (
    echo Enter full path to cookies.txt file (Netscape format):
    set /p COOKIES_FILE=[PATH]:
    if exist "!COOKIES_FILE!" (
        set "COOKIES_OPTION=file (!COOKIES_FILE!)"
        set "COOKIES_ARG=--cookies !COOKIES_FILE!"
        echo Cookies file set.
    ) else (
        color %WARN%
        echo File not found. Cookies unchanged.
        color %INFO%
    )
    pause
    goto menu
)
if "%cookie_choice%"=="6" goto menu
goto cookies_menu

:: ==================================================
:: QUALITY MODES
:: ==================================================
:p720
set quality=bv*[ext=mp4][height<=720]+ba[ext=m4a]/bv*[height<=720]+ba[ext=m4a]/b[ext=mp4][height<=720]/b[height<=720]/best
set mode=video
goto start

:p1080
set quality=bv*[ext=mp4][height<=1080]+ba[ext=m4a]/bv*[height<=1080]+ba[ext=m4a]/b[ext=mp4][height<=1080]/b[height<=1080]/best
set mode=video
goto start

:best
set quality=bv*[ext=mp4]+ba[ext=m4a]/bv*+ba/b[ext=mp4]/b
set mode=video
goto start

:audio
set mode=audio
goto start

:retry_range
set "PLAYLIST_ITEMS_ARG="
echo.
echo Enter the range of items to retry (e.g., 10-20 or 5,8,12)
echo Leave empty to retry all items.
set /p range_input="[RETRY RANGE]: "
if not defined range_input (
    set "PLAYLIST_ITEMS_ARG="
) else (
    set "PLAYLIST_ITEMS_ARG=--playlist-items !range_input!"
)
set mode=video
set quality=bv*+ba/best
set retry_mode=1
goto start

:: ==================================================
:: DOWNLOAD START
:: ==================================================
:start
cls
call :show_header
color %HILITE%
echo [TARGET ACQUIRED]
color %GOOD%
echo.
echo ===================================================================
echo                     [ TARGET ACQUIRED ]
echo ===================================================================
echo.

set /p URL=[ENTER PLAYLIST URL] :
if not defined URL goto start

:: Validate yt-dlp
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo.
    echo [ERROR] yt-dlp was not found in PATH.
    echo Install yt-dlp or make sure it is available.
    echo.
    pause
    goto menu
)

:: Extract playlist ID for logging (optional)
set "PLAYLIST_ID="
for /f "usebackq delims=" %%A in (`yt-dlp !JS_RUNTIME_ARG! !YOUTUBE_CLIENT_ARG! --flat-playlist --skip-download --print "playlist_id" "%URL%" 2^>nul`) do (
    if not defined PLAYLIST_ID set "PLAYLIST_ID=%%A"
)

echo.
echo [✓] Establishing Secure Connection...
ping localhost -n 2 >nul
echo [✓] Access Granted...
ping localhost -n 2 >nul
echo [✓] Starting Download Engine...
if defined COOKIES_ARG echo [✓] Cookies enabled: %COOKIES_OPTION%

echo.
echo ======================= LIVE DOWNLOAD FEED =========================
echo.

:: Clean old error logs
del "%LOG_ROOT%\errors.txt" >nul 2>&1
del "%LOG_ROOT%\broken_videos.txt" >nul 2>&1

if "%mode%"=="audio" (
    set "ARCHIVE_FILE=%AUDIO_ARCHIVE%"
) else (
    set "ARCHIVE_FILE=%VIDEO_ARCHIVE%"
)

if "%mode%"=="audio" (
    title [ AUDIO DOWNLOAD ]
    color 09
    echo [AUDIO MODE]
    color 09

    yt-dlp ^
    !JS_RUNTIME_ARG! ^
    !YOUTUBE_CLIENT_ARG! ^
    --print before_dl:"[NOW DOWNLOADING] %%(playlist_index)02d/%%(playlist_count)02d - %%(title)s " ^
    !PLAYLIST_ITEMS_ARG! ^
    --extract-audio ^
    --audio-format mp3 ^
    --audio-quality 0 ^
    --embed-thumbnail ^
    --add-metadata ^
    --yes-playlist ^
    --ignore-errors ^
    --download-archive "%ARCHIVE_FILE%" ^
    --no-overwrites ^
    --continue ^
    --retries 10 ^
    --fragment-retries 10 ^
    --file-access-retries 10 ^
    --console-title ^
    --no-check-certificate ^
    --compat-options filename-sanitization ^
    --progress-template "download:%%(progress._percent_str)s | %%(progress.speed_str|N/A)s | ETA %%(progress.eta|N/A)s | %%(progress.total_bytes_str|unknown)s" ^
    --progress-template "postprocess:" ^
    --progress ^
    --print after_move:"[DOWNLOADED] %%(playlist_index)02d/%%(playlist_count)02d - %%(title)s" ^
    --concurrent-fragments 5 ^
    --windows-filenames ^
    --trim-filenames 180 ^
    -o "!OUTPUT_TEMPLATE!" ^
    !COOKIES_ARG! ^
    "%URL%" ^
    2>"%LOG_ROOT%\errors.txt"

) else (
    title [ VIDEO DOWNLOAD ]
    color 09
    echo [VIDEO MODE]
    color 09

    yt-dlp ^
    !JS_RUNTIME_ARG! ^
    !YOUTUBE_CLIENT_ARG! ^
    --print before_dl:"[NOW DOWNLOADING] %%(playlist_index)02d/%%(playlist_count)02d - %%(title)s " ^
    !PLAYLIST_ITEMS_ARG! ^
    -f "%quality%" ^
    --merge-output-format mp4 ^
    --yes-playlist ^
    --ignore-errors ^
    --download-archive "%ARCHIVE_FILE%" ^
    --no-overwrites ^
    --continue ^
    --retries 10 ^
    --fragment-retries 10 ^
    --file-access-retries 10 ^
    --console-title ^
    --no-check-certificate ^
    --compat-options filename-sanitization ^
    --progress-template "download:%%(progress._percent_str)s | %%(progress.speed_str|N/A)s | ETA %%(progress.eta|N/A)s | %%(progress.total_bytes_str|unknown)s" ^
    --progress-template "postprocess:" ^
    --progress ^
    --print after_move:"[DOWNLOADED] %%(playlist_index)02d/%%(playlist_count)02d - %%(title)s" ^
    --concurrent-fragments 5 ^
    --windows-filenames ^
    --trim-filenames 180 ^
    -o "!OUTPUT_TEMPLATE!" ^
    !COOKIES_ARG! ^
    "%URL%" ^
    2>"%LOG_ROOT%\errors.txt"
)

:: ==================================================
:: ERROR CHECK AND SUMMARY
:: ==================================================
color 0D

findstr /i /c:"ERROR" /c:"unavailable" /c:"private" /c:"deleted" /c:"forbidden" /c:"HTTP Error" /c:"Sign in to confirm your age" /c:"cookies" "%LOG_ROOT%\errors.txt" > "%LOG_ROOT%\broken_videos.txt"

echo.
echo ===================================================================
echo                     [ DOWNLOAD COMPLETE ]
echo ===================================================================
echo.

if exist "%LOG_ROOT%\broken_videos.txt" (
    for %%I in ("%LOG_ROOT%\broken_videos.txt") do (
        if %%~zI gtr 0 (
            color %WARN%
            echo.
            echo [WARNING] SOME FILES FAILED OR WERE SKIPPED
            echo.
            type "%LOG_ROOT%\broken_videos.txt"
            echo.
            echo [LOG SAVED] %LOG_ROOT%\broken_videos.txt
            echo.
            echo Tip: You can retry these items using option [9] with the appropriate range.
        ) else (
            del "%LOG_ROOT%\broken_videos.txt" >nul 2>&1
            color %GOOD%
            echo.
            echo [SUCCESS] ALL AVAILABLE FILES DOWNLOADED SUCCESSFULLY
            echo.
        )
    )
) else (
    color %GOOD%
    echo.
    echo [SUCCESS] ALL AVAILABLE FILES DOWNLOADED SUCCESSFULLY
    echo.
)

set "retry_mode=0"
set "PLAYLIST_ITEMS_ARG="
echo.
color %INFO%
pause
title [ YOUTUBE PLAYLIST DOWNLOADER - amit-kumar84 ]
goto menu

:: ==================================================
:: HELPER FUNCTIONS
:: ==================================================
:show_header
color %ACCENT%
echo ==============================================================
echo               YOUTUBE PLAYLIST DOWNLOADER
echo ==============================================================
color %GOOD%
exit /b

:boot_step
set "STEP_TEXT=%~1"
set "STEP_COLOR=%~2"
color !STEP_COLOR!
echo !STEP_TEXT!
ping localhost -n 2 >nul
exit /b

:spinner
set "SPINNER_TEXT=%~1"
for %%S in (!SP1! !SP2! !SP3! !SP4!) do (
    title %%S %~1
    ping localhost -n 2 >nul
)
title [ YOUTUBE PLAYLIST DOWNLOADER - amit-kumar84 ]
exit /b

:: ==================================================
:: UPDATE yt-dlp
:: ==================================================
:update
cls
color 0B
echo.
echo ===================================================================
echo                        [ SYSTEM UPDATE ]
echo ===================================================================
echo.
echo [✓] Connecting To GitHub Servers...
ping localhost -n 2 >nul
echo [✓] Downloading Latest Build...
echo.

where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo [ERROR] yt-dlp not found.
    echo.
    pause
    goto menu
)

yt-dlp -U

echo.
echo [✓] UPDATE COMPLETE
echo.
pause
goto menu
