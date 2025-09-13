package funkin.utils;

import funkin.utils.MathUtils.TypePointInt;
import funkin.utils.MathUtils.TypePoint;

typedef BasicAnimation = 
{
    var ?sprite:String;
    var ?size:TypePointInt;
    var animations:Array<BasicAnimationData>;
}

typedef BasicAnimationData = 
{
    var name:String;
    var ?prefix:String;
    var ?frames:Array<Int>;
    var framerate:Int;
    var isLoop:Bool;
    var offset:TypePoint;

    var ?sprite:String;
    var ?size:TypePointInt;
}
