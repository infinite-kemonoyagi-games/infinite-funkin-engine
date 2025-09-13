package funkin.visuals;

import flixel.graphics.frames.FlxAtlasFrames;
import funkin.utils.BasicAnimationData;
import haxe.Json;
import flixel.system.FlxAssets.FlxGraphicAsset;
import funkin.assets.FunkinPaths;
import flixel.FlxSprite;
import funkin.backend.visual.FunkinSprite;

class FunkinIcon extends FunkinSprite 
{
    public static inline final DEFAULT_PATH:String = "icons/";

    public var parent:FlxSprite = null;

    public var data:BasicAnimation = null;

    public var character:String = "";
    public var isPlayer:Bool = false;
    public var isOld:Bool = false;

    public var isAnimated:Bool = false;
    public var containsData:Bool = true;

    public var directory(default, null):String;

    public function new(character:String = "boyfriend", ?isAnimated:Bool = true, ?isPlayer:Bool = false) 
    {
        super();

        this.isAnimated = isAnimated;
    }

    public function setCharacter(character:String = "boyfriend", ?isPlayer:Bool = false):Void 
    {
        this.character = character;
        this.isPlayer = isPlayer;
    }

    public function loadIcon(?dir:String, ?containsData:Bool = true, ?data:BasicAnimation = null):Void
    {
        this.containsData = containsData;

        if (dir == null)
        {
            dir = FunkinPaths.images(DEFAULT_PATH);
        }
        directory = dir;

        if (!directory.endsWith("/"))
        {
            directory += "/";
        }

        final image:FlxGraphicAsset = load.image(directory + '.png');
        this.data = {size: {x: 0, y: 0}, animations: []};

        if (isAnimated && containsData && data == null)
        {
            this.data = cast Json.parse(load.file(directory + '.json'));
        }
        else 
        {
            this.data = data;
        }

        if (isAnimated)
        {
            if (data.animations.length > 0)
            {
                for (anim in data.animations)
                {
                    final isSparrow:Bool = anim.prefix != null;
                    final hasFrames:Bool = anim.frames?.length != null;

                    if (isSparrow)
                    {
                        final frame:FlxAtlasFrames = load.sparrowAtlas(directory + (anim.sprite ?? data.sprite));

                        if (hasFrames)
                        {
                            animationComplex.addByIndices(frame, anim.name, anim.prefix, anim.frames, anim.framerate, anim.isLoop);
                        }
                        else
                        {
                            animationComplex.addByPrefix(frame, anim.name, anim.prefix, anim.framerate, anim.isLoop);
                        }
                    }
                    else 
                    {
                        final graphic:FlxGraphicAsset = load.image(directory + (anim.sprite ?? data.sprite) + ".png");
                        final img:FunkinAnimatedGraphic = new FunkinAnimatedGraphic(graphic, anim.size.x ?? data.size.x, 
                            anim.size.y ?? data.size.y);

                        animationComplex.add(img, anim.name, anim.frames, anim.framerate, anim.isLoop);
                    }

                    animationComplex.setOffsets(anim.name, anim?.offset.x, anim?.offset.y);
                }

                animationComplex.play(data.animations[0].name);
            }
        }
        else 
        {
            loadGraphic(image);
        }
    }

    public function swapToOld():Void 
    {
        isOld = !isOld;

        if (isOld)
        {
            final oldDirectory = FunkinPaths.images(directory + character + '-old.png');

            if (assets.exists(oldDirectory)) 
            {
                setCharacter(character, this.isPlayer);
                loadIcon(oldDirectory, this.containsData, this.data);
            }
            else 
            {
                setCharacter(character, this.isPlayer);
                loadIcon(FunkinPaths.images('icons/boyfriend-old.png'), this.containsData, this.data);
            }
        }
        else 
        {
            setCharacter(character, this.isPlayer);
            loadIcon(directory, this.containsData, this.data);
        }
    }

    public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

        flipX = isPlayer;

		if (parent != null)
        {
			setPosition(parent.x + parent.width + 10, parent.y - 30);
        }
	}
}