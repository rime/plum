@echo off

setlocal

rem check for updates at https://github.com/git-for-windows/git/releases/latest
set git_version=2.16.3
set git_release=.1

if defined ProgramFiles(x86) (set arch=64) else (set arch=32)

set git_installer=Git-%git_version%%git_release:.1=%-%arch%-bit.exe

if "%git_mirror%" == "taobao" (
  set git_download_url_prefix=https://npm.taobao.org/mirrors/git-for-windows/
) else (
  set git_download_url_prefix=https://github.com/git-for-windows/git/releases/download/
)

set git_download_url=%git_download_url_prefix%v%git_version%.windows%git_release%/%git_installer%

where /q bash
if %errorlevel% neq 0 (
   if exist %git_installer% (
      echo Found installer: %git_installer%
   ) else (
      echo Downloading installer: %git_installer%
      curl -fsSLO %git_download_url%
      if not exist %git_installer% (
         echo Error downloading %git_installer%
         exit /b 1
      )
      echo Download complete: %git_installer%
   )
   echo Installing git ...
   %git_installer% /GitAndUnixToolsOnPath
)

set PATH=%ProgramFiles%\Git\cmd;%ProgramFiles%\Git\mingw%arch%\bin;%ProgramFiles%\Git\usr\bin;%PATH%
rem path

if not defined plum_dir (
   set plum_dir=plum
)

if exist "%plum_dir%"/rime-install (
   bash "%plum_dir%"/rime-install %*
) else (
  echo Downloading rime-install ...
  curl -fsSL https://git.io/rime-install | bash -s -- %*
)
