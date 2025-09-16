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

import flixel.util.FlxPool;
import flixel.math.FlxPoint;
import funkin.backend.visual.FunkinSprite;
import funkin.assets.FunkinPaths;
import funkin.utils.CoolUtils;

class FunkinTextChar extends FunkinSprite 
{
    public static inline final DEFAULT_CHAR:String = "A";
    public static inline final DEFAULT_PATH:String = "fonts/";

    public var parent:FunkinText = null;

    public var character:String;
    public var font:String;
    public var size:FlxPoint;
    public var row:Int;
    public var directory:String = DEFAULT_PATH;
    public var lastCharacter(default, null):Null<FunkinTextChar> = null;
    public var lastSpaces:Float = 0.0;
    public var lastRows:Float = 0.0;

    private var originalFont:String = "";
    private var isTemplate:Bool = false;
    private var forceLowerCase:Bool = false;

    public var fileUrl:String;

    public var originalPoints:Array<String> = null;
    public var referencePoints:Array<String> = null;

    public var position:FlxPoint = null;
    public var globalPosition(default, null):FlxPoint = null;
    public var charOffset(default, null):FlxPoint = null;

    private var _skipUpdatePosition:Bool = false;

    public function new() 
    {
        super();
    }

    public function setData(Character:String, Font:String, Width:Float = 1.0, Height:Float = 1.0, ?Row:Int = 0, ?LastCharacter:FunkinTextChar,
        ?Directory:String = FunkinTextChar.DEFAULT_PATH):FunkinTextChar 
    {
        _skipUpdatePosition = true;

        this.character = Character;
        this.font = Font;
        this.size = new FlxCallbackPoint(_ -> updatePosition());
        this.size.set(Width, Height);
        this.row = Row;
        if (LastCharacter != null) this.lastCharacter = LastCharacter;
        this.directory = Directory;
        this.position = new FlxCallbackPoint(_ -> updatePosition());
        this.globalPosition = new FlxPoint();
        this.charOffset = new FlxPoint();

        fileUrl = FunkinPaths.images(directory + font);
        final originalUrl = FunkinPaths.images(directory + originalFont);

        if (originalFont != null && originalFont != "") 
            originalPoints = load.file(originalUrl + '-reference.txt').split(" ");
        referencePoints = load.file(fileUrl + '-reference.txt').split(" ");

        _skipUpdatePosition = false;

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
        scale.set(size.x, size.y);
        updateHitbox();

        function setOffset(isNotOriginal:Bool = false):Void
        {
            var oH:Float = 0.0;
            if (isNotOriginal)
            {
                oH = Std.parseFloat(originalPoints[1]) * size.y;
            }
            final rH:Float = Std.parseFloat(referencePoints[1]) * size.y;
            final centerY:Float = switch character 
            {
                case "_" | "." | ",": height - (rH - oH);
                case "\'" | "\"": 0;
                default: (height - (rH - oH)) / 2;
            };

            charOffset.y += centerY;
        }
        if (referencePoints != null)
        {
            setOffset(originalPoints != null);
        }
    }

    private function setFontOrigin(x:Float, y:Float):Void
    {
        position.set(x, y);
    }

    private function setFontSize(x:Float, y:Float):Void
    {
        size.set(x, y);
    }

    @:allow(funkin.visuals.text.FunkinText)
    private function updatePosition():Void
    {
        if (_skipUpdatePosition || parent == null)
        {
            return;
        }
        final template:FunkinTextChar = FunkinText.templates.get(font);

        var posX:Float = 0.0;
        if (lastCharacter != null)
        {
            posX = lastCharacter.globalPosition.x + lastCharacter.width;
        }
        posX += (40 * lastSpaces) * size.x;
        posX *= parent.spaceLength;
        var posY:Float = 0.0;
        if (lastRows > 0)
        {
            if (lastCharacter != null && template != null)
            {
                posY = lastCharacter.globalPosition.y + template.height;
            }
            posY += (35 * lastRows) * size.y;
            posY *= parent.rowSize;
        }
        globalPosition.set(posX, posY);

        final relX = (position.x + posX) * parent.scale.x;
        final relY = (position.y + posY) * parent.scale.y;
        final cX = (parent.width  * parent.scale.x) / 2;
        final cY = (parent.height * parent.scale.y) / 2;
        // final cx = parent.origin.x;
        // final cy = parent.origin.y;
        final r = parent.angle * Math.PI / 180;
        final dX = relX - cX;
        final dY = relY - cY;
        final aX = cX + dX * Math.cos(r) - dY * Math.sin(r);
        final aY = cY + dX * Math.sin(r) + dY * Math.cos(r);
        final oX = charOffset.x * parent.scale.x;
        final oY = charOffset.y * parent.scale.y;

        scale.set(size.x * parent.scale.x, size.y * parent.scale.y);
        updateOnlyHitbox();
        angle = parent.individualAngle + parent.angle;
        x = parent.x + aX - oX;
        y = parent.y + aY - oY;
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

    public static function cloneFrom(character:FunkinTextChar):FunkinTextChar
    {
        final text:FunkinTextChar = new FunkinTextChar();
        text.copyFrom(character);
        return text;
    }

    public function copyFrom(character:FunkinTextChar):FunkinTextChar
    {
        setData(character.character, character.font, character.size.x, character.size.y, 
            character.row, character.lastCharacter);
        frames = character.frames;
        _skipUpdatePosition = true;
        position.copyFrom(character.position);
        animation.copyFrom(character.animation);
        scale.copyFrom(character.size);
        _skipUpdatePosition = false;
        return this;
    }
}
