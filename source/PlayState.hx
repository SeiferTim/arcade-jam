package;

import axollib.CyclingSprite;
import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public static inline var TILESIZE:Int = 16;

	public var map:TiledLevel;

	public var player_one:Player;
	public var player_two:Player;

	public var scores:Array<Int>;
	
	public var poneScoreText:GameText;
	public var ptwoScoreText:GameText;
	
	public var grpBones:FlxTypedGroup<Bone>;
	public var grpPoints:FlxTypedGroup<Points>;
	
	public var pickaxe:CyclingSprite;
	public var axeTimer:Float = 0;
	
	public var gameTimer:Float =  90;
	public var gameTimeText:GameText;
	
	public var started:Bool = false;
	
	public var startMessage:GameText;
	public var startBack:FlxSprite;
	
	public var gameOver:Bool  = false;
	
	public var grpEnemies:FlxTypedGroup<Enemy>;
	
	override public function create():Void
	{

		
		
		map = new TiledLevel(AssetPaths.map__tmx);
		map.map.x = (FlxG.width / 2) - (map.fullWidth / 2);
		map.map.y = FlxG.height - map.fullHeight;
		add(map.map);
		
		var clouds:FlxBackdrop = new FlxBackdrop(AssetPaths.clouds__png, 0, 0, true, false, 10, 0);
		clouds.x = 0;
		clouds.y = 19;
		clouds.velocity.x = -5;
		add(clouds);
		
		var top:FlxSprite = new FlxSprite(0, 20, AssetPaths.top__png);
		top.screenCenter(FlxAxes.X);
		
		add(top);
		
		grpBones = new FlxTypedGroup<Bone>();
		add(grpBones);
		
		grpEnemies = new FlxTypedGroup<Enemy>();
		add(grpEnemies);
		
		pickaxe = new CyclingSprite(0, 0, AssetPaths.pickaxe__png, [0xffd77bba, 0xffdf7126, 0xfffbf236,  0xff99e550, 0xff5fcde4], 60);
		pickaxe.kill();
		add(pickaxe);
		
		fillMap();

		player_one = new Player(this, 1);
		player_one.y = map.map.y + map.fullHeight - (TILESIZE * 19);
		player_one.x = map.map.x + (TILESIZE * 10);
		add(player_one);
		
		// if 2 players:???

		player_two = new Player(this, 2);
		player_two.y = map.map.y + map.fullHeight - (TILESIZE * 19);
		player_two.x = map.map.x + (TILESIZE * 24);
		add(player_two);
		
		///

		scores = [0, 0];

		var p1Text:GameText = new GameText("P1-", GameText.COLOR_BLUE);
		poneScoreText = new GameText("000000", GameText.COLOR_BLUE);
		p1Text.x = (FlxG.width / 4) - ((poneScoreText.width+p1Text.width)/2);
		p1Text.y = 4;
		add(p1Text);
		poneScoreText.x = p1Text.x + p1Text.width;
		poneScoreText.y = 4;
		add(poneScoreText);
		
		
		
		var p2Text:GameText = new GameText("P2-", GameText.COLOR_RED);
		ptwoScoreText = new GameText("000000", GameText.COLOR_RED);
		p2Text.x = (FlxG.width / 2) + (FlxG.width / 4) - ((ptwoScoreText.width + p2Text.width) / 2);
		ptwoScoreText.x = p2Text.x + p2Text.width;
		p2Text.y = 4;
		add(p2Text);
		ptwoScoreText.y = 4;
		add(ptwoScoreText);
		
		grpPoints = new FlxTypedGroup<Points>(20);
		add(grpPoints);
		
		
		startBack = new FlxSprite();
		startBack.makeGraphic(FlxG.width, Std.int(FlxG.height * .25), FlxColor.BLACK);
		startBack.alpha = 0;
		startBack.screenCenter();
		add(startBack);
		
		startMessage = new GameText("Ready?", GameText.COLOR_BIG);
		startMessage.alignment = FlxTextAlign.CENTER;
		startMessage.screenCenter();
		startMessage.alpha = 0;
		add(startMessage);
		
		
		gameTimeText = new GameText("1:30", GameText.COLOR_BIG);
		gameTimeText.alignment = FlxTextAlign.CENTER;
		gameTimeText.screenCenter(FlxAxes.X);
		gameTimeText.y = 4;
		gameTimeText.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
		add(gameTimeText);
		
		FlxG.camera.setScrollBoundsRect(0, 0, FlxG.width, FlxG.height, true);

		super.create();
		
		FlxG.camera.fade(FlxColor.BLACK, .2, true, startGame);
	}
	
	private function startGame():Void
	{
		FlxTween.tween(startBack, {alpha:1}, .33, {type:FlxTweenType.ONESHOT, ease:FlxEase.circIn, startDelay:.2, onComplete:function(_){
			FlxTween.tween(startMessage, {alpha:1}, .15, {type:FlxTweenType.ONESHOT, ease:FlxEase.backOut, startDelay:.1, onComplete:function(_){
				FlxG.sound.play(AssetPaths.baDerng__wav);
				FlxTween.tween(startMessage, {alpha:0}, .15, {type:FlxTweenType.ONESHOT, ease:FlxEase.sineOut, startDelay:1, onComplete:function(_){
					startMessage.text = "Set!";
					startMessage.screenCenter();
					FlxTween.tween(startMessage, {alpha:1}, .15, {type:FlxTweenType.ONESHOT, ease:FlxEase.backOut, startDelay:.1, onComplete:function(_){
						FlxG.sound.play(AssetPaths.baDerng__wav);
						FlxTween.tween(startMessage, {alpha:0}, .15, {type:FlxTweenType.ONESHOT, ease:FlxEase.sineOut, startDelay:1, onComplete:function(_){
							startMessage.text = "DIG!!!";
							startMessage.screenCenter();
							FlxTween.tween(startMessage, {alpha:1}, .15, {type:FlxTweenType.ONESHOT, ease:FlxEase.backOut, startDelay:.1, onComplete:function(_){
								FlxG.sound.play(AssetPaths.baDing__wav);
								FlxTween.tween(startMessage, {alpha:0}, .1, {type:FlxTweenType.ONESHOT, startDelay:.2, onComplete:function(_) {
									FlxTween.tween(startMessage, {alpha:1}, .1, {type:FlxTweenType.ONESHOT, startDelay:.2, onComplete:function(_) {
										FlxG.sound.play(AssetPaths.baDing__wav);
										FlxTween.tween(startMessage, {alpha:0}, .1, {type:FlxTweenType.ONESHOT, startDelay:.2, onComplete:function(_) {
											FlxTween.tween(startMessage, {alpha:1}, .1, {type:FlxTweenType.ONESHOT, startDelay:.2, onComplete:function(_) {
												FlxG.sound.play(AssetPaths.baDing__wav);
												FlxTween.tween(startMessage, {alpha:0}, .1, {type:FlxTweenType.ONESHOT, startDelay:1, onComplete:function(_) {
													startMessage.kill();
													FlxTween.tween(startBack, {alpha:0}, .15, {type:FlxTweenType.ONESHOT, ease:FlxEase.circOut, onComplete:function(_) {
														started = true;
														FlxG.sound.playMusic(AssetPaths.Uwaa___wav);
													}});
												}});
											}});
										}});
									}});
								}});
							}});
						}});
					}});
				}});
			}});
		}});
	}
	
	public function spawnPoints(X:Int, Y:Int):Void
	{
		var p:Points = grpPoints.recycle();
		if (p == null)
			p = new Points();
		p.spawn(X, Y);
		grpPoints.add(p);
	}
	
	private function fillMap():Void
	{
		var spaces:Array<FlxPoint> = [];
		
		for (x in 0...map.width)
		{
			for (y in 5...map.height)
			{
				if (FlxG.random.bool((map.height - y + 5) * 2.5))
				{
					var t:Int = map.map.getTile(x, y);
					map.map.setTile(x, y, t + 12);
					if (y>7)
						spaces.push(FlxPoint.get(x, y));
				}
				if (y > 4)
				{
					if (FlxG.random.bool(y * (y *.25) * .5))
					{
						var b:Bone = new Bone();
						b.x = map.map.x + (x * TILESIZE);
						b.y = map.map.y + (y * TILESIZE);
						grpBones.add(b);
					}
				}
			}
		}
		for (i in 0...12)
		{
			FlxG.random.shuffle(spaces);
			var p:FlxPoint = spaces.pop();
			var e:Enemy = new Enemy(this);
			e.x = map.map.x  +  (p.x * TILESIZE);
			e.y = map.map.y  +  (p.y * TILESIZE);
			grpEnemies.add(e);
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed([ESCAPE]))
		{
			System.exit(0);
		}
		if (started && !gameOver)
		{
			gameTimer -= elapsed;
			
			gameTimeText.text = Std.int(gameTimer / 60) + ":" + StringTools.lpad(Std.string(Std.int(gameTimer % 60)), "0", 2);
			gameTimeText.screenCenter(FlxAxes.X);
			{			
			if (gameTimer <= 10)

				if (gameTimeText.changeRate == 0)
				{
					gameTimeText.changeRate = 100;
					
				}
				
			}
			
			if (gameTimer <= 0)
			{
				//GAME OVER!.
				gameOver = true;
				gameTimeText.text = "0:00";
				
				startBack = new FlxSprite();
				startBack.makeGraphic(FlxG.width, Std.int(FlxG.height * .25), FlxColor.BLACK);
				startBack.screenCenter();
				startBack.alpha = 0;
				add(startBack);
				
				var s:String = "";
				
				if (scores[0] == scores[1])
				{
					s = "It's a Tie!";
				}
				else if (scores[0] > scores[1])
				{
					s = "Player One Wins!";
				}
				else
				{
					s = "Player Two Wins!";
				}
				
				startMessage = new GameText(s, GameText.COLOR_BIG);
				startMessage.alignment = FlxTextAlign.CENTER;
				startMessage.screenCenter();
				startMessage.alpha = 0;
				startMessage.changeRate = 100;
				startMessage.colors = [0xffac3232, 0xffdf7126, 0xfffbf236, 0xff99e550, 0xff5fcde4, 0xff76428a, 0xffd77bba];
				add(startMessage);
				
				FlxG.sound.music.fadeOut(.25);
				
				FlxTween.tween(startBack, {alpha:1}, .15, {type:FlxTweenType.ONESHOT, ease:FlxEase.circIn, startDelay:.2, onComplete:function(_) {
					FlxTween.tween(startMessage, {alpha:1}, .15, {type:FlxTweenType.ONESHOT, ease:FlxEase.backOut, startDelay:.1,  onComplete:function(_){
						var t:FlxTimer = new FlxTimer().start(2, function(_){
							
							// check and prompt for hiscore here!!!!
							
							
							
							if (Saves.checkScore(scores[0]) || Saves.checkScore(scores[1]))
							{	
								openSubState(new AddScore(scores));
							}
							else
								openSubState(new Leaderboard());
						});
					}});
					
				}});
			}
			
			if (!pickaxe.alive)
			{
				if (FlxG.random.bool(.15))
				{
					var rX:Int = FlxG.random.int(0, Std.int( map.width - 1));
					var rY:Int = FlxG.random.int(6, Std.int(map.height - 1));
					axeTimer = 15;
					pickaxe.reset((rX * TILESIZE)+ map.map.x , (rY * TILESIZE) + map.map.y);
				}
			}
			else 
			{
				axeTimer -= elapsed;
				if (axeTimer <= 0)
					pickaxe.kill();
			}
		}
		
		
		
		updateScores();
		super.update(elapsed);
	}
	
	private function updateScores():Void
	{
		if (Std.parseInt(poneScoreText.text) < scores[0])
		{
			poneScoreText.text = StringTools.lpad( Std.string(Std.parseInt(poneScoreText.text) + 1), "0", 6);
		}
		if (Std.parseInt(ptwoScoreText.text) < scores[1])
		{
			ptwoScoreText.text = StringTools.lpad( Std.string(Std.parseInt(ptwoScoreText.text) + 1), "0", 6);
		}
	}
	
	public function checkOverlap(P:Player):Void
	{
		FlxG.overlap(P, grpBones, playerTouchBone, checkPlayerTouchBone);
		FlxG.overlap(P, pickaxe, playerTouchPickaxe, checkPlayerTouchPickaxe);
		FlxG.overlap(P, grpEnemies, playerTouchEnemy, checkPlayerTouchEnemy);
		
	}
	
	private function playerTouchEnemy(P:Player, E:Enemy):Void
	{
		P.stun();
	}
	
	private function checkPlayerTouchEnemy(P:Player, E:Enemy):Bool
	{
		return (P.alive && P.exists && E.alive && E.exists && !P.isSuper && !P.isStunned);
	}
	
	private function checkPlayerTouchPickaxe(P:Player, A:CyclingSprite):Bool
	{
		return (P.alive && P.exists && A.alive && A.exists && !P.isStunned);
	}
	
	private function playerTouchPickaxe(P:Player, A:CyclingSprite):Void
	{
		P.startSuper();
		A.exists = false;
	}
	
	private function checkPlayerTouchBone(P:Player, B:Bone):Bool
	{
		return (P.alive && P.exists && B.alive && B.exists && !P.isStunned);
	}
	
	private function playerTouchBone(P:Player, B:Bone):Void
	{
		spawnPoints(Std.int(B.x + 8), Std.int(B.y + 8));
		B.kill();
		scores[P.playerNo - 1] += 100;
		FlxG.sound.play(FlxG.random.bool() ? AssetPaths.baDerng__wav : AssetPaths.baDing__wav, .5);
	}

	public function checkAhead(X:Int, Y:Int, DirX:Int, DirY:Int):CheckTileType
	{
		if (X + DirX < 0 || X+DirX >= map.width)
			return BLOCK;
		else if (Y + DirY < 5 || Y + DirY >= map.height)
			return BLOCK;

		if (map.map.getTile(X + DirX, Y + DirY) < 13)
			return SOLID;
		else
			return EMPTY;

	}
}

@:enum
abstract CheckTileType(Int)
{
	var BLOCK        = 0;
	var SOLID      = 1;
	var EMPTY       = 2;
}
