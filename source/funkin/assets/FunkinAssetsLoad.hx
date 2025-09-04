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