package sys;
class Http {
    public static var requests:Array<Dynamic>=[];
    public static var fail=false;
    public static var mode="normal";
    public static var rejected=0;
    public var cnxTimeout:Float=-1;
    public var onData:String->Void;
    public var onError:String->Void;
    var url:String;
    var headers:Map<String,String>=[];
    var body="";
    public function new(url:String){this.url=url;}
    public function setHeader(name:String,value:String):Void headers.set(name,value);
    public function setPostData(data:String):Void body=data;
    public function customRequest(post:Bool,output:haxe.io.Output,?socket:sys.net.Socket):Void {
        requests.push({url:url,timeout:cnxTimeout,headers:headers,body:body,post:post});
        if(fail)throw "network error";
        try {
            if(mode=="oversize")output.prepare(1000000000);
            if(mode=="slow")Sys.sleep(3.05);
            var bytes=haxe.io.Bytes.ofString('{"status":200}');
            output.writeBytes(bytes,0,bytes.length);
            output.close();
        } catch(e:Dynamic){rejected++;throw e;}
    }
}
