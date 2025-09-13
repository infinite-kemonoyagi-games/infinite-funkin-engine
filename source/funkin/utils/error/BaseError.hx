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