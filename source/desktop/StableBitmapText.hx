#if desktop
package desktop;

import flixel.text.FlxBitmapText;

/**
 * Workaround for re-entrant first-layout in HaxeFlixel 6.2.1:
 * computeTextSize reads textHeight/textWidth, whose getters call
 * checkPendingChanges before the outer update has allocated textBitmap.
 * Keep nested measurement reads from starting a second render pass.
 */
class StableBitmapText extends FlxBitmapText
{
    var updatingText:Bool = false;

    override function checkPendingChanges(useTiles:Bool = false):Void
    {
        if (updatingText)
            return;
        updatingText = true;
        try
        {
            super.checkPendingChanges(useTiles);
        }
        catch (error:Dynamic)
        {
            updatingText = false;
            throw error;
        }
        updatingText = false;
    }
}

#end
