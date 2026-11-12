#if desktop
package desktop;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
class Boot extends FlxState {
 var remaining=1.5;
 var switched=false;
 override public function create():Void {
  super.create();Saves.init();DesktopApi.boot();
  var logo=new FlxSprite(0,0,"axollib/images/white-logo-w-rainbow.png");
  var scale=Math.min(1,Math.min(440/logo.width,280/logo.height));
  logo.scale.set(scale,scale);logo.updateHitbox();logo.screenCenter();add(logo);
 }
 override public function update(elapsed:Float):Void {
  super.update(elapsed);remaining-=elapsed;
  if(!switched&&remaining<=0){switched=true;
   #if arcade_smoke
   FlxG.switchState(()->new FossilArcadeSmoke());
   #else
   FlxG.switchState(()->new TitleState());
   #end
  }
 }
}
#end
