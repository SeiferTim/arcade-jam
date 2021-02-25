package;

import flixel.FlxG;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.util.FlxColor;

class GameText extends FlxBitmapText 
{

	
	public var colors:Array<FlxColor>;
	public var changeRate:Float=0;
	private var currentIndex:Int = 0;
	//private var baseImage:BitmapData;
	
	public static inline var COLOR_WHITE:Int = 0;
	public static inline var COLOR_BLUE:Int = 1;
	public static inline var COLOR_RED:Int = 2;
	public static inline var COLOR_BIG:Int = 3;
	
	public function new(Text:String, ?Color:Int = COLOR_WHITE) 
	{
		super(FlxBitmapFont.fromAngelCode(switch(Color){
			case COLOR_WHITE:
				AssetPaths.white_text__png;
			case COLOR_BLUE:
				AssetPaths.blue_text__png;
			case COLOR_RED:
				AssetPaths.pink_text__png;
			case COLOR_BIG:
				AssetPaths.big_font__png;
			default:
				null;
		}, switch(Color) {
			case COLOR_WHITE:
				AssetPaths.white_text__xml;
			case COLOR_BLUE:
				AssetPaths.blue_text__xml;
			case COLOR_RED:
				AssetPaths.pink_text__xml;
			case COLOR_BIG:
				AssetPaths.big_font__xml;
			default:
				null;
		}));
		text = Text;
		
	}
	
	
	
	
	
	override public function draw():Void 
	{
	
		
		if (colors != null)
		{
			if (colors.length > 0 && changeRate > 0 )
			{
				
				var newIndex:Int = Std.int((FlxG.game.ticks / changeRate) % colors.length);
				if (currentIndex != newIndex)
				{
					currentIndex = newIndex;
					color = colors[currentIndex];
					
				}
			}
		}
		
		
		super.draw();
	}
	
}