package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import lime.system.System;

class Leaderboard extends FlxSubState
{
	private var newScore:Array<String>;
	private var back:FlxSprite;
	private var texts:Array<GameText>;
	private var readyForRestart:Bool = false;

	public function new(?NewScore:Array<String>)
	{
		super(FlxColor.TRANSPARENT);

		if (NewScore == null)
			newScore = [];
		else
			newScore = NewScore;

	}

	override public function create():Void
	{

		var baseY:Float = 0;

		back = new FlxSprite();
		texts = [];

		var text:GameText = new GameText("--- LEADERBOARD ---", GameText.COLOR_BIG);
		text.alignment = FlxTextAlign.CENTER;
		text.screenCenter(FlxAxes.X);
		text.y = 4;
		text.changeRate = 100;
		text.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
		text.alpha = 0;

		baseY = text.y + text.height + 12;

		texts.push(text);

		Saves.sort();

		for (h in Saves.hiscores)
		{

			var split:Array<String> = h.split(":");

			text = new GameText(split[0] + StringTools.lpad("", ".", 10) + StringTools.lpad(split[1], "0", 6), GameText.COLOR_WHITE);
			text.alignment = FlxTextAlign.CENTER;
			text.screenCenter(FlxAxes.X);
			text.y = baseY;
			baseY += text.height;
			
			//trace(h, newScore, newScore.indexOf(h));
			
			if (newScore.indexOf(h) >= 0)
			{
				text.changeRate = 100;
				text.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			}
			text.alpha = 0;
			texts.push(text);
		}

		text = new GameText("Press Any Key to Play Again!", GameText.COLOR_WHITE);
		text.alignment = FlxTextAlign.CENTER;
		text.screenCenter(FlxAxes.X);
		text.y = baseY + 4;
		baseY += text.height;
		text.changeRate = 100;
		text.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
		text.alpha = 0;
		texts.push(text);

		back.makeGraphic(Math.ceil(Math.max(texts[0].width, texts[1].width) + 20), Math.ceil(baseY - 4 + 20), FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(back, 0, 0, back.width, back.height, 10, 10, FlxColor.BLACK, {thickness:2, color:FlxColor.WHITE});

		back.y = FlxG.height / 2;
		back.screenCenter(FlxAxes.X);
		back.alpha = 0;

		add(back);

		for (t in texts)
		{
			t.y += back.y + 10;
			add(t);
		}

		FlxTween.num(0, 1, .15, {type:FlxTweenType.ONESHOT, ease:FlxEase.sineOut}, updateAlpha);

		FlxTween.num(FlxG.height / 2, (FlxG.height/2) - (back.height/2), .5, {type:FlxTweenType.ONESHOT, ease:FlxEase.backOut, onComplete:function(_)
		{
			readyForRestart = true;

		}
																			 },updatePos);

		super.create();
	}

	private function updatePos(Value:Float):Void
	{
		var diff:Float =  back.y - Value;
		back.y = Value;
		for (t in texts)
			t.y -= diff;

	}

	private function updateAlpha(Value:Float):Void
	{
		back.alpha = Value;
		for (t in texts)
			t.alpha = Value;
	}

	override public function update(elapsed:Float):Void
	{
		if (readyForRestart)
		{
			if (FlxG.keys.anyJustPressed([ESCAPE]))
			{
				System.exit(0);
			}

			if (FlxG.keys.anyJustPressed([PERIOD, GRAVEACCENT, ONE, BACKSLASH, SLASH]))
				FlxG.resetState();
		}

		super.update(elapsed);
	}

}