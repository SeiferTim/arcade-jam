#if desktop
package desktop;
/** Fossil Finders telemetry is pending its verified API registration identifier.
 * Do not substitute another game's ID. Empty GAME_ID intentionally disables
 * identity storage and all network calls. Other platform sources are unchanged.
 */
class DesktopApi {
 public static inline var GAME_ID:String = "";
 public static function boot():Void {
  #if !(arcade_smoke || arcade_regression || native_regression)
  if(validId())DesktopOnline.start(GAME_ID);
  #end
 }
 public static function sendEvent(name:String,value:Float=0):Void {
  #if !(arcade_smoke || arcade_regression || native_regression)
  if(validId())DesktopOnline.sendEvent(name,value);
  #end
 }
 static function validId():Bool return ~/^[0-9a-fA-F]{32}$/.match(GAME_ID);
}
#end
