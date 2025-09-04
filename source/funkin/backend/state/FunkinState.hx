package funkin.backend.state;

import funkin.assets.FunkinAssetsLoad;
import funkin.assets.FunkinAssets;
import flixel.FlxState;

class FunkinState extends FlxState 
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