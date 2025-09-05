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
import funkin.backend.group.FunkinSpriteGroup.FunkinTypedSpriteGroup;

@:access(funkin.visuals.text.FunkinTextChar)
class FunkinText extends FunkinTypedSpriteGroup<FunkinTextChar> 
{
    public static var templates:Map<String, FunkinTextChar> = [];

    public var text(default, set):String;
    public var font(default, set):String;
    public var size:Float = 1.0;
    public var align:FunkinTextAlign = LEFT;

    public var spaceLength:Float = 1.0;
    public var rowSize:Float = 1.0;

    public function new(Text:String, Size:Float = 1.0, Font:String = "default") 
    {
        super();

        size = Size;
        font = Font;
        text = Text;

        FlxPool;
    }

    public function setAdvancedText(Text:String, SpaceLength:Float = 1.0, RowSize:Float = 1.0):Void 
    {
        setAdvancedData(SpaceLength, RowSize);
        text = Text;
    }

    public function setAdvancedData(SpaceLength:Float = 1.0, RowSize:Float = 1.0):Void 
    {
        spaceLength = SpaceLength;
        rowSize = RowSize;
    }

    private function generateText(text:String, font:String):Void 
    {
        final textSplitted:Array<String> = text.split("\n");

        var lastCharacter:FunkinTextChar = null;

        var posY:Float = 0.0;
        
        for (rowIndex => rowValue in textSplitted) 
        {
            final characters:Array<String> = rowValue.split("");
            var spaces:Int = 0;
            var rowWidth:Float = 0.0;

            for (character in characters) 
            {
                if (character == " ") 
                {
                    ++spaces;
                }
                else
                {
                    final tempalte:FunkinTextChar = templates.get(font);
                    rowWidth += (tempalte.width + (40 * spaces)) * size;
                    spaces = 0;
                }
            }

            final offsetX:Float = switch align
            {
                case CENTER: -rowWidth / 2;
                case RIGHT: -rowWidth;
                default: 0;
            };
            var posX:Float = offsetX;

            spaces = 0;

            for (index => character in characters)
            {
                if (character == " ") 
                {
                    ++spaces;
                    continue;
                }
                else
                {
                    if (lastCharacter != null) posX = lastCharacter.x + (templates.get(font).width * size);

                    posX += (40 * spaces) * size;
                    posX *= spaceLength;
                    spaces = 0;
                }

                var sprite:FunkinTextChar = null;
                function createCharacter(daFont:String):Void
                {
                    sprite = FunkinTextChar.copyFrom(templates.get(daFont));
                    sprite.setData(character, daFont, size, rowIndex, lastCharacter);
                    sprite.ID = index;
                }

                createCharacter(font);
                sprite.refreshChar(() -> 
                {
                    if (sprite.font == "default") return;

                    createCharacter("default");

                    sprite.originalFont = font;
                    sprite.refreshChar();
                });
                
                sprite.x = switch align
                {
                    case RIGHT: sprite.x - posX;
                    default: sprite.x + posX;
                };
                sprite.y += posY;

                add(sprite);
                lastCharacter = sprite;
            }

            final template:FunkinTextChar = templates.get(font);
            posY += ((template.height * size) + template.y + 35) * rowSize;

            lastCharacter = null;
        }
    }

    private function refreshText(text:String, font:String):Void 
    {
        while (members.length > 0)
        {
            final member = members.shift();
            member.kill();
            member.destroy();
        }

        if (text == null || text == "") return;

        final lastPosition:FlxPoint = new FlxPoint(x, y);
        setPosition(0, 0);

        generateText(text, font);

        setPosition(lastPosition.x, lastPosition.y);
    }

    private function set_text(newText:String) 
    {
        if (this.text == newText) return this.text;

        refreshText(newText, this.font);
        return this.text = newText;
    }

    private function set_font(newFont:String) 
    {
        if (!templates.exists(newFont)) loadFont(newFont);

        refreshText(this.text, newFont);
        return this.font = newFont;
    }

    public static function loadFont(font:String):Void 
    {
        if (templates.exists(font)) return;

        final character:FunkinTextChar = new FunkinTextChar(FunkinTextChar.DEFAULT_CHAR, font, 1.0);
        character.isTemplate = true;
        character.loadFont();
        templates.set(font, character);
    }

    @:allow(Main)
    private inline static function loadDefaultFont():Void 
    {
        loadFont("default");
    }
}
