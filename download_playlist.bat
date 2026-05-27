@echo off
title Ultimate YouTube Playlist Downloader
color 0A

if not exist "Downloads" mkdir Downloads
if not exist "Logs" mkdir Logs

:menu
cls
echo ==========================================
echo       ULTIMATE YOUTUBE DOWNLOADER
echo ==========================================
echo.
echo 1. Download Playlist - 720p
echo 2. Download Playlist - 1080p
echo 3. Download Playlist - Best Quality
echo 4. Download Audio Only (MP3)
echo 5. Update yt-dlp
echo 6. Exit
echo.
set /p choice=Select Option: 

if "%choice%"=="1" goto p720
if "%choice%"=="2" goto p1080
if "%choice%"=="3" goto best
if "%choice%"=="4" goto audio
if "%choice%"=="5" goto update
if "%choice%"=="6" exit

goto menu


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


:start
cls
echo ==========================================
echo         PLAYLIST DOWNLOAD START
echo ==========================================
echo.

set /p URL=Paste Playlist URL: 

echo.
echo Downloading...
echo.

del Logs\errors.txt >nul 2>&1
del Logs\broken_videos.txt >nul 2>&1

if "%mode%"=="audio" (

    yt-dlp ^
    --extract-audio ^
    --audio-format mp3 ^
    --audio-quality 0 ^
    --yes-playlist ^
    --ignore-errors ^
    --newline ^
    --progress ^
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

findstr /i "ERROR unavailable private deleted forbidden" Logs\errors.txt > Logs\broken_videos.txt

echo.
echo ==========================================
echo          DOWNLOAD FINISHED
echo ==========================================
echo.

if exist Logs\broken_videos.txt (
    echo.
    echo Some videos failed to download:
    echo.
    type Logs\broken_videos.txt
    echo.
    echo Full log saved in:
    echo Logs\broken_videos.txt
) else (
    echo All videos downloaded successfully.
)

echo.
pause
goto menu


:update
cls
echo Updating yt-dlp...
echo.

yt-dlp -U

echo.
echo Update Finished.
pause
goto menu