@echo off
setlocal
rem
rem VLCでFMモットコムの「朗読一語一絵」を録音する
rem

rem setting
set vlc="C:\Program Files\VideoLAN\VLC\"

rem このファイルを起動した時刻を取得する
call :get_now_time
rem 次の放送までの時間を取得する
call :get_next_cast
rem 放送日時からファイル名を決定する
call :get_file_name
rem 放送開始まで待機する

rem 放送開始30秒前に録音を開始する
call :start_rec

rem 録音が終了したらこのファイルも終了する
goto quit


rem ========sub routine========

rem このファイルを起動した時刻を取得する
:get_now_time

rem 20170130141528（2017/1/30 14:15:28）の形にフォーマットする
set today_YYYYMMDD=%date:~0,4%%date:~5,2%%date:~8,2%
set now_HHmmSS=%time:~0,2%%time:~3,2%%time:~6,2%
echo %today_YYYYMMDD%%now_HHmmSS%

call :get_what_day

exit /b

rem 曜日取得ルーチン
:get_what_day
set /A YYYY=%DATE:~0,4%
set /A MM=%DATE:~5,1% * 10 + %DATE:~6,1%
set /A DD=%DATE:~8,1% * 10 + %DATE:~9,1%
echo Today : %YYYY% %MM% %DD%

if /I %MM% LEQ 2 (
set /A YYYY=%YYYY% - 1
set /A MM=%MM% + 12
)

set /A YOBI=(%YYYY% + %YYYY% / 4 - %YYYY% / 100 + %YYYY% / 400 + (13 * %MM% + 8)/5 + %DD%)%% 7
if %YOBI% == 0 echo SUN
if %YOBI% == 1 echo MON
if %YOBI% == 2 echo TUE
if %YOBI% == 3 echo WED
if %YOBI% == 4 echo THU
if %YOBI% == 5 echo FRI
if %YOBI% == 6 echo SAT

exit /b


rem 次の放送までの時間を取得する
:get_next_cast
rem - 金曜08時15分～28分
rem - 火曜17時45分～


exit /b

rem 放送日時からファイル名を決定する
:get_file_name

exit /b

rem 放送開始30秒前に録音を開始する
:start_rec


%vlc%vlc mms://hdv2.nkansai.tv/fmmotcom

exit /b

rem 録音が終了したらこのファイルも終了する
:quit
exit

