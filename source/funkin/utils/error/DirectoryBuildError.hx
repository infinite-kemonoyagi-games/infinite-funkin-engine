package funkin.utils.error;

@:nullSafety
final class DirectoryBuildError extends BaseError<DirectoryBuildErrorCode>
{
    private override function setMessage(aditionalMsg:Null<String>):String 
    {
        if (code == null) return "";
        
        return switch code {
            case NULL:
                'Error | directory: ${aditionalMsg} is not a real directory.';
            case NO_EXISTS:
                'Error | directory: ${aditionalMsg} does not exists.';
            case UNKNOW:
                'Unknow Error | directory: ${aditionalMsg}';
        };
    }
}

enum abstract DirectoryBuildErrorCode(Int) from Int to Int 
{
    public var NULL = 0x01;
    public var NO_EXISTS = 0x10;
    public var UNKNOW = 0x11;
}
