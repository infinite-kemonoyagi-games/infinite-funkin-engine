package funkin.menu.freeplay;

import funkin.backend.group.FunkinGroup.FunkinTypedGroup;
import funkin.visuals.menu.MenuItem;
import funkin.visuals.FunkinIcon;
import funkin.visuals.text.FunkinText;
import flixel.FlxSprite;
import funkin.backend.group.FunkinSpriteGroup.FunkinTypedSpriteGroup;
import funkin.backend.state.FunkinState;
import flixel.util.FlxColor;

class FreeplayState extends FunkinState
{
    public var list:FreeplayList = null;

    public override function create() 
    {
        super.create();

        list = new FreeplayList(this);
    }
}

typedef FreeplayData = 
{
    var name:String;
    var icon:String;
    var color:FlxColor;
    var song:String;
    var author:String;
    var difficulties:Array<String>;
    var rate:Int;
}

class FreeplayList
{
    private var list:Array<FreeplayData>;
    public var group:FunkinTypedGroup<FreeplayGroup>;

    public var length(get, never):Float;

    public function new(parent:FreeplayState)
    {
        list = [];

        group = new FunkinTypedGroup();
        parent.add(group);
    }

    public function add(data:FreeplayData):FreeplayData 
    {
        list.push(data);
        group.add(new FreeplayGroup(data, list.length - 1));

        return data;
    }

    public inline function get(index:Int):FreeplayData
    {
        return list[index];
    }

    public inline function set(index:Int, data:FreeplayData):FreeplayData
    {
        return list[index] = data;
    }

    @:noCompletion
    private inline function get_length():Float 
    {
        return list.length;
    }
}

class FreeplayGroup extends FunkinTypedSpriteGroup<FlxSprite>
{
    public var text:MenuItem<FunkinText> = null;
    public var icon:FunkinIcon = null;

    public function new(data:FreeplayData, index:Int)
    {
        super();

        text = new MenuItem(new FunkinText(data.name, "bold"));
        text.animatePosition = true;
        text.positionData = MenuItemPositionData.defaultAnim;
        text.target = text.ID = index;
        add(text.sprite);

        icon = new FunkinIcon(data.icon);
        icon.parent = text.sprite;
        add(icon);
    }
}
