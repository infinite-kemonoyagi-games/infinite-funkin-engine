/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2025 Infinite KemonoYagi
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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