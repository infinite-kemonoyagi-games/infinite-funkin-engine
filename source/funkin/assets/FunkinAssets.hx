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
