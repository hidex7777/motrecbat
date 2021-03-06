#####もろもろ設定
$ichigoichie = '一語一絵'
#15分×60秒録音
$recording_seconds = 15 * 60
#vlcのインストールディレクトリ
$vlcexe = 'C:\Program Files\VideoLAN\VLC\vlc.exe'
#CSRAのサイトにあるASFファイルをダウンロードしてテキストエディタで開くとストリーミングのURLが書いてある
$openmms = 'mms://hdv2.nkansai.tv/fmmotcom'
#MP3ファイルを保存するディレクトリ
$destdir = 'E:\music\fm-mot\'

#起動した日時
$date = Get-Date
#echo $date
$time = $date.ToString("HHmmss")
#echo $time
$yobi = [String]$date.ToString("dddd")
#echo "今日は${yobi}です"
#echo "今は${time}です"

#次回放送は？
# - 金曜08時15分～28分
####### - 火曜17時45分～
# - 月曜18時45分～
function getNextCast{
  if ($yobi -eq "土曜日") {
    #echo "次回は2日後の月曜日"
    [DateTime]$val = (Get-Date $date.AddDays(2) -Hour 18 -Minute 44 -Second 30)
    return $val
  } elseif ($yobi -eq "日曜日") {
    #echo "次回は1日後の月曜日"
    [DateTime]$val = (Get-Date $date.AddDays(1) -Hour 18 -Minute 44 -Second 30)
    return $val
  } elseif ($yobi -eq "月曜日") {
  if ([int]$time -lt 184400) {
      #echo "次回は今日の夕方"
      [DateTime]$val = (Get-Date -Hour 18 -Minute 44 -Second 30)
      return $val
    } else {
      #echo "次回は4日後の金曜"
      [DateTime]$val = (Get-Date $date.AddDays(4) -Hour 8 -Minute 14 -Second 30)
      return $val
    }
  } elseif ($yobi -eq "火曜日") {
    #echo "次回は3日後の金曜日"
    [DateTime]$val = (Get-Date $date.AddDays(3) -Hour 8 -Minute 14 -Second 30)
    return $val
  } elseif ($yobi -eq "水曜日") {
      #echo "次回は2日後の金曜"
      [DateTime]$val = (Get-Date $date.AddDays(2) -Hour 8 -Minute 14 -Second 30)
      return $val
  } elseif ($yobi -eq "木曜日") {
      #echo "次回は1日後の金曜"
      [DateTime]$val = (Get-Date $date.AddDays(1) -Hour 8 -Minute 14 -Second 30)
      return $val
  } elseif ($yobi -eq "金曜日") {
    if ([int]$time -lt 81400) {
      #echo "次回は今日の朝"
      [DateTime]$val = (Get-Date -Hour 8 -Minute 14 -Second 30)
      return $val
    } else {
      #echo "次回は3日後の月曜"
      [DateTime]$val = (Get-Date $date.AddDays(3) -Hour 18 -Minute 44 -Second 30)
      return $val
    }
  }
}

function getSleepSecond([DateTime]$nc){
  #次回まで何秒なのか
  $ss = ([DateTime]$nc - $date).TotalSeconds
  return $ss
}

function startRec{
  Start-Process -FilePath $vlcexe -ArgumentList "-I dummy $openmms :sout=#transcode{acodec=mp3,ab=192}:std{access=file,mux=raw,dst=$destfile}' --run-time=$recording_seconds vlc://quit" -Wait
}

#====main procedure====
#次回放送日時を取得する
[DateTime]$next_casting = getNextCast
#echo "next_casting is : " $next_casting

#ファイル名決定
$destfile = $destdir + $ichigoichie + "　" + $next_casting.AddSeconds(30).ToString("yyyyMMdd-HHmm") + ".mp3"

#次回放送日時まで待機する
$sleep_seconds = getSleepSecond $next_casting
#echo "sleep second is : " $sleep_seconds
Start-Sleep -s $sleep_seconds

#次回放送日時の30秒前に録音実行
startRec
