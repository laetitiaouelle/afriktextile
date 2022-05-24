import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Audio{
    Future<AudioPlayer> play(String sound) async {
    AudioCache cache = new AudioCache();
    //AudioPlayer.logEnabled=true;
    var dbHelper = DBHelper();
    var ct = dbHelper.getCustomer();
    ct.then((data) async {
      for(var i in data) {
        i.son==1 ?  await cache.play("audios/$sound"): null ;
      }
    });
  }
} 