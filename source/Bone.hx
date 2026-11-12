package;

import axollib.GraphicsCache;
import flixel.FlxSprite;

class Bone extends FlxSprite
{

	public function new()
	{
		super();
		#if desktop
		frames = GraphicsCache.loadAtlasFrames(AssetPaths.bones__png, AssetPaths.bones__xml, false, "bones");
		#else
		frames = GraphicsCache.loadAtlasFrames("bones", AssetPaths.bones__png, AssetPaths.bones__xml);
		#end
		animation.randomFrame();
	}

}