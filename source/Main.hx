package;

import axollib.AxolAPI;
import axollib.DissolveState;
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
		AxolAPI.firstState = TitleState;
		
		addChild(new FlxGame(0, 0, DissolveState));
		Saves.init();
		FlxG.autoPause = false;
	}
}
