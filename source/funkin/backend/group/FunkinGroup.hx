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