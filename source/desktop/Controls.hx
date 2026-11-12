#if desktop
package desktop;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
@:access(flixel.input.gamepad.FlxGamepadManager)
class Controls {
 static var slots:Array<FlxGamepad>=[null,null];
 public static function pad(player:Int):FlxGamepad {
  var all=[for(p in FlxG.gamepads._activeGamepads) if(p!=null) p];
  all.sort((a,b)->a.id-b.id);
  for(i in 0...2)if(slots[i]!=null && all.indexOf(slots[i])<0)slots[i]=null;
  for(p in all)if(slots.indexOf(p)<0){var i=slots.indexOf(null);if(i>=0)slots[i]=p;}
  return player>=1&&player<=2?slots[player-1]:null;
 }
 static function key(player:Int,dir:Int):FlxKey return (player==1?[FlxKey.UP,FlxKey.RIGHT,FlxKey.DOWN,FlxKey.LEFT]:[FlxKey.W,FlxKey.D,FlxKey.S,FlxKey.A])[dir];
 static function buttons(dir:Int):Array<FlxGamepadInputID> return [
 [FlxGamepadInputID.DPAD_UP,FlxGamepadInputID.LEFT_STICK_DIGITAL_UP],
 [FlxGamepadInputID.DPAD_RIGHT,FlxGamepadInputID.LEFT_STICK_DIGITAL_RIGHT],
 [FlxGamepadInputID.DPAD_DOWN,FlxGamepadInputID.LEFT_STICK_DIGITAL_DOWN],
 [FlxGamepadInputID.DPAD_LEFT,FlxGamepadInputID.LEFT_STICK_DIGITAL_LEFT]][dir];
 public static function held(player:Int,dir:Int):Bool {var p=pad(player);return FlxG.keys.anyPressed([key(player,dir)])||(p!=null&&p.anyPressed(buttons(dir)));}
 public static function direction(player:Int,dir:Int):Bool {var p=pad(player);return FlxG.keys.anyJustPressed([key(player,dir)])||(p!=null&&p.anyJustPressed(buttons(dir)));}
 public static function confirm(player:Int):Bool {var p=pad(player);return FlxG.keys.anyJustPressed(player==1?[ENTER,SPACE,Z,PERIOD,BACKSLASH,SLASH]:[GRAVEACCENT,ONE])||(p!=null&&p.justPressed.A);}
 public static function anyConfirm():Bool return confirm(1)||confirm(2);
 public static function pause():Bool return FlxG.keys.anyJustPressed([P,ESCAPE])||FlxG.gamepads.anyJustPressed(START);
 public static function back():Bool return FlxG.keys.anyJustPressed([ESCAPE,BACKSPACE])||FlxG.gamepads.anyJustPressed(B);
 public static function neutral():Bool return !FlxG.keys.anyPressed([UP,RIGHT,DOWN,LEFT,W,D,S,A,ENTER,SPACE,Z,PERIOD,BACKSLASH,SLASH,GRAVEACCENT,ONE,P,ESCAPE,BACKSPACE])&&!FlxG.gamepads.anyInput();
}
#end
