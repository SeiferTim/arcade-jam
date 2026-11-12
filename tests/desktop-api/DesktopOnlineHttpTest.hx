import desktop.*;
@:access(desktop.DesktopOnline)
class DesktopOnlineHttpTest {
    static var checks=0;
    static function check(ok:Bool,label:String):Void {checks++;if(!ok)throw label;}
    static function main():Void {
        var q=new DesktopOnlineDispatcher(DesktopOnline.post,job->job());
        check(q.offer('{"event_name":"Game:Event:Launch"}'),"transport accepts payload");
        var r=sys.Http.requests[0];
        check(sys.Http.requests.length==1 && r.url=="https://axolstudio.com/api/2.0/add/event","exact known event endpoint");
        check(r.timeout==3.0 && r.post==true,"bounded timeout and POST");
        check(r.headers.get("Content-Type")=="application/json; charset=utf-8","JSON content type");
        check(r.body=='{"event_name":"Game:Event:Launch"}',"transport preserves serialized event");
        sys.Http.fail=true;
        check(q.offer('{"event_name":"failed"}'),"optional send exception contained");
        check(sys.Http.requests.length==2,"failed send attempted once without automatic retry");
        sys.Http.fail=false;
        check(q.offer('{"event_name":"next"}') && sys.Http.requests.length==3,"later independent event still sends");
        sys.Http.mode="oversize";
        q.offer("oversize");
        check(sys.Http.rejected==1 && sys.Http.requests.length==4,"oversized fake response rejected without retry");
        sys.Http.mode="slow";
        q.offer("slow");
        check(sys.Http.rejected==2 && sys.Http.requests.length==5,"slow fake response rejected at deadline boundary without retry");
        sys.Http.mode="normal";
        q.offer("after limits");
        check(sys.Http.requests.length==6 && sys.Http.rejected==2,"worker recovers after response limits");
        trace(checks+" telemetry HTTP boundary assertions passed (fake transport, no network)");
    }
}
