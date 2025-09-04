package funkin.assets;

#if sys
import sys.FileSystem;
#end

class FunkinAssets 
{
    public var memory:FunkinAssetsMemory;
    public var load:FunkinAssetsLoad;

    public function new()
    {
        memory = new FunkinAssetsMemory();
        load = new FunkinAssetsLoad(this);
    }

    public function exists(dir:String):Bool 
    {
        #if sys
        return FileSystem.exists(dir);
        #else
        return OFLAssets.exists(dir, null);
        #end
    }
}
