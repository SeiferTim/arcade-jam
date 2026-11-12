import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
class FossilArcadeSmoke extends TitleState {
 override public function create():Void {
  var d=new FossilSmokeDriver();FlxG.plugins.addPlugin(d);
  try{super.create();d.prepare();}catch(e:Dynamic)d.fail(Std.string(e));
 }
}
@:access(TitleState)
@:access(AddScore)
@:access(Leaderboard)
@:access(flixel.input.gamepad.FlxGamepadManager)
@:access(flixel.input.gamepad.FlxGamepad)
private class FossilSmokeDriver extends FlxBasic {
 var device=Sys.getEnv("FOSSIL_TEST_DEVICE");var output=Sys.getEnv("FOSSIL_TEST_RESULT");
 var pads:Array<FlxGamepad>=[];var phase=0;var scenario=0;var started=haxe.Timer.stamp();var heartbeat=0.0;
 var held=false;var heldFrames=0;var cool=0;var key:FlxKey;var button:FlxGamepadInputID;var who=1;
 var checks:Array<String>=[];var pausedAt=0.0;var frozenTimer=0.0;var done=false;
 var x1=0.0;var y1=0.0;var x2=0.0;var y2=0.0;var tileX=0;var tileY=0;var bone:Bone;
 var editing=1;var bumped=false;var oldPlay:PlayState;
 public function new(){super();visible=false;}
 function require(v:Bool,s:String):Void{if(!v)throw s;}
 public function prepare():Void{
  require(device=="keyboard"||device=="gamepad","unknown device");require(FlxG.fullscreen,"fullscreen startup");
  FlxG.keys.reset();for(i in 0...2){var p=FlxG.gamepads.createByID(i,XINPUT);p.reset();pads.push(p);}
  require(desktop.Controls.pad(1)==pads[0]&&desktop.Controls.pad(2)==pads[1],"stable two-pad assignment");
  // Make qualification fixtures deterministic without touching normal saves.
  Saves.hiscores=[for(i in 0...10)"OLD:"+(1000+i)];Saves.saveScores();
  for(color in 0...4){var t=new GameText("AB 123",color);require(t.width>0&&t.height>0,"bitmap font first layout "+color);t.text="A\nB";require(t.height>0,"multiline bitmap bounds");t.destroy();}
  mark("fullscreen, isolated score fixture, four bitmap fonts and two-pad assignment");FlxG.autoPause=false;FlxG.signals.postUpdate.add(step);
 }
 function mark(s:String):Void checks.push(s);
 function code(k:FlxKey):Int{var c:Int=cast k;return c>=65&&c<=90?c+32:(c>=48&&c<=57?c:0);}
 function pulse(k:FlxKey,b:FlxGamepadInputID,p:Int=1,frames:Int=1):Void{
  require(!held,"overlapping pulse");key=k;button=b;who=p;heldFrames=frames;held=true;
  if(device=="keyboard"){require(!FlxG.gamepads.anyButton(),"keyboard path used pad");FlxG.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,code(k),k));}
  else{require(FlxG.keys.firstPressed()==-1,"pad path used keyboard");pads[p-1].getButton(pads[p-1].mapping.getRawID(b)).press();}
 }
 function release():Void{if(device=="keyboard")FlxG.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP,true,false,code(key),key));else pads[who-1].getButton(pads[who-1].mapping.getRawID(button)).release();held=false;cool=5;}
 function top():FlxState{var s=FlxG.state;while(s.subState!=null)s=s.subState;return s;}
 function play():PlayState return Std.isOfType(FlxG.state,PlayState)?cast FlxG.state:null;
 function idle():Bool return play()!=null&&play().started&&!play().gameOver&&play().subState==null&&!play().player_one.moving&&!play().player_two.moving;
 function pause():desktop.Pause return Std.isOfType(top(),desktop.Pause)?cast top():null;
 function soil(p:Player):Void{
  var s=play();tileX=Std.int((p.x-s.map.map.x)/16);tileY=Std.int((p.y-s.map.map.y)/16)+1;
  s.map.map.setTileIndex(tileX,tileY,1,true);
  for(b in s.grpBones.members)if(b!=null&&Math.abs(b.x-(p.x))<16&&Math.abs(b.y-(p.y+16))<16)b.kill();
  bone=new Bone();bone.setPosition(p.x,p.y+16);s.grpBones.add(bone);
 }
 function finishFixture():Void{
  var s=play();s.scores=scenario==0?[20000,0]:scenario==1?[0,21000]:[22000,23000];s.gameTimer=.01;editing=scenario==1?2:1;bumped=false;
 }
 function step():Void{
  if(done)return;
  try{
   var now=haxe.Timer.stamp();if(now-heartbeat>1){heartbeat=now;sys.io.File.saveContent(output+".progress",haxe.Json.stringify({phase:phase,scenario:scenario,state:Type.getClassName(Type.getClass(FlxG.state)),top:Type.getClassName(Type.getClass(top())),elapsed:now-started}));}
   if(now-started>220)throw "timeout phase "+phase+" scenario "+scenario;
   if(held){if(--heldFrames<=0)release();return;}if(cool-->0)return;
   switch(phase){
    case 0:if(Std.isOfType(top(),TitleState)&&(cast top():TitleState).ready){pulse(ENTER,A,1,5);phase=1;}
    case 1:if(idle()){mark("title starts actual game with held confirm");var s=play();x1=s.player_one.x;y1=s.player_one.y;x2=s.player_two.x;y2=s.player_two.y;soil(s.player_one);pulse(DOWN,DPAD_DOWN);phase=2;}
    case 2:if(idle()){var s=play();require(s.player_one.y==y1+16,"P1 moved exactly one tile");require(s.player_two.x==x2&&s.player_two.y==y2,"P1 input does not move P2");require(s.map.map.getTileIndex(tileX,tileY)==13&&!bone.alive&&s.scores[0]>=100,"P1 digs and collects bone");mark("P1 raw movement, soil removal, bone score, P2 independence");soil(s.player_two);pulse(S,DPAD_DOWN,2);phase=3;}
    case 3:if(idle()){var s=play();require(s.player_two.y==y2+16,"P2 moved exactly one tile");require(s.player_one.x==x1&&s.player_one.y==y1+16,"P2 input does not move P1");require(s.map.map.getTileIndex(tileX,tileY)==13&&!bone.alive&&s.scores[1]>=100,"P2 digs and collects bone");mark("P2 raw movement, soil removal, bone score, P1 independence");pulse(ESCAPE,START,2,5);phase=4;}
    case 4:if(pause()!=null){frozenTimer=play().gameTimer;pausedAt=now;phase=5;}
    case 5:if(now-pausedAt>.3){require(pause()!=null&&play().gameTimer==frozenTimer,"pause freezes timer and stays open");mark("held pause stays open and freezes timer");pulse(ESCAPE,B,2);phase=6;}
    case 6:if(idle()){mark("P2 cancels pause and resumes");pulse(ESCAPE,START);phase=7;}
    case 7:if(pause()!=null){pulse(DOWN,DPAD_DOWN);phase=8;}
    case 8:if(pause()!=null&&pause().selected==1){pulse(DOWN,DPAD_DOWN);phase=9;}
    case 9:if(pause()!=null&&pause().selected==2){pulse(ENTER,A);phase=10;}
    case 10:if(pause()!=null&&pause().confirming){require(pause().selected==0,"Exit confirmation defaults Cancel");pulse(ESCAPE,B);phase=11;}
    case 11:if(pause()!=null&&!pause().confirming){mark("Exit cancel preserves pause");pulse(ESCAPE,B);phase=12;}
    case 12:if(idle()){finishFixture();phase=13;}
    case 13:if(Std.isOfType(top(),AddScore)){
      var a:AddScore=cast top();if(a.readyForInput){require(a.p1==(scenario!=1)&&a.p2==(scenario!=0),"correct qualifying players");if(scenario==1)require(a.p2Curs!=null&&a.p2Curs.alpha>0&&a.letters.length==3,"P2-only cursor and letters");mark("timed finish opens initials scenario "+scenario);phase=14;}
     }
    case 14:
     if(Std.isOfType(top(),AddScore)){
      var a:AddScore=cast top();if(!a.readyForInput)return;
      var loc=editing==1?a.p1CLoc:a.p2CLoc;
      if(loc>=3){if(scenario==2&&editing==1){editing=2;bumped=false;}else phase=15;}
      else if(!bumped){pulse(editing==1?UP:W,DPAD_UP,editing);bumped=true;phase=140;}
      else pulse(editing==1?ENTER:ONE,A,editing);
     }else if(Std.isOfType(top(),Leaderboard))phase=15;
    case 140:
     var a:AddScore=cast top();var offset=editing==2&&a.p1?3:0;require(a.letters[offset].text=="B","raw letter increment");if(editing==2){pulse(W,DPAD_UP,2);phase=141;}else phase=14;
    case 141:
     var a:AddScore=cast top();var offset=a.p1?3:0;require(a.letters[offset].text=="C","P2 second letter increment");phase=14;
    case 15:if(Std.isOfType(top(),Leaderboard)&&(cast top():Leaderboard).readyForRestart){
      var expected=scenario==0?["BAA:20000"]:scenario==1?["CAA:21000"]:["BAA:22000","CAA:23000"];
      for(e in expected)require(Saves.hiscores.indexOf(e)>=0,"saved initials "+e);
      var before=Saves.hiscores.copy();Saves.init();for(e in expected)require(Saves.hiscores.indexOf(e)>=0,"disk save roundtrip "+e);
      require(Saves.hiscores.length==before.length,"roundtrip score count");mark("initials and disk save roundtrip scenario "+scenario);oldPlay=play();pulse(ONE,A,2);phase=16;
     }
    case 16:if(idle()&&play()!=oldPlay){mark("leaderboard P2 retry creates fresh gameplay scenario "+scenario);scenario++;if(scenario<3){finishFixture();phase=13;}else{pulse(ESCAPE,START);phase=17;}}
    case 17:if(pause()!=null){pulse(DOWN,DPAD_DOWN);phase=18;}
    case 18:if(pause()!=null&&pause().selected==1){pulse(ENTER,A);phase=19;}
    case 19:if(Std.isOfType(top(),TitleState)&&(cast top():TitleState).ready){mark("pause returns to title");pulse(RIGHT,DPAD_RIGHT);phase=20;}
    case 20:if((cast top():TitleState).selected==1){pulse(ENTER,A);phase=21;}
    case 21:if(pause()!=null){require(pause().selected==0,"title Exit defaults Cancel");pulse(ESCAPE,B);phase=22;}
    case 22:if(Std.isOfType(top(),TitleState)){mark("title Exit cancellation returns to title");pulse(ENTER,A);phase=23;}
    case 23:if(pause()!=null){pulse(RIGHT,DPAD_RIGHT);phase=24;}
    case 24:if(pause()!=null&&pause().selected==1){mark("actual OS Exit selected");write(true,true,null);pulse(ENTER,A);phase=25;}
    case 25:
   }
  }catch(e:Dynamic)fail(Std.string(e)+"\n"+haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
 }
 function write(passed:Bool,exitRequested:Bool,error:Null<String>):Void{sys.io.File.saveContent(output,haxe.Json.stringify({schema:1,mode:"native-raw-input",device:device,passed:passed,exitRequested:exitRequested,error:error,checks:checks,fixtures:["soil and bone directly below each spawn","qualifying scores and expiring timer"],notVerified:["physical controllers/hotplug","full round balance","cabinet focus","live API"]},null,"  "));}
 public function fail(error:String):Void{done=true;write(false,false,error);Sys.exit(1);}
}


