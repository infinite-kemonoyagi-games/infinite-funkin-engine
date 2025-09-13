/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2025 Infinite KemonoYagi
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
