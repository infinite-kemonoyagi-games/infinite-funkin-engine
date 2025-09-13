package funkin.utils;

typedef TypePoint = {
    var x:Float;
    var y:Float;
}

typedef TypePointInt = {
    var x:Int;
    var y:Int;
}

class MathUtils
{
    /**
     * Works similar that `FlxMath.bound` but this works more like a pacman level.
     * 
     * when the value exceeds max value, this will be as the min value.
     * and otherwise, when is less than min value will be as the max value.
     * 
     * ```haxe
     * // 150 is more than 149, so returns 0 (the min value)
     * CatUtils.boundLoop(150, 0, 149); // 0
     * 
     * // -1 is less than 0, so returns 149 (the max value)
     * CatUtils.boundLoop(-1, 0, 149); // 149
     * ```
     */
    public static function boundLoop<T:Float>(value:T, min:T, max:T): T
    {
        if (!(value is Int || value is Float)) return value;
        if (value < min) return max;
        if (value > max) return min;
        return value;
    }

    public static function closeEnough(a:Float, b:Float, epsilon:Float = 0.001):Bool
    {
        return Math.abs(a - b) <= epsilon;
    }
}