package;

import axollib.GraphicsCache;
import flixel.FlxSprite;

class Bone extends FlxSprite
{

	public function new()
	{
		super();

		frames = GraphicsCache.loadAtlasFrames("bones", AssetPaths.bones__png, AssetPaths.bones__xml);
		animation.randomFrame();
	}

}