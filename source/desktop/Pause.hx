#if desktop
package desktop;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
class Pause extends FlxSubState {
 public var selected:Int=0;
 public var confirming:Bool=false;
 var titleOnly:Bool;
 var gate=new Gate();
 var text:GameText;
 var oldTween:Bool;
 var oldTimer:Bool;
 var frozen=false;
 public function new(titleOnly=false){super(0xee161622);this.titleOnly=titleOnly;}
 override public function create():Void {
  oldTween=FlxTween.globalManager.active;oldTimer=FlxTimer.globalManager.active;frozen=true;
  FlxTween.globalManager.active=false;FlxTimer.globalManager.active=false;
  text=new GameText("");add(text);paint();super.create();
 }
 function paint():Void {
  var choices=confirming?["Cancel","Exit game"]:(titleOnly?["Cancel","Exit game"]:["Resume","Title screen","Exit game"]);
  text.text=(confirming||titleOnly?"Exit game?":"Paused")+"\n\n"+[for(i in 0...choices.length)(i==selected?"> ":"  ")+choices[i]].join("\n");text.screenCenter();
 }
 override public function update(elapsed:Float):Void {
  super.update(elapsed);if(!gate.allow())return;
  if(Controls.back()||Controls.pause()){if(confirming){confirming=false;selected=0;gate.reset();paint();}else close();return;}
  var n=confirming||titleOnly?2:3;
  if(Controls.direction(1,0)||Controls.direction(2,0)||Controls.direction(1,3)||Controls.direction(2,3)){selected=(selected+n-1)%n;paint();}
  else if(Controls.direction(1,2)||Controls.direction(2,2)||Controls.direction(1,1)||Controls.direction(2,1)){selected=(selected+1)%n;paint();}
  else if(Controls.anyConfirm()){
   if(confirming||titleOnly){if(selected==0)close();else Sys.exit(0);}
   else if(selected==0)close();
   else if(selected==1){restore();FlxG.switchState(()->new TitleState());}
   else{confirming=true;selected=0;gate.reset();paint();}
  }
 }
 function restore():Void {if(frozen){frozen=false;FlxTween.globalManager.active=oldTween;FlxTimer.globalManager.active=oldTimer;}}
 override public function close():Void {restore();super.close();}
 override public function destroy():Void {restore();super.destroy();}
}
#end
