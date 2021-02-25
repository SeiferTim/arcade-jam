package;
import flixel.util.FlxSave;

class Saves 
{

	public static var save:FlxSave;
	
	public static var hiscores:Array<String>;
	
	public static function init():Void
	{
		save = new FlxSave();
		save.bind("axol-fossil-finders-hiscores");
		hiscores = [];
		if (save.data.hiscores != null)
			hiscores = cast save.data.hiscores.copy();
		else
		{
			hiscores = [
				"NAH:5000",
				"TIH:4000",
				"ABC:2500",
				"DEF:2000",
				"GHI:1500",
				"JKL:1000",
				"MNO:500",
				"PQR:400",
				"STU:300",
				"VWX:200"
			];
		}
		
	}
	
	public static function sort():Void
	{
		hiscores.sort(sortScores);
	}
	
	public static function checkScore(Value:Int):Bool
	{
		sort();
		var split:Array<String> = hiscores[hiscores.length - 1].split(":");
		return Value > Std.parseInt(split[1]);
			
	}
	
	private static function sortScores(A:String, B:String):Int
	{
		var splitA:Array<String> = A.split(":");
		var splitB:Array<String> = B.split(":");
		if (Std.parseInt(splitA[1]) > Std.parseInt(splitB[1]))
			return -1;
		else if (Std.parseInt(splitA[1]) < Std.parseInt(splitB[1]))
			return 1;
		return 0;
	}
	
	public static function addScore(Score:Int, Name:String):Void
	{
		sort();
		hiscores.pop();
		hiscores.push(Name + ":" + Std.string(Score));
		saveScores();
	}
	
	
	public static function saveScores():Void
	{
		save.data.hiscores = hiscores.copy();
		save.flush();
	}
	
}