package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class AddScore extends FlxSubState 
{

	private var scores:Array<Int>;
	
	private var letters:Array<GameText>;
	
	private var back:FlxSprite;
	private var texts:Array<GameText>;
	
	private var p1:Bool = false;
	private var p2:Bool = false;
	
	private var readyForInput:Bool = false;
	
	private var p1CLoc:Int = 0;
	private var p2CLoc:Int = 0;

	private var p1Curs:GameText;
	private var p2Curs:GameText;
	
	private var p1Done:Bool = false;
	private var p2Done:Bool = false;
	
	public function new(Scores:Array<Int>) 
	{
		super(FlxColor.TRANSPARENT);
		
		scores = Scores;
		
	}
	
	override public function create():Void 
	{
		
		var baseY:Float = 4;
		var l:GameText;
		letters = [];
		
		back = new FlxSprite();
		texts = [];
		
		var text:GameText;
		
		if (Saves.checkScore(scores[0]))
		{
			p1 = true;
			
			text = new GameText("P1 HI-SCORE!", GameText.COLOR_WHITE);
			text.screenCenter(FlxAxes.X);
			text.alignment = FlxTextAlign.CENTER;
			texts.push(text);
			text.y = baseY;
			text.changeRate = 100;
			text.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			text.alpha = 0 ;
			baseY += text.height;
			
			l = new GameText("A", GameText.COLOR_WHITE);
			l.x = (FlxG.width / 2) - (l.width * 2);
			l.y = baseY;
			l.alpha = 0;
			l.changeRate = 100;
			l.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			letters.push(l);
			texts.push(l);
			
			l = new GameText("A", GameText.COLOR_WHITE);
			l.x = (FlxG.width / 2) - (l.width * .5);
			l.y = baseY;
			l.alpha = 0;
			l.changeRate = 100;
			l.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			letters.push(l);
			texts.push(l);
			
			l = new GameText("A", GameText.COLOR_WHITE);
			l.x = (FlxG.width / 2) + (l.width);
			l.y = baseY;
			l.alpha = 0;
			l.changeRate = 100;
			l.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			letters.push(l);
			texts.push(l);
			
			baseY += l.height;
			
			p1Curs = new GameText("^", GameText.COLOR_WHITE);
			p1Curs.alpha = 0;
			p1Curs.changeRate = 100;
			baseY += p1Curs.height;
			p1Curs.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			
			
			baseY += 4;
		}
		
		if (Saves.checkScore(scores[1]))
		{
			
			p2 = true;
			
			text = new GameText("P2 HI-SCORE!", GameText.COLOR_WHITE);
			text.screenCenter(FlxAxes.X);
			text.alignment = FlxTextAlign.CENTER;
			texts.push(text);
			text.y = baseY + 4;
			text.alpha = 0 ;
			text.changeRate = 100;
			text.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			baseY += text.height;
			
			l = new GameText("A", GameText.COLOR_WHITE);
			l.x = (FlxG.width / 2) - (l.width * 2);
			l.y = baseY;
			l.alpha = 0;
			l.changeRate = 100;
			l.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			letters.push(l);
			texts.push(l);
			
			l = new GameText("A", GameText.COLOR_WHITE);
			l.x = (FlxG.width / 2) - (l.width * .5);
			l.y = baseY;
			l.alpha = 0;
			l.changeRate = 100;
			l.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			letters.push(l);
			texts.push(l);
			
			l = new GameText("A", GameText.COLOR_WHITE);
			l.x = (FlxG.width / 2) + (l.width);
			l.y = baseY;
			l.alpha = 0;
			l.changeRate = 100;
			l.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			letters.push(l);
			texts.push(l);
			
			baseY += l.height;
			
			p2Curs = new GameText("^", GameText.COLOR_WHITE);
			p2Curs.alpha = 0;
			p2Curs.changeRate = 100;
			baseY += p2Curs.height;
			p2Curs.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
			
		}
		
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
		
		FlxTween.num(FlxG.height / 2, (FlxG.height/2) - (back.height/2), .5, {type:FlxTweenType.ONESHOT, ease:FlxEase.backOut, onComplete:function(_){
			readyForInput = true;
			if (p1)
			{
				setCursPos(0, p1CLoc);
				p1Curs.alpha = 1;
				p1Curs.y = letters[0].y + letters[0].height;
				add(p1Curs);
			}
			if (p2)
			{
				if (p1)
				{
					setCursPos(1, p2CLoc);
					p2Curs.alpha = 1;
					p2Curs.y = letters[3].y + letters[3].height;
					add(p2Curs);
				}
				else
				{
					setCursPos(1, p2CLoc);
					p1Curs.alpha = 1;
					p1Curs.y = letters[0].y + letters[0].height;
					add(p1Curs);
				}
			}
			
		}},updatePos);
		
		super.create();
	}
	
	private function setCursPos(Which:Int, Letter:Int):Void
	{
		if (Which == 0 || !p1)
		{
			p1Curs.x = letters[Letter].x + (letters[Letter].width / 2) - (p1Curs.width / 2);
		}
		if (Which == 1)
		{
			
			p2Curs.x = letters[Letter+3].x + (letters[Letter+3].width / 2) - (p2Curs.width / 2);
		}
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
		if (readyForInput)
		{
			if (p1)
			{
				if (!p1Done)
				{
					if (FlxG.keys.anyJustReleased([RIGHT, BACKSLASH, PERIOD]))
					{
						p1CLoc++;
						if (p1CLoc < 3)
							setCursPos(0, p1CLoc);
						else
						{
							p1Curs.alpha = 0;
							p1Done = true;
						}
					}
					else if (FlxG.keys.anyJustReleased([UP]))
					{
						letters[p1CLoc].text = String.fromCharCode( FlxMath.wrap(letters[p1CLoc].text.charCodeAt(0) + 1, "A".charCodeAt(0), "Z".charCodeAt(0)));
					}
					else if (FlxG.keys.anyJustReleased([DOWN]))
					{
						letters[p1CLoc].text = String.fromCharCode( FlxMath.wrap(letters[p1CLoc].text.charCodeAt(0) - 1, "A".charCodeAt(0), "Z".charCodeAt(0)));
					}
				}
			}
			if (p2)
			{
				if (!p2Done)
				{
					if (p1)
					{
						if (FlxG.keys.anyJustReleased([D, GRAVEACCENT, ONE]))
						{
							p2CLoc++;
							if (p2CLoc < 3)
								setCursPos(1, p2CLoc);
							else
							{
								p2Curs.alpha = 0;
								p2Done = true;
							}
						}
						else if (FlxG.keys.anyJustReleased([W]))
						{
							letters[p2CLoc+3].text = String.fromCharCode( FlxMath.wrap(letters[p2CLoc+3].text.charCodeAt(0) + 1, "A".charCodeAt(0), "Z".charCodeAt(0)));
						}
						else if (FlxG.keys.anyJustReleased([S]))
						{
							letters[p2CLoc+3].text = String.fromCharCode( FlxMath.wrap(letters[p2CLoc+3].text.charCodeAt(0) - 1, "A".charCodeAt(0), "Z".charCodeAt(0)));
						}
					}
					else if (!p1)
					{
						if (FlxG.keys.anyJustReleased([D, GRAVEACCENT, ONE]))
						{
							p2CLoc++;
							if (p2CLoc < 3)
								setCursPos(1, p2CLoc);
							else
							{
								p2Curs.alpha = 0;
								p2Done = true;
							}
						}
						else if (FlxG.keys.anyJustReleased([W]))
						{
							letters[p2CLoc].text = String.fromCharCode( FlxMath.wrap(letters[p2CLoc].text.charCodeAt(0) + 1, "A".charCodeAt(0), "Z".charCodeAt(0)));
						}
						else if (FlxG.keys.anyJustReleased([S]))
						{
							letters[p2CLoc].text = String.fromCharCode( FlxMath.wrap(letters[p2CLoc].text.charCodeAt(0) - 1, "A".charCodeAt(0), "Z".charCodeAt(0)));
						}
					}
				}
			}
			if ((!p1 || p1Done) && (!p2 || p2Done))
			{
				// both players done!
				var newscores:Array<String> =[];
				if (p1)
				{
					newscores.push(letters[0].text + letters[1].text + letters[2].text + ":" + Std.string(scores[0]));
					Saves.addScore(scores[0], letters[0].text + letters[1].text + letters[2].text);
				}
				if (p2)
				{
					if (!p1)
					{
						newscores.push( letters[0].text + letters[1].text + letters[2].text + ":" + Std.string(scores[1]));
						Saves.addScore(scores[1], letters[0].text + letters[1].text + letters[2].text);
					}
					else
					{
						newscores.push(  letters[3].text + letters[4].text + letters[5].text + ":" + Std.string(scores[1]));
						Saves.addScore(scores[1], letters[3].text + letters[4].text + letters[5].text);
					}
				}
				
				openSubState(new Leaderboard(newscores));
				
			}
		}
		
		super.update(elapsed);
	}
	
}