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
package funkin.macro;

import funkin.utils.error.DirectoryBuildError;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;

final class DirectoryBuild 
{
    public macro static function buildFromDir(dir:String = "assets", toStatic:Bool = true):Null<Array<Field>>
    {
        var fields:Array<Field> = Context.getBuildFields();

        if (dir == null || dir == "")
        {
            throw new DirectoryBuildError(NULL, dir);
        }

        #if sys
        if (!FileSystem.exists(dir))
        #else
        if (!openfl.utils.Assets.exists(dir))
        #end
        {
            throw new DirectoryBuildError(NO_EXISTS, dir);
        }

        #if sys
        var files:Array<String> = FileSystem.readDirectory(dir);
        #else
        var files:Array<String> = openfl.utils.Assets.getLibrary("").list(dir);
        #end
        if (dir?.startsWith('./')) dir = dir.replace('./$dir', dir);

        // only main folders in `dir`
        // "assets/file.ext" or "assets/subfolder/" are not allowed

        final regFile:EReg = ~/^[\.\/]?[a-zA-Z0-9\/_-]+(\.[a-zA-Z0-9\/_-]+)$/;
        final regFolders:EReg = ~/^[\.\/]?([a-zA-Z0-9\/_-]+)$/;

        files = files.filter(d -> !regFile.match(d) && (regFolders.match(d) && d.split("/").length <= 2));

        for (file in files) 
        {
            final functionName:String = file.replace('$file/', '').replace('.', '_');
            if (file == dir) continue;
            try 
            {
                final nFunc:Function = {
                    args: [{name: "file", type: macro: String, opt: false, value: null}],
                    ret: macro: String,
                    expr: macro return funkin.macro.DirectoryBuild.BuildDirectoryPath.getPathFolder($v{'$dir/' + file}, file)
                };
                final nField:Field = {
                    name: functionName,
                    kind: FFun(nFunc),
                    access: [APublic, AInline],
                    doc: '$dir/$file/',
                    pos: Context.currentPos()
                };
                if (toStatic) nField.access.push(AStatic);
                fields.push(nField);
            }
            catch(_:Dynamic)
            {
                throw new DirectoryBuildError(UNKNOW, dir);
            }
        }
        
        return fields;
    }
}

final class BuildDirectoryPath 
{
    public static inline function getPathFolder(dir:String, folder:String):String 
    {
        return '$dir/$folder/';
    }
}
