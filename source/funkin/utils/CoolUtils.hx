package funkin.utils;

import flixel.system.FlxAssets.FlxXmlAsset;
import haxe.xml.Access;

using StringTools;

final class CoolUtils 
{
    public static final lowerCases:String = "abcdefghijklmnopqrstuvwxyz";
    public static final upperCases:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	public static final numbers:String = "1234567890";
	public static final symbols:String = "|~#$%()*+-:;<=>@[]^_.,'!?×←↓↑→☺☹😠😡♥♡❤";

    public static final characters:String = lowerCases + upperCases + numbers + symbols;

    private static final cachedXML:Map<FlxXmlAsset, Access> = [];

    public static function existsAnimation(xml:FlxXmlAsset, animation:String):Bool
    {
		if (xml == null || xml == "") return false;

		var data:Access;
        if (cachedXML.exists(xml)) 
        {
            data = cachedXML.get(xml);
        }
        else 
        {
            data = new Access(xml.getXml().firstElement());
            cachedXML.set(xml, data);
        }

		for (texture in data.nodes.SubTexture)
		{
			if (!texture.has.width && texture.has.w)
				throw "Sparrow v1 is not supported, use Sparrow v2";
			
			var name = texture.att.name;
            if (name.startsWith(animation + "0")) return true;
		}

        return false;
    }
}