import desktop.*;
import flixel.FlxG;
import flixel.util.FlxSave;
@:access(desktop.DesktopOnline)
class DesktopOnlineFacadeTest {
    static var checks=0;
    static var sent:Array<String>=[];
    static function check(ok:Bool,label:String):Void {checks++;if(!ok)throw label;}
    static function reset():Void {
        DesktopOnline.session=new DesktopOnlineSession();
        DesktopOnline.storage=null;
        DesktopOnline.dispatcher=new DesktopOnlineDispatcher(s->{FlxSave.log.push("send");sent.push(s);},job->job());
        sent=[];FlxSave.log=[];FlxSave.failBind=false;FlxSave.failFlush=false;FlxSave.throwBind=false;
    }
    static function main():Void {
        reset();
        check(!DesktopOnline.start("existing-key"),"startup waits for game engine");
        check(FlxSave.log.length==0 && sent.length==0,"early startup has no storage/transport");
        FlxG.game={};
        check(!DesktopOnline.start(""),"empty key disabled");
        check(FlxSave.log.length==0,"empty key creates no save");
        check(DesktopOnline.start("existing-key"),"valid desktop starts");
        check(sent.length==1,"startup emits exactly one launch");
        var first:Dynamic=haxe.Json.parse(sent[0]);
        check(first.event_name=="Game:Event:Launch" && first.game_id=="existing-key","launch keeps existing event contract");
        check(first.player_id==DesktopOnline.playerId && ~/^[a-f0-9-]{36}$/.match(DesktopOnline.playerId),"facade uses persisted generated identity");
        check(FlxSave.log.join("|")=="bind:fossil-finders-desktop-telemetry-v1:axolstudio|flush|send","separate save flushed before first event");
        check(DesktopOnline.start("existing-key") && sent.length==1,"repeat startup does not emit twice");
        check(!DesktopOnline.start("other-game") && sent.length==1,"facade refuses different identity mid-session");
        DesktopOnline.sendEvent("Game:Progress:Got:key01");
        var next:Dynamic=haxe.Json.parse(sent[1]);
        check(next.event_name=="Game:Progress:Got:key01" && next.value==0 && next.player_id==first.player_id,"existing events forward with stable identity/default value");
        var id=DesktopOnline.playerId;
        reset();
        check(DesktopOnline.start("existing-key") && DesktopOnline.playerId==id,"new session reuses stored identity");
        reset();FlxSave.failBind=true;
        check(!DesktopOnline.start("existing-key") && sent.length==0 && DesktopOnline.playerId=="","bind failure stays offline");
        DesktopOnline.sendEvent("Launch");
        check(sent.length==0,"events after failed bind ignored");
        reset();FlxSave.failFlush=true;
        check(!DesktopOnline.start("existing-key") && sent.length==0,"flush failure stays offline");
        reset();FlxSave.throwBind=true;
        check(!DesktopOnline.start("existing-key") && sent.length==0,"storage exception cannot escape");
        trace(checks+" telemetry facade assertions passed");
    }
}
