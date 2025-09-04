package funkin.backend.visual;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxTileFrames;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxFramesCollection;
import funkin.assets.FunkinAssetsLoad;
import funkin.assets.FunkinAssets;
import flixel.FlxSprite;

class FunkinSprite extends FlxSprite 
{
    public var animationComplex(default, null):AnimationComplex = null;

    public var assets(get, never):FunkinAssets;
    public var load(get, never):FunkinAssetsLoad;

    public function new() 
    {
        animationComplex = new AnimationComplex(this);
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

class AnimationComplex
{
    public var sprite:FunkinSprite = null;

    private var storedFrames:Map<FlxFramesCollection, Array<String>> = [];
    public var offsets:Map<String, FlxPoint> = [];
    
    public function new(Sprite:FunkinSprite)
    {
        sprite = Sprite;    
    }

    /**
	 * Adds a new animation to the sprite.
	 *
	 * @param   name        What this animation should be called (e.g. `"run"`).
	 * @param   frames      An array of indices indicating what frames to play in what order (e.g. `[0, 1, 2]`).
	 * @param   frameRate   The speed in frames per second that the animation should play at (e.g. `40` fps).
	 * @param   looped      Whether or not the animation is looped or just plays once.
	 * @param   flipX       Whether the frames should be flipped horizontally.
	 * @param   flipY       Whether the frames should be flipped vertically.
	 */
	public function add(image:FlxGraphic, fWidth:Float, fHeight:Float, name:String, 
        frames:Array<Int>, framerate:Float = 30.0, looped = true, flipX = false, flipY = false):Void
	{
        sprite.animation.add(name, frames, framerate, looped, flipX, flipY);

        final tile = FlxTileFrames.fromGraphic(image, new FlxPoint(fWidth, fHeight));

        if (!storedFrames.exists(tile)) storedFrames.set(tile, [name]);
        else storedFrames.get(tile).push(name);
    }

    /**
	 * Adds a new animation to the sprite.
	 *
	 * @param   name        What this animation should be called (e.g. `"run"`).
	 * @param   prefix      Common beginning of image names in atlas (e.g. `"tiles-"`).
	 * @param   framerate   The animation speed in frames per second.
	 *                      Note: individual frames have their own duration, which overrides this value.
	 * @param   looped      Whether or not the animation is looped or just plays once.
	 * @param   flipX       Whether the frames should be flipped horizontally.
	 * @param   flipY       Whether the frames should be flipped vertically.
	 */
    public function addByPrefix(frame:FlxAtlasFrames, name:String, 
        prefix:String, framerate:Float = 30.0, looped = true, flipX = false, flipY = false):Void 
    {
        sprite.setFrames(frame, true);
        sprite.animation.addByPrefix(name, prefix, framerate, looped, flipX, flipY);

        if (!storedFrames.exists(frame)) storedFrames.set(frame, [name]);
        else storedFrames.get(frame).push(name);
    }

	/**
	 * Adds a new animation to the sprite.
	 *
	 * @param   name        What this animation should be called (e.g. `"run"`).
	 * @param   prefix      Common beginning of image names in the atlas (e.g. "tiles-").
	 * @param   indices     An array of numbers indicating what frames to play in what order (e.g. `[0, 1, 2]`).
	 * @param   framerate   The speed in frames per second that the animation should play at (e.g. `40` fps).
	 * @param   looped      Whether or not the animation is looped or just plays once.
	 * @param   flipX       Whether the frames should be flipped horizontally.
	 * @param   flipY       Whether the frames should be flipped vertically.
	 */
    public function addByIndices(frame:FlxAtlasFrames, name:String, 
        prefix:String, indices:Array<Int>, framerate = 30.0, looped = true, flipX = false, flipY = false):Void 
    {
        sprite.setFrames(frame, true);
        sprite.animation.addByIndices(name, prefix, indices, "", framerate, looped, flipX, flipY);

        if (!storedFrames.exists(frame)) storedFrames.set(frame, [name]);
        else storedFrames.get(frame).push(name);
    }

    public function setOffsets(anim:String, x:Float, y:Float):Void 
    {
        offsets.set(anim, new FlxPoint(x, y));
    }

    /**
	 * Plays an existing animation (e.g. `"run"`).
	 * If you call an animation that is already playing, it will be ignored.
	 *
	 * @param   animName   The string name of the animation you want to play.
	 * @param   force      Whether to force the animation to restart.
	 * @param   reversed   Whether to play animation backwards or not.
	 * @param   frame      The frame number in the animation you want to start from.
	 *                     If a negative value is passed, a random frame is used.
	 */
    public function play(animName:String, force = false, centerOffsets:Bool = false, 
        reversed = false, frame = 0):Void
    {
        for (frame => animations in storedFrames) 
        {
            if (animations.contains(animName))
            {
                sprite.setFrames(frame, true);
                break;
            }
        }

        if (!sprite.animation.exists(animName)) return;

        sprite.animation.play(animName, force, reversed, frame);

        if (centerOffsets) sprite.centerOffsets();
        if (offsets != null && offsets.exists(animName))
            sprite.offset.copyFrom(offsets.get(animName));
    }
}
