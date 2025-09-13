/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2025 Infinite KemonoYagi
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package funkin.assets;

import flixel.FlxG;

class FunkinAssetsMemory 
{
    private var permanentImages:Array<String>;
    public  var storedImages(default, null):Map<String, Graphic>;

    private var permanentAudios:Array<String>;
    public  var storedAudios(default, null):Map<String, Sound>;

    private var permanentFiles:Array<String>; // for big files (e.g. JSON, etc)
    public  var storedFiles(default, null):Map<String, String>;

    public function new() 
    {
        storedImages = [];
        storedAudios = [];
        storedFiles = [];

        permanentImages = [];
        permanentAudios = [];
        permanentFiles  = [];
    }

    public function loadImage(dir:String, ?permanent:Bool = false):Null<Graphic>
    {
        if (storedImages.exists(dir))
            return storedImages.get(dir);

        final graphic:Null<Graphic> = FlxG.bitmap.add(dir, true, dir);

        if (graphic != null)
        {
            #if INFINITE_CACHE
            graphic.persist = true;
            if (permanent != null && permanent) permanentImages.push(dir);
            #end

            storedImages.set(dir, graphic);
        }

        return graphic;
    }

    public function getImage(dir:String):Null<Graphic>
        return storedImages.get(dir);

    public function hasImage(dir:String):Bool
        return storedImages.exists(dir);

    public function loadAudio(dir:String, ?permanent:Bool = false):Null<Sound>
    {
        if (storedAudios.exists(dir))
            return storedAudios.get(dir);

        final OFLAssets = openfl.utils.Assets;
        final sound:Null<Sound> = OFLAssets.getSound(dir, #if INFINITE_CACHE permanent #else false #end);

        if (sound != null)
        {
            #if INFINITE_CACHE
            if (permanent != null && permanent) permanentAudios.push(dir);
            #end

            storedAudios.set(dir, sound);
        }

        return sound;
    }

    public function getAudio(dir:String):Null<Sound>
        return storedAudios.get(dir);

    public function hasAudio(dir:String):Bool
        return storedAudios.exists(dir);

    public function loadFile(dir:String, ?permanent:Bool = false):Null<String>
    {
        if (storedFiles.exists(dir))
            return storedFiles.get(dir);

        final OFLAssets = openfl.utils.Assets;
        final file:Null<String> = OFLAssets.getText(dir);

        if (file != null)
        {
            #if INFINITE_CACHE
            if (permanent != null && permanent) permanentFiles.push(dir);
            #end

            storedFiles.set(dir, file);
        }

        return file;
    }

    public function getFile(dir:String):Null<String>
        return storedFiles.get(dir);

    public function hasFile(dir:String):Bool
        return storedFiles.exists(dir);

    @:allow(Main)
    private function clear():Void 
    {
        for (key => value in storedImages)
        {
            if (!permanentImages.contains(key))
            {
                value.persist = false;
                FlxG.bitmap.remove(value);
                storedImages.remove(key);
            }
        }

        for (key => value in storedAudios)
        {
            if (!permanentAudios.contains(key))
            {
                value.close();
                storedAudios.remove(key);
            }
        }

        for (key => _ in storedFiles)
        {
            if (!permanentFiles.contains(key))
                storedFiles.remove(key);
        }
    }
}
