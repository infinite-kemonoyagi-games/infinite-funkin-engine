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

package funkin.backend.group;

import funkin.assets.FunkinAssetsLoad;
import funkin.assets.FunkinAssets;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

typedef FunkinGroup = FunkinTypedGroup<FlxBasic>;

class FunkinTypedGroup<F:FlxBasic> extends FlxTypedGroup<F> 
{
    public var assets(get, never):FunkinAssets;
    public var load(get, never):FunkinAssetsLoad;

    public function new() 
    {
        super();  
    }

    @:noCompletion
    private inline function get_assets():FunkinAssets
    {
        return Main.current.assets;
    }

    @:noCompletion
    private inline function get_load():FunkinAssetsLoad
    {
        return assets.load;
    }
}