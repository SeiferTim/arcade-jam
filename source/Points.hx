package;

import axollib.CyclingSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Points extends CyclingSprite
{
	public function new() 
	{
		super(0, 0, AssetPaths.points__png, [FlxColor.WHITE, FlxColor.RED, FlxColor.YELLOW, FlxColor.GREEN, FlxColor.BLUE, FlxColor.MAGENTA], 20);
		
	}
	
	public function spawn(X, Y):Void
	{
		reset(X - (width / 2), Y - height);
		alpha = 1;
		FlxTween.tween(this, {y:y - 8}, .5, {ease:FlxEase.sineOut, type:FlxTweenType.ONESHOT});
		FlxTween.tween(this, {alpha:0}, .5, {ease:FlxEase.sineOut, type:FlxTweenType.ONESHOT, startDelay:.5, onComplete:function(_) kill() });
	}
	
}