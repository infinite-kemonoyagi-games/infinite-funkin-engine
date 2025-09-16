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

package funkin.menu;

import funkin.backend.visual.FunkinSprite;
import funkin.utils.MathUtils;
import flixel.FlxG;
import funkin.visuals.menu.MenuItem;
import flixel.util.FlxColor;
import funkin.backend.group.FunkinGroup.FunkinTypedGroup;
import flixel.FlxState;
import funkin.assets.FunkinPaths;
import flixel.FlxSprite;
import funkin.visuals.text.FunkinText;
import funkin.backend.state.FunkinState;

typedef MenuData = 
{
    var name:String;
    var ?func:() -> Void;
    var ?state:FlxState;
}

class MenuState extends FunkinState 
{
    private static var curSelected:Int = 0;
    private static var curData:MenuData = null;

    public var optionsList:Array<MenuData> = [
        {name: "storymode", state: null},
        {name: "freeplay", state: null},
        {name: "options", state: null},
        {name: "credits", state: null}
    ];

    public var background:FlxSprite = null;
    public var bgColorScheme:Map<String, FlxColor> = [
        "unselected" => 0xFFFFE574,
        "selected" => 0xFFF1497C,
    ];

    private var pressed:Bool = false;

    public var optionsGrp:FunkinTypedGroup<MenuItem<FunkinSprite>> = null;

    public var infoText:FunkinText = null;

    public function new() 
    {
        super();
    }

    public override function create():Void 
    {
        super.create();

        background = new FlxSprite();
        background.loadGraphic(load.image(FunkinPaths.images("menu/menuDesat.png"), true));
        background.color = bgColorScheme.get("unselected");
        add(background);

        optionsGrp = new FunkinTypedGroup();
        add(optionsGrp);

        final mult:Float = 50;
        final spaceBetween:Float = 5;

        var finalHeight:Float = 0.0;

        for (index => value in optionsList) 
        {
            final dir:String = FunkinPaths.images("menu/main/" + value.name);

            final item:MenuItem<FunkinSprite> = new MenuItem(new FunkinSprite());
            item.sprite.frames = load.sparrowAtlas(dir, true);
            item.ID = index;
            item.sprite.screenCenter(X);

            item.addAnimation(MenuItemState.idle, function(spr):MenuItemAnimation 
            {
                spr.animation.addByPrefix("idle", value.name + " idle", 24);
                return {animation: "idle", complexAnim: true};
            });
            item.addAnimation(MenuItemState.selected, function(spr):MenuItemAnimation 
            {
                spr.animation.addByPrefix("selected", value.name + " selected", 24);
                return {animation: "selected", complexAnim: true};
            });
            setOffsets(dir, item.sprite);

            item.justSelected.add(function(item:MenuItem<FunkinSprite>)
            {
                curData = optionsList[item.ID];
            });

            item.changeState(MenuItemState.idle, true);
            optionsGrp.add(item);

            finalHeight += item.sprite.height + spaceBetween;
        }

        final length = optionsGrp.length - 1;
        for (item in optionsGrp) 
        {
            item.sprite.y = (FlxG.height - finalHeight) * 0.5;
            item.sprite.y += (finalHeight * (item.ID / length)) - mult;
        }

        infoText = new FunkinText("Friday Night Funkin\' Infinite Engine | Version: 0.1.0 ♡", 0.35, 0.35, "bold");
        infoText.y = FlxG.height - infoText.height;
        add(infoText);

        changeSelector();
    }

    public override function update(elapsed:Float):Void 
    {
        super.update(elapsed);

        final up:Bool = FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W;
        final down:Bool = FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S;

        final accept:Bool = FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE;
        final back:Bool = FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE;

        if (up || down)
        {
            changeSelector(down ? 1 : -1);
        }

        for (item in optionsGrp)
        {
            item.sprite.screenCenter(X);
        }
    }

    private function changeSelector(sel:Int = 0, ?playSound:Bool = true):Void
    {
        curSelected += sel;
        curSelected = MathUtils.boundLoop(curSelected, 0, optionsList.length - 1);

        updateItems(playSound);
    }

    private function updateItems(?playSound:Bool = false):Void 
    {
        for (item in optionsGrp) 
        {
            item.changeState(MenuItemState.idle);

            if (item.ID == curSelected) 
            {
                item.changeState(MenuItemState.selected);
                item.sprite.centerOffsets();

                if (playSound)
                {
                    FlxG.sound.play(load.audio(FunkinPaths.sounds("menu/scrollMenu.ogg"), true));
                }
            }
        }
    }

    private function setOffsets(dir:String, sprite:FunkinSprite):Void
    {
        final file = load.file(dir + "-offsets.txt");
        final offsetList = file.split("\n");

        for (line in offsetList)
        {
            if (line.trim() == "") continue;

            final parts = line.split(" ");
            if (parts.length < 3) continue;

            final name = parts[0].replace("|", " ");
            final x:Float = Std.parseFloat(parts[1]);
            final y:Float = Std.parseFloat(parts[2]);

            sprite.animationComplex.setOffsets(name, x, y);
        }
    }
}
