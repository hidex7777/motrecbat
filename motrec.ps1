#もろもろ設定
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
$time = $date.ToString("HHmmss")
$yobi = $date.ToString("dddd")
echo "今日は${yobi}です"

#次回放送は？
# - 金曜08時15分～28分
# - 火曜17時45分～

function getNextCast{
  switch($yobi){
    "土曜日"{
      echo "次回は3日後の火曜日"
      return get-date $date.AddDays(3) -Hour 17 -Minute 44 -Second 30
    }
    "日曜日"{
      echo "次回は2日後の火曜日"
      return get-date $date.AddDays(2) -Hour 17 -Minute 44 -Second 30
    }
    "月曜日"{
      echo "次回は1日後の火曜日"
      return get-date $date.AddDays(1) -Hour 17 -Minute 44 -Second 30
    }
    "火曜日"{
      if([int]$time -lt 1745){
        echo "次回は今日の夕方"
        return get-date -Hour 17 -Minute 44 -Second 30
      }else{
        echo "次回は3日後の金曜"
        return get-date $date.AddDays(3) -Hour 8 -Minute 14 -Second 30
      }
    }
    "水曜日"{
      echo "次回は2日後の金曜"
      return get-date $date.AddDays(2) -Hour 8 -Minute 14 -Second 30
    }
    "木曜日"{
      echo "次回は1日後の金曜"
      return get-date $date.AddDays(1) -Hour 8 -Minute 14 -Second 30
    }
    "金曜日"{
      if([int]$time -lt 815){
        echo "次回は今日の朝"
        return get-date -Hour 8 -Minute 14 -Second 30
      }else{
        echo "次回は4日後の火曜"
        return get-date $date.AddDays(4) -Hour 17 -Minute 44 -Second 30
      }
    }
  }
}
function getSleepSecond($nc){
  #次回まで何秒なのか
  $ss = ($nc - $date).TotalSeconds
  return $ss
}
function startRec{
  Start-Process -FilePath $vlcexe -ArgumentList "-I dummy $openmms :sout=#transcode{acodec=mp3}:std{access=file,mux=raw,dst=$destfile}' --run-time=$recording_seconds vlc://quit" -Wait
}

#====TEST====
#$recording_seconds = 60


#====TEST SETTING====

#====main procedure====
#次回放送日時を取得する
$next_casting = getNextCast
#$next_casting = (get-date -Hour 23 -Minute 39 -Second 0)
$destfile = $destdir + "$ichigoichie　" + $next_casting.AddSeconds(30).ToString("yyyyMMdd-HHmm") + ".mp3"
#次回放送日時まで待機する
$sleep_seconds = getSleepSecond $next_casting
Start-Sleep -s $sleep_seconds
#次回放送日時の30秒前に録音実行
startRec
