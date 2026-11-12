#if desktop
package desktop;
#if !(arcade_regression || arcade_smoke || native_regression)
import flixel.FlxG;
import flixel.util.FlxSave;

/**
 * Desktop-only, event-only AxolAPI adapter.
 * Uses no login/account APIs and never persists or retries outbound event packets.
 * Call start from an engine-ready state, not before constructing FlxGame.
 */
class DesktopOnline {
    static var session=new DesktopOnlineSession();
    static var storage:FlxSave;
    static var dispatcher:DesktopOnlineDispatcher;
    public static var playerId(get,never):String;
    static function get_playerId():String return session.playerId;

    public static function start(key:String):Bool {
        if(key==null || StringTools.trim(key)=="" || FlxG.game==null)return false;
        try {
            if(storage==null) {
                var candidate=new FlxSave();
                if(!candidate.bind("fossil-finders-desktop-telemetry-v1","axolstudio")) {
                    candidate.destroy();
                    return false;
                }
                storage=candidate;
            }
            return session.start(key,
                () -> Std.isOfType(storage.data.anonymousGuid,String) ? cast storage.data.anonymousGuid : null,
                guid -> {storage.data.anonymousGuid=guid;return storage.flush();},
                newGuid,
                () -> {
                    if(dispatcher==null)
                        dispatcher=new DesktopOnlineDispatcher(post,function(job):Void {sys.thread.Thread.create(job);});
                    sendEvent("Game:Event:Launch");
                }
            );
        } catch(_:Dynamic) {
            // Optional telemetry and local identity storage cannot prevent offline play.
            return false;
        }
    }

    public static function sendEvent(name:String,value:Float=0):Void {
        if(dispatcher==null || !session.started)return;
        try {
            var body=session.payload(name,value,Date.now().getTime());
            if(body!=null)dispatcher.offer(body);
        } catch(_:Dynamic) {}
    }

    static function newGuid():String {
        // This is an anonymous attribution identifier, not an authentication credential.
        var bytes=[for(_ in 0...16)Std.int(Math.random()*256)];
        bytes[6]=(bytes[6]&15)|64;
        bytes[8]=(bytes[8]&63)|128;
        var hex=[for(b in bytes)StringTools.hex(b,2)].join("").toLowerCase();
        return hex.substr(0,8)+"-"+hex.substr(8,4)+"-"+hex.substr(12,4)+"-"+hex.substr(16,4)+"-"+hex.substr(20,12);
    }

    static function post(payload:String):Void {
        // Runs only on the transport worker; no Flixel or save access here.
        var http=new sys.Http("https://axolstudio.com/api/2.0/add/event");
        http.cnxTimeout=3.0;
        http.setHeader("Content-Type","application/json; charset=utf-8");
        http.setPostData(payload);
        http.onData=function(_:String):Void {};
        http.onError=function(_:String):Void {};
        var budget=new DesktopOnlineBudget(3.0);
        var socket=new DesktopOnlineSocket(budget);
        try http.customRequest(true,new desktop.DesktopOnlineBudget.DesktopOnlineSink(budget),socket)
        catch(_:Dynamic) {};
        // Also closes on errors before customRequest's internal try block.
        try socket.close() catch(_:Dynamic) {};
    }
}
#end
#end
