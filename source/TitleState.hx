package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class TitleState extends FlxState 
{
	
	private var ready:Bool = false;

	override public function create():Void 
	{
		
		var back:FlxSprite = new FlxSprite(0, 0, AssetPaths.title_screen__png);
		add(back);
		
		FlxG.sound.playMusic(AssetPaths.Peace_Sign_wit_dramz__wav);
		FlxG.camera.fade(FlxColor.BLACK, .5, true, function() {
			var pressAny:GameText = new GameText("Press any Key to Play!", GameText.COLOR_WHITE);
			pressAny.changeRate = 100;
			pressAny.colors = [ 0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			pressAny.screenCenter(FlxAxes.X);
			pressAny.y = FlxG.height;
			add(pressAny);
			FlxTween.tween(pressAny, {y:FlxG.height - pressAny.height - 10}, .2, {type:FlxTweenType.ONESHOT, ease:FlxEase.backOut, onComplete:function(_){
				ready = true;
			}});
		});
		
		super.create();
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.keys.anyJustPressed([ESCAPE]))
		{
			System.exit(0);
		}
		if (ready)
		{
			if (FlxG.keys.anyJustPressed([PERIOD, GRAVEACCENT, ONE, BACKSLASH, SLASH]))
			{
				ready = false;
				FlxG.sound.music.fadeOut(.4);
				FlxG.camera.flash(FlxColor.WHITE, .2, function() {
					FlxG.camera.fade(FlxColor.BLACK, .2, false, function() {
						FlxG.switchState(new PlayState());
					});
				});
			}
		}
		super.update(elapsed);
	}
}