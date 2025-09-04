package funkin.backend.group;

import funkin.assets.FunkinAssetsLoad;
import funkin.assets.FunkinAssets;
import funkin.backend.visual.FunkinSprite.AnimationComplex;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

typedef FunkinSpriteGroup = FunkinTypedSpriteGroup<FlxSprite>;

class FunkinTypedSpriteGroup<F:FlxSprite> extends FlxTypedSpriteGroup<F> 
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