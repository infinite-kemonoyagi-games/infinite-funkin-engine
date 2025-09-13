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

package funkin.assets;

import flixel.graphics.frames.FlxAtlasFrames;

class FunkinAssetsLoad
{
    private var instance:Null<FunkinAssets>;

    public function new(instance:FunkinAssets)
    {
        this.instance = instance;
    }

    public function image(dir:String, ?permanent:Bool = false):Null<Graphic>
    {
        if (instance == null) return null;

        if (instance.memory.hasImage(dir))
            return instance.memory.getImage(dir);

        if (!instance.exists(dir)) return null;

        return instance.memory.loadImage(dir, permanent);
    }

    public function audio(dir:String, ?permanent:Bool = false):Null<Sound>
    {
        if (instance == null) return null;

        if (instance.memory.hasAudio(dir))
            return instance.memory.getAudio(dir);

        if (!instance.exists(dir)) return null;

        return instance.memory.loadAudio(dir, permanent);
    }

    public function file(dir:String, ?permanent:Bool = false):Null<String>
    {
        if (instance == null) return null;
        
        if (instance.memory.hasFile(dir))
            return instance.memory.getFile(dir);
        
        if (!instance.exists(dir)) return null;
        
        return instance.memory.loadFile(dir, permanent);
    }

    @:nullSafety(Off)
    public function sparrowAtlas(dir:String, ?permanent:Bool = false):Null<FlxAtlasFrames>
    {
        return FlxAtlasFrames.fromSparrow(image('$dir.png', permanent), file('$dir.xml', permanent));
    }
}