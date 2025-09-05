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

import funkin.assets.FunkinPaths;
import flixel.FlxSprite;
import funkin.visuals.text.FunkinText;
import funkin.backend.state.FunkinState;

class MenuState extends FunkinState 
{
    var test:FunkinText = null;

    public function new() 
    {
        super();

        var background:FlxSprite = new FlxSprite().loadGraphic(FunkinPaths.images("menu/menuDesat.png"));
        add(background);

        test = new FunkinText("Hello, \nthis is a test text. ☺", 0.45, "bold");
        add(test);
    }

    public override function create():Void 
    {
        super.create();
    }

    var timer:Float = 0.0;

    public override function update(elapsed:Float):Void 
    {
        super.update(elapsed);

        timer += elapsed;

        test.text = "Timer: " + Math.floor(timer);
    }
}