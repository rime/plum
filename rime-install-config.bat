rem Location of download cache
rem set download_cache_dir=%TEMP%

rem China mirror for downloading Git for Windows installer
rem set git_mirror=taobao

rem Do not update packages; only download missing files.
rem CAUTION: may suffer from incomplete downloads.
rem set no_update=1

rem Location of Rime configuration manager and downloaded packages
rem set plum_dir=%APPDATA%\plum

rem Location of Rime user directory
rem set rime_dir=%APPDATA%\Rime

rem Disable /plum/ bash script; use batch installer only.
rem set use_plum=0

REM SET THE rime_dir VALUE
REM FOR /F "USEBACKQ tokens=1,3,4,5,6,7,8,9,10,11,12 delims= " %I IN ( ` reg query HKCU\Software\Rime\Weasel\ /v RimeUserDir ` ) DO IF [%I] EQU [RimeUserDir] SET rime_dir=%J %K %L %M %N %O %P %Q %R %S
