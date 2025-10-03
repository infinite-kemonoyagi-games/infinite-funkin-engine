package funkin.menu;

import funkin.assets.FunkinPaths;
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
    private static var curSelected:Int = 0;
    private static var curItem:FreeplayGroup = null;

    private static var curDifficultyName:String = "normal";
    private static var curDifficultyID:Int = 0;

    public var list:FreeplayList = null;
    public var background:FlxSprite = null;

    public function new()
    {
        super();
    }

    public override function create():Void
    {
        super.create();

        list = new FreeplayList(this);

        background = new FlxSprite();
        background.loadGraphic(load.image(FunkinPaths.images("menu/menuDesat.png"), true));
        add(background);

        addSong(function(data):Void
        {
            data.name = "Bopeebo";
            data.icon = "dad";
            data.color = FlxColor.fromRGB(146, 113, 253, 255);
            data.song = "bopeebo";
        });
    }

    private function addSong(listener:(data:FreeplayData) -> Void):Void 
    {
        final data = new FreeplayData();
        listener(data);
        list.add(data);
    }
}

class FreeplayData 
{
    public var name:String;
    public var icon:String;
    public var color:FlxColor;
    public var song:String;
    public var author:String;
    public var difficulties:Array<String>;
    public var rate:Int;

    public function new() 
    {
        name = "template song";
        icon = "default-face";
        color = 0xFFFFFFFF;
        song = "template-song";
        author = "unknown";
        difficulties = ["easy", "normal", "hard"];
        rate = 0;
    }
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

    public inline function getGroup(index:Int):FreeplayGroup
    {
        return group.members[index];
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
