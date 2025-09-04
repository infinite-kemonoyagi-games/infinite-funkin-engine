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

package;

import funkin.assets.FunkinAssets;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

import funkin.assets.FunkinPaths;

#if (linux || mac)
import lime.graphics.Image;
#end

@:access(flixel.FlxGame)
class Main extends Sprite
{
	public static var current(default, null):Main = null;

	public var game(default, null):FlxGame = null;
	public var assets(default, null):FunkinAssets = null;

	public static function main():Void
	{
		Lib.current.addChild(current = new Main());
	}

	public function new()
	{
		super();

		// avoid Lib.current.stage "Null object reference" Error
		if (stage != null)
		{
			init();
		}
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}

	public function init(?_):Void
	{
		if (Lib.current.hasEventListener(Event.ADDED_TO_STAGE))
		{
			Lib.current.removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		#if (linux || mac)
		Lib.current.stage.window.setIcon(Image.fromFile("assets/images/icon/iconOG.png"));
		#end

		/* 
			i don't recommend to set the initial state (not in the constructor).
			if you want to initialize some of your game's stuff before of state initialize
			initialize it at the end with 'FlxG.switchState' and 'game._initialState' (optional) 
		*/
		game = new FlxGame();
		addChild(game);

		FlxSprite.defaultAntialiasing = true;
		assets = new FunkinAssets();

		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;
		#end

		FlxG.fixedTimestep = false;
		FlxG.keys.preventDefaultKeys = [TAB];

		game.focusLostFramerate = Std.int(Lib.current.stage.frameRate / 2);

		FlxG.switchState(game._initialState);
	}

	public function changeInitialState(newState:FlxState):Void
	{
		if (game != null) 
		{
			game._initialState = () -> newState;
		}
	}
}
