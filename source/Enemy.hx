package;

import axollib.CyclingSprite;
import axollib.GraphicsCache;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;

class Enemy extends CyclingSprite 
{

	private var moveTimer:Float;
	private var parent:PlayState;
	private var moving:Bool;
	
	public function new(Parent:PlayState) 
	{
		super(0, 0, null, [0xffac3232, 0xffdf7126, 0xfffbf236, 0xffd77bba], 60);
		parent = Parent;
		frames  = GraphicsCache.loadAtlasFrames("bat" , AssetPaths.bat__png, AssetPaths.bat__xml);
		animation.addByIndices("bat", "bat_", [0, 1], ".png", 8);
		animation.play("bat");
		baseImage = pixels.clone();
		finishMove(null);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (!parent.started || parent.gameOver || moving)
			return;
		
		moveTimer -= elapsed;
		if (moveTimer <= 0)
		{
			// move in a random direction - if it's not blocked...
			
			var dir:Array<Int> = [];
			if (parent.checkAhead(Std.int((x - parent.map.map.x) / PlayState.TILESIZE), Std.int((y - parent.map.map.y) / PlayState.TILESIZE), 0, 1) == EMPTY)
			{
				dir.push(FlxObject.DOWN);
			}
			
			if (parent.checkAhead(Std.int((x - parent.map.map.x) / PlayState.TILESIZE), Std.int((y - parent.map.map.y) / PlayState.TILESIZE), 0, -1) == EMPTY)
			{
				dir.push(FlxObject.UP);
			}
			
			if (parent.checkAhead(Std.int((x - parent.map.map.x) / PlayState.TILESIZE), Std.int((y - parent.map.map.y) / PlayState.TILESIZE), 1, 0 ) == EMPTY)
			{
				dir.push(FlxObject.RIGHT);
			}
			
			if (parent.checkAhead(Std.int((x - parent.map.map.x) / PlayState.TILESIZE), Std.int((y - parent.map.map.y) / PlayState.TILESIZE), -1, 0 ) == EMPTY)
			{
				dir.push(FlxObject.LEFT);
			}
			
			if (dir.length > 0)
			{
				moving = true;
				FlxG.random.shuffle(dir);
				switch(dir[0])
				{
					case FlxObject.UP:
						FlxTween.tween(this, {y:y - PlayState.TILESIZE},  .33, {type:FlxTweenType.ONESHOT, ease:FlxEase.sineInOut, onComplete: finishMove});
					case FlxObject.DOWN:
						FlxTween.tween(this, {y:y + PlayState.TILESIZE},  .33, {type:FlxTweenType.ONESHOT, ease:FlxEase.sineInOut, onComplete: finishMove});
					case FlxObject.LEFT:
						FlxTween.tween(this, {x:x- PlayState.TILESIZE},  .33, {type:FlxTweenType.ONESHOT, ease:FlxEase.sineInOut, onComplete: finishMove});
					case FlxObject.RIGHT:
						FlxTween.tween(this, {x:x + PlayState.TILESIZE},  .33, {type:FlxTweenType.ONESHOT, ease:FlxEase.sineInOut, onComplete: finishMove});
					default:
						finishMove(null);
				}
				
				
			}
			else
			{
				finishMove(null);
			}
			
		}
		
		
	}

	
	private function finishMove(_):Void
	{
		moving = false;
		moveTimer = FlxG.random.int(5, 25) * .15;
	}
}