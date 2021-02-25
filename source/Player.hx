package;

import axollib.CyclingSprite;
import axollib.GraphicsCache;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Player extends CyclingSprite 
{

	public static inline var DUP:Int = 0;
	public static inline var DRIGHT:Int = 1;
	public static inline var DDOWN:Int = 2;
	public static inline var DLEFT:Int = 3;
	
	public var moving:Bool = false;
	public var dir:Int;
	
	public var inputs:Array<FlxKey> = [];
	
	public var parent:PlayState;
	public var playerNo:Int = 0;
	
	public static inline var CLEAR_SPEED:Float = .25;
	public static inline var DIG_SPEED:Float = .4;
	
	public var isSuper:Bool = false;
	private var wasOnSuper:Bool = false;
	
	private var superTime:Float = 0;
	
	public var isStunned:Bool = false;
	public var stunTime:Float = 0;
	
	public function new(Parent:PlayState, PlayerNo:Int=1) 
	{
		super(0,0,null,PlayerNo == 1 ? [0xffdf7126, 0xff306082] : [0xffac3232, 0xfffbf236], 0);
		playerNo = PlayerNo;
		parent = Parent;
		if (PlayerNo == 1)
		{
			inputs = [UP, RIGHT, DOWN, LEFT];
			frames  = GraphicsCache.loadAtlasFrames("player-two" , AssetPaths.player_two__png, AssetPaths.player_two__xml);
			
			
		}
		else if (PlayerNo == 2)
		{
			inputs = [W, D, S, A];
			
			frames  = GraphicsCache.loadAtlasFrames("player-one" , AssetPaths.player_one__png, AssetPaths.player_one__xml);
		}
		
		
		
		animation.addByIndices("down", "player_" + (playerNo == 1 ? "two" : "one") + "_down_", [0, 1], ".png", 8, false);
		animation.addByIndices("right", "player_" + (playerNo == 1 ? "two" : "one") + "_right_", [1,0], ".png", 8, false);
		animation.addByIndices("left", "player_" + (playerNo == 1 ? "two" : "one") + "_right_", [1,0], ".png", 8, false, true);
		animation.addByIndices("up", "player_" + (playerNo == 1 ? "two" : "one") + "_up_", [0, 1], ".png", 8, false);
		
		animation.play("down", true);
		
		baseImage = pixels.clone();
		
	}
	
	
	public function startSuper():Void
	{
		isSuper = true;
		superTime = 5;
		changeRate = 60;
		FlxG.sound.playMusic(AssetPaths.Pickaxe__wav);
		FlxG.camera.flash(FlxColor.YELLOW, .2);
	}
	
	public function stun():Void
	{
		isStunned = true;
		stunTime = 2;
		angularVelocity = 1440;
		FlxG.sound.play(AssetPaths.bat__wav, .5);
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		
		super.update(elapsed);
		if (!parent.started || parent.gameOver)
			return;
			
		if (isStunned)
		{
			stunTime-= elapsed;
			if (stunTime <= 0)
			{
				angularVelocity = 0;
				angle = 0;
				isStunned = false;
			}
			else
				return;
		}
		
		if (isSuper)
		{
			superTime-= elapsed;
			if (superTime <= 0)
			{
				isSuper = false;
				changeRate = 0;
				parent.pickaxe.kill();
				FlxG.sound.playMusic(AssetPaths.Uwaa___wav);
				
			}
		}
		if (!moving)
		{
			if (FlxG.keys.anyPressed([inputs[DDOWN]]))
			{
				var checkTile:PlayState.CheckTileType = parent.checkAhead(Std.int((x-parent.map.map.x)/PlayState.TILESIZE), Std.int((y-parent.map.map.y)/PlayState.TILESIZE), 0, 1);
				if (checkTile != BLOCK)
				{
					moving = true;
					dir = DDOWN;
					FlxTween.tween(this, {y:y + PlayState.TILESIZE},  getSpeed(checkTile), {type:FlxTweenType.ONESHOT, ease:FlxEase.sineInOut, onComplete: finishMove});
				}
			}
			else if (FlxG.keys.anyPressed([inputs[DUP]]))
			{
				var checkTile:PlayState.CheckTileType = parent.checkAhead(Std.int((x-parent.map.map.x)/PlayState.TILESIZE), Std.int((y-parent.map.map.y)/PlayState.TILESIZE), 0, -1);
				if (checkTile != BLOCK)
				{
					moving = true;
					dir = DUP;
					FlxTween.tween(this, {y:y - PlayState.TILESIZE},  getSpeed(checkTile) , {type:FlxTweenType.ONESHOT, ease:FlxEase.sineInOut, onComplete: finishMove});
				}
			}
			else if (FlxG.keys.anyPressed([inputs[DLEFT]]))
			{
				var checkTile:PlayState.CheckTileType = parent.checkAhead(Std.int((x-parent.map.map.x)/PlayState.TILESIZE), Std.int((y-parent.map.map.y)/PlayState.TILESIZE), -1, 0);
				if (checkTile != BLOCK)
				{
					moving = true;
					dir = DLEFT;
					FlxTween.tween(this, {x:x - PlayState.TILESIZE},  getSpeed(checkTile), {type:FlxTweenType.ONESHOT, ease:FlxEase.sineInOut, onComplete: finishMove});
				}
			}
			else if (FlxG.keys.anyPressed([inputs[DRIGHT]]))
			{
				var checkTile:PlayState.CheckTileType = parent.checkAhead(Std.int((x-parent.map.map.x)/PlayState.TILESIZE), Std.int((y-parent.map.map.y)/PlayState.TILESIZE), 1, 0);
				if (checkTile != BLOCK)
				{
					moving = true;
					dir = DRIGHT;
					FlxTween.tween(this, {x:x + PlayState.TILESIZE}, getSpeed(checkTile) , {type:FlxTweenType.ONESHOT, ease:FlxEase.sineInOut, onComplete: finishMove});
				}
			}
		}
		if (moving)
		{
			if (animation.finished)
				animation.play(switch(dir){
					case DUP:
						"up";
					case DDOWN:
						"down";
					case DLEFT:
						"left";
					case DRIGHT:
						"right";
					default:
						"";
				}, true);
		}
		
	}
	
	private function getSpeed(Check:PlayState.CheckTileType):Float
	{
		if (Check == EMPTY || isSuper)
			return CLEAR_SPEED;
		return DIG_SPEED + (.05 * (((y - parent.map.map.y) / PlayState.TILESIZE) - 5));
	}
	
	private function finishMove(_):Void
	{
		moving = false;
		parent.checkOverlap(this);
		var tID:Int = parent.map.map.getTile(Std.int((x-parent.map.map.x) /PlayState.TILESIZE), Std.int((y-parent.map.map.y) /PlayState.TILESIZE));
		if (tID < 13)
		{
			if (!isSuper)
				FlxG.sound.play(FlxG.random.bool() ? AssetPaths.digSound01__wav : AssetPaths.digSound02__wav, .5);
			parent.map.map.setTile(Std.int((x-parent.map.map.x) / PlayState.TILESIZE), Std.int((y-parent.map.map.y) / PlayState.TILESIZE), tID+12, true);
		}
		
	}
	
	
}