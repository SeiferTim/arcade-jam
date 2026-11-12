#if macro
package desktop;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
/** Compatibility is scoped to this desktop project and the pinned shared library. */
class DesktopCompatibility {
 public static function install():Void {
  Compiler.addGlobalMetadata("axollib.CyclingSprite","@:build(desktop.DesktopCompatibility.cyclingSprite())",false,true,false);
 }
 public static function cyclingSprite():Array<Field> {
  var fields=Context.getBuildFields();var patched=false;
  function safe(e:Expr):Expr {
   if(ExprTools.toString(e)=="pixels.clone()") {patched=true;return macro (pixels==null?null:pixels.clone());}
   return ExprTools.map(e,safe);
  }
  for(f in fields)switch(f.kind){
   case FFun(fn):
    if(f.name=="new")fn.expr=safe(fn.expr);
    if(f.name=="draw") {var body=fn.expr;fn.expr=macro {
     if(colors==null||colors.length==0||baseImage==null){super.draw();return;}
     if(changeRate<=0){
      if(currentIndex!=0 && pixels!=null){pixels.copyPixels(baseImage,baseImage.rect,new openfl.geom.Point());currentIndex=0;dirty=true;}
      super.draw();return;
     }
     $body;
    };}
   default:
  }
  if(!patched)Context.error("Pinned CyclingSprite constructor changed; review compatibility",Context.currentPos());
  return fields;
 }
}
#end
