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

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPool;
import flixel.math.FlxPoint;
import funkin.backend.group.FunkinSpriteGroup.FunkinTypedSpriteGroup;

@:access(funkin.visuals.text.FunkinTextChar)
class FunkinText extends FunkinTypedSpriteGroup<FunkinTextChar> 
{
    public static var templates:Map<String, FunkinTextChar> = [];
    public static var pool(default, null):FlxPool<FunkinTextChar> = new FlxPool<FunkinTextChar>(function()
    {
        return new FunkinTextChar();
    });

    public var rows:Array<FunkinTypedSpriteGroup<FunkinTextChar>> = null;

    public var text(default, set):String;
    public var font(default, set):String;
    public var size:FlxPoint = null;
    public var align:FunkinTextAlign = LEFT;

    public var spaceLength(default, set):Float = 1.0;
    public var rowSize(default, set):Float = 1.0;

    public var individualAngle(default, set):Float = 0.0;

    public function new(Text:String, Width:Float = 1.0, Height:Float = 1.0, Font:String = "default") 
    {
        super();

        rows = [];

        // now children will no longer directly transform their scale
        scale = new FlxPoint(1.0, 1.0);

        size = new FlxCallbackPoint(_ -> updateChildPosition());
        size.set(Width, Height);
        font = Font;
        text = Text;
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

        var voidRows:Float = 0.0;
        
        for (rowIndex => rowValue in textSplitted) 
        {
            final characters:Array<String> = rowValue.split("");
            var spaces:Int = 0;

            if (rowValue == "")
            {
                ++voidRows;
                continue;
            }
            spaces = 0;
            for (index => character in characters)
            {
                if (character == " ") 
                {
                    ++spaces;
                    continue;
                }
                var sprite:FunkinTextChar = null;
                function createCharacter(daFont:String):Void
                {
                    sprite = FunkinText.getTemplate(daFont);
                    sprite.parent = this;
                    sprite.setData(character, daFont, size.x, size.y, rowIndex, lastCharacter);
                    sprite.ID = index;
                }
                createCharacter(font);
                add(sprite); // add the sprite before of update the position

                sprite.lastSpaces = spaces;
                sprite.lastRows = voidRows;
                sprite.refreshChar(() -> 
                {
                    if (sprite.font == "default") return;
                    createCharacter("default");
                    sprite.originalFont = font;
                    sprite.refreshChar();
                });
                sprite._skipUpdatePosition = false;
                spaces = 0;
                lastCharacter = sprite;
            }
            lastCharacter = null;
            
            if (voidRows > 0)
            {
                voidRows = 0;
            }
            ++voidRows;
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
        final lastAngle:Float = angle;
        setPosition(0, 0);
        generateText(text, font);
        // centerOrigin();
        setPosition(lastPosition.x, lastPosition.y);
        this.angle = lastAngle;
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
        if (this.font == newFont) return this.font;

        refreshText(this.text, newFont);
        return this.font = newFont;
    }

    // dont transform children
	private override function set_x(Value:Float):Float
	{
        updateChildPosition();
		return x = Value;
	}
	private override function set_y(Value:Float):Float
	{
        updateChildPosition();
		return y = Value;
	}
    private override function set_angle(Value:Float):Float
	{
        updateChildPosition();
		return angle = Value;
	}
    private function set_spaceLength(Value:Float):Float
	{
        updateChildPosition();
		return spaceLength = Value;
	}
    private function set_rowSize(Value:Float):Float
	{
        updateChildPosition();
		return spaceLength = Value;
	}

    @:noCompletion
    private inline function set_individualAngle(Value:Float):Float 
    {
        updateChildPosition();
        return individualAngle = Value;
    }

    public override function setPosition(X:Float = 0, Y:Float = 0):Void 
    {
        this.x = X;
        this.y = Y;
    }

    // for angle stuff
    private override function findMinXHelper():Float
	{
		var value:Float = Math.POSITIVE_INFINITY;
		for (member in group.members)
		{
			if (member == null)
				continue;
			
			var minX:Float;
			if (member.flixelType == SPRITEGROUP)
				minX = (cast member:FlxSpriteGroup).findMinX();
			else if (member is FunkinTextChar)
				minX = (cast member:FunkinTextChar).globalPosition.x + (cast member:FunkinTextChar).position.x;
            else
                minX = member.x;
			
			if (minX < value)
				value = minX;
		}
		return value;
	}
    private override function findMaxXHelper()
	{
		var value = Math.NEGATIVE_INFINITY;
		for (member in group.members)
		{
			if (member == null)
				continue;
			
			var maxX:Float;
			if (member.flixelType == SPRITEGROUP)
				maxX = (cast member:FlxSpriteGroup).findMaxX();
			else if (member is FunkinTextChar)
            {
                final char:FunkinTextChar = (cast member:FunkinTextChar);
				maxX = char.globalPosition.x + char.position.x + member.width;
            }
            else 
                maxX = member.x + member.width;
			
			if (maxX > value)
				value = maxX;
		}
		return value;
	}

    private override function findMinYHelper():Float
	{
		var value:Float = Math.POSITIVE_INFINITY;
		for (member in group.members)
		{
			if (member == null)
				continue;
			
			var minY:Float;
			if (member.flixelType == SPRITEGROUP)
				minY = (cast member:FlxSpriteGroup).findMinY();
			else if (member is FunkinTextChar)
				minY = (cast member:FunkinTextChar).globalPosition.y + (cast member:FunkinTextChar).position.y;
            else
                minY = member.y;
			
			if (minY < value)
				value = minY;
		}
		return value;
	}
    private override function findMaxYHelper()
	{
		var value = Math.NEGATIVE_INFINITY;
		for (member in group.members)
		{
			if (member == null)
				continue;
			
			var maxY:Float;
			if (member.flixelType == SPRITEGROUP)
				maxY = (cast member:FlxSpriteGroup).findMaxY();
			else if (member is FunkinTextChar)
            {
                final char:FunkinTextChar = (cast member:FunkinTextChar);
				maxY = char.globalPosition.y + char.position.y + member.height;
            }
            else 
                maxY = member.y + member.height;
			
			if (maxY > value)
				value = maxY;
		}
		return value;
	}

    private function updateChildPosition():Void 
    {
        if (length == 0) return;
        for (child in members) 
        {
            child.updatePosition();
        }
    }

    public static function loadFont(font:String):Void 
    {
        if (templates.exists(font)) return;

        final character:FunkinTextChar = new FunkinTextChar();
        character.setData(FunkinTextChar.DEFAULT_CHAR, font, 1.0, 1.0);
        character.isTemplate = true;
        character.loadFont();
        templates.set(font, character);
    }

    public static function getTemplate(font:String):FunkinTextChar 
    {
        var char:FunkinTextChar = pool.get();
        var template:FunkinTextChar = templates.get(font);
        if (template != null) 
        {
            char.copyFrom(template);
        }
        return char;
    }

    @:allow(Main)
    private inline static function loadDefaultFont():Void 
    {
        loadFont("default");
    }
}
