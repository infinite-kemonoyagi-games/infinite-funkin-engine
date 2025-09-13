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

    private var originalFont:String = "";
    private var isTemplate:Bool = false;
    private var forceLowerCase:Bool = false;

    public var fileUrl:String;

    public var originalPoints:Array<String> = null;
    public var referencePoints:Array<String> = null;

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
        this.font = Font;
        this.size = Size;
        this.row = Row;
        if (LastCharacter != null) this.lastCharacter = LastCharacter;
        this.directory = Directory;

        fileUrl = FunkinPaths.images(directory + font);
        final originalUrl = FunkinPaths.images(directory + originalFont);

        if (originalFont != null && originalFont != "") 
            originalPoints = load.file(originalUrl + '-reference.txt').split(" ");
        referencePoints = load.file(fileUrl + '-reference.txt').split(" ");

        return this;
    }

    public function loadFont(?Font:String = null):Void
    {
        if (Font != null) this.font = Font;

        loadSparrow(fileUrl, true);

        function addAnimByChar(character:String):Void
        {
            final realCharacter:String = character;
            character = animCharName(character);
            animation.addByPrefix(realCharacter, character, 24, true);
        }
        function detectCharacter(character:String) 
        {
            if (CoolUtils.existsAnimation(fileUrl + ".xml", FunkinTextChar.animCharName(character)))
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
                animation.addByPrefix(character, '-question mark-', 24, true); // ?
            }
        }

        for (character in CoolUtils.characters.split("")) 
        {
            detectCharacter(character);
        }
    }

    public function loadSimple(?Font:String = null):Void
    {
        if (Font != null) this.font = Font;
        loadSparrow(fileUrl, true);
    }

    public function refreshChar(?noExists:() -> Void):Void
    {
        if (!animation.exists(character) && noExists != null) 
        {
            noExists();
            return;
        }

        animation.play(character);
        scale.set(size, size);
        updateHitbox();

        if (referencePoints != null)
        {
            if (originalPoints != null)
            {
                // final oW:Float = Std.parseFloat(originalPoints[0]) * size;
                final oH:Float = Std.parseFloat(originalPoints[1]) * size;
                // final rW:Float = Std.parseFloat(referencePoints[0]) * size;
                final rH:Float = Std.parseFloat(referencePoints[1]) * size;
                // var centerX:Float = 0;
                var centerY:Float = 0;

                switch character 
                {
                    case "_" | "." | ",":
                        /*if (character != "." || character != ",") 
                            centerX = width - (rW - oW);*/

                        centerY = height - (rH - oH);
                    case "\'" | "\"":
                        // do nothing
                    default:
                        // centerX = (width - ((rW - oW))) / 2;
                        centerY = (height - ((rH - oH))) / 2;
                }

                // offset.x += centerX;
                offset.y += centerY;
            }
            else
            {
                // final rW:Float = Std.parseFloat(referencePoints[0]) * size;
                final rH:Float = Std.parseFloat(referencePoints[1]) * size;
                // var centerX:Float = 0;
                var centerY:Float = 0;

                switch character 
                {
                    case "_" | "." | ",":
                        /*if (character != "." || character != ",") 
                            centerX = width - rW;*/

                        centerY = height - rH;
                    case "\'" | "\"":
                        // do nothing
                    default:
                        // centerX = (width - rW) / 2;
                        centerY = (height - rH) / 2;
                }

                // offset.x += centerX;
                offset.y += centerY;
            }
        }
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

    public static function copyFrom(character:FunkinTextChar):FunkinTextChar
    {
        final text:FunkinTextChar = new FunkinTextChar(character.character, character.font, character.size, 
            character.row, character.lastCharacter);
        
        text.font = character.font;
        text.frames = character.frames;
        text.animation.copyFrom(character.animation);
        text.scale.set(character.size, character.size);

        return text;
    }
}
