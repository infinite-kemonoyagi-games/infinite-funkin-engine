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

package funkin.visuals.text;

import funkin.backend.visual.FunkinSprite;
import funkin.assets.FunkinPaths;
import funkin.utils.CoolUtils;

class FunkinTextChar extends FunkinSprite 
{
    public static inline final DEFAULT_CHAR:String = "A";
    public static inline final DEFAULT_PATH:String = "fonts/";

    public var character:String;
    public var font:String;
    public var size:Float;
    public var row:Int;
    public var directory:String = DEFAULT_PATH;
    public var lastCharacter:Null<FunkinTextChar> = null;

    @:allow(funkin.visuals.FunkinText)
    private var originalFont:String = "";

    private var isTemplate:Bool = false;
    private var forceLowerCase:Bool = false;

    public var fileUrl:String;

    public function new(Character:String, Font:String, Size:Float, ?Row:Int = 0, ?LastCharacter:FunkinTextChar,
        ?Directory:String = FunkinTextChar.DEFAULT_PATH) 
    {
        super();
        setData(Character, Font, Size, Row, LastCharacter, Directory);
    }

    public function setData(Character:String, Font:String, Size:Float, ?Row:Int = 0, ?LastCharacter:FunkinTextChar,
        ?Directory:String = FunkinTextChar.DEFAULT_PATH):FunkinTextChar 
    {
        this.character = Character;
        this.size = Size;
        this.row = Row;
        if (LastCharacter != null) this.lastCharacter = LastCharacter;
        this.directory = Directory;

        return this;
    }

    public function loadFont(Font:String):Void
    {
        this.font = Font;

        fileUrl = FunkinPaths.images(directory + "/" + font);
        frames = Main.current.assets.load.sparrowAtlas(fileUrl, true);

        function addAnimByChar(character:String):Void
        {
            final realCharacter:String = character;
            character = animCharName(character);
            animation.addByPrefix(realCharacter, character, 24, true);
        }
        function detectCharacter(character:String) 
        {
            if (CoolUtils.existsAnimation(fileUrl, animCharName(character)))
            {
                addAnimByChar(character);
            }
            else if (CoolUtils.lowerCases.contains(character))
            {
                animation.addByPrefix(character, character.toUpperCase(), 24, true);
                forceLowerCase = true;
            }
            else if (CoolUtils.upperCases.contains(character))
            {
                animation.addByPrefix(character, character.toLowerCase(), 24, true);
            }
            else if (font == "default")
            {
                animation.addByPrefix(character, '-question mark-', 24, true);
            }
        }

        for (character in CoolUtils.characters.split("")) 
        {
            detectCharacter(character);
        }

        if (character != "") refreshChar();
    }

    public function refreshChar(?noExists:() -> Void):Void
    {
        if (!animation.exists(character) && noExists != null) 
        {
            noExists();
            return;
        }

        animation.play(character);
		updateHitbox();
        scale.set(size, size);
        updateHitbox();
    }

    public static function animCharName(?char:String):String
    {
        return switch char
        {
            case "-": "-dash-";
            case "\'": "-apostraphie-";
            case "\"": "-apostraphie-";
            case "\\": "-black slash-";
            case ",": "-comma-";
            case "!": "-explamation point-";
            case "/": "-forward slash-";
            case ".": "-period-";
            case "?": "-question mark-";
            case "_": "-start quote-";

            case "×": "-multiply x-";
            case "←": "-left arrow-";
            case "↓": "-down arrow-";
            case "↑": "-up arrow-";
            case "→": "-right arrow-";
            case "☺" | "☹" | "😠" | "😡": "-angry faic-";
            case "♥" | "♡" | "❤": "-heart-";

            default: char;
        };
    }
}