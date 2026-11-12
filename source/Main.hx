package;

#if !desktop
import axollib.AxolAPI;
import axollib.DissolveState;
#end
import flixel.FlxG;
import flixel.FlxGame;
import lime.app.Application;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		Application.current.window.borderless = true;
		#if desktop
		addChild(new FlxGame(540, 360, desktop.Boot, 60, 60, false, true));
		#else
		AxolAPI.firstState = TitleState;
		
		addChild(new FlxGame(0, 0, DissolveState));
		Saves.init();
		#end
		FlxG.autoPause = false;
	}
}
