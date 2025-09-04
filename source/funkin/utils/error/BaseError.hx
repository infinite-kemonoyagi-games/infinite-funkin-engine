package funkin.utils.error;

@:nullSafety
class BaseError<Code:Int>
{
    public var code:Null<Code> = null;
    public var message:Null<String> = null;

    public function new(code:Code, ?aditionalMsg:Null<String>)
    {
        this.code = code;

        message = setMessage(aditionalMsg);
    }

    private function setMessage(aditionalMsg:Null<String>):String 
    {
        return "";
    }

    public inline function toString():String 
    {
        return '${message} | error code: ${code}';    
    }
}