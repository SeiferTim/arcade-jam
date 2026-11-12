import desktop.DesktopApi;
import flixel.FlxG;
import flixel.util.FlxSave;
class FossilApiTest {
 static function main(){
  if(DesktopApi.GAME_ID!="")throw "Unverified Fossil game identifier";
  DesktopApi.sendEvent("Game:Event:Launch");
  FlxG.game={};
  DesktopApi.boot();DesktopApi.boot();
  DesktopApi.sendEvent("Game:Progress:Level",1);
  if(FlxSave.log.length!=0)throw "Missing ID must not create identity storage or send telemetry";
  trace("Fossil missing-ID adapter stays inert");
 }
}
