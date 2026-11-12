#if desktop
package desktop;
class Gate {
 var armed=false;
 public function new(){}
 public function reset():Void {armed=false;}
 public function allow():Bool {if(armed)return true;if(Controls.neutral())armed=true;return false;}
}
#end
