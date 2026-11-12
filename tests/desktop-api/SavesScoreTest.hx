class SavesScoreTest {
 static function check(ok:Bool,message:String):Void {if(!ok)throw message;}
 static function main():Void {
  Saves.save=new flixel.util.FlxSave();
  Saves.hiscores=["AAA:1000","BBB:900","CCC:800","DDD:700","EEE:600","FFF:500","GGG:450","HHH:400","III:300","JJJ:200"];
  check(Saves.checkScore(500)&&Saves.checkScore(250),"both initially qualify");
  Saves.addScore(500,"ONE");Saves.addScore(250,"TWO");
  check(Saves.hiscores.length==10,"ten scores retained");
  check(Saves.hiscores.indexOf("III:300")>=0,"second score must not evict a better score");
  check(Saves.hiscores.indexOf("TWO:250")==-1,"lower second score trimmed");
  check(Saves.hiscores.indexOf("ONE:500")>=0,"higher first score retained");
  Saves.addScore(2000,"WIN");check(Saves.hiscores[0]=="WIN:2000","scores sorted after insert");
  trace("PASS two-player top-ten score retention");
 }
}
