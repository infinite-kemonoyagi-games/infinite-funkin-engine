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

package funkin.visuals.menu;

import flixel.FlxBasic;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.FlxSprite;

import funkin.backend.visual.FunkinSprite;

enum abstract MenuItemState(String) from String to String 
{
    public inline final idle:MenuItemState;
    public inline final selected:MenuItemState;
    public inline final pressed:MenuItemState;
}

typedef MenuItemAnimation = {?complexAnim:Bool, animation:String}

@:generic
class MenuItem<T:FlxSprite> extends FlxBasic
{
    public var sprite:T = null;

    public var isSelected(default, null):Bool = false;
    public var isPressed(default, null):Bool = false;

    public var onIdle(default, null):FlxTypedSignal<MenuItem<T> -> Void> = null;
    public var justIdle(default, null):FlxTypedSignal<MenuItem<T> -> Void> = null;

    public var onSelected(default, null):FlxTypedSignal<MenuItem<T> -> Void> = null;
    public var justSelected(default, null):FlxTypedSignal<MenuItem<T> -> Void> = null;

    public var onPressed(default, null):FlxTypedSignal<MenuItem<T> -> Void> = null;
    public var justPressed(default, null):FlxTypedSignal<MenuItem<T> -> Void> = null;

    public var animNames(default, null):Map<MenuItemState, MenuItemAnimation> = null;

    public var state(default, null):MenuItemState = null;
    private var lastState(default, null):MenuItemState = null;

    public var target:Float = 0.0;
    public var speed:Float = 6.5;

    public var positionData(default, null):(item:MenuItem<T>, range:Float) -> Void;
    public var animatePosition:Bool = false;

    public function new(sprite:T)
    {
        super();

        this.sprite = sprite;

        onIdle = new FlxTypedSignal();
        justIdle = new FlxTypedSignal();

        onSelected = new FlxTypedSignal();
        justSelected = new FlxTypedSignal();

        onPressed = new FlxTypedSignal();
        justPressed = new FlxTypedSignal();

        animNames = [];

        positionData = MenuItemPositionData.defaultAnim;
    }

    public override function draw():Void 
    {
        super.draw();
        sprite.draw();

        #if FLX_DEBUG
        ++FlxBasic.visibleCount;
        #end
    }

    public override function update(elapsed:Float):Void
    {
        super.update(elapsed);
        sprite.update(elapsed);

        #if FLX_DEBUG
        ++FlxBasic.activeCount;
        #end

        if (animatePosition) setPositionMenu(elapsed, false);
    }

    public function setPositionMenu(?elapsed:Float, instant:Bool):Void
    {
        if (elapsed == null) elapsed = FlxG.elapsed;
        var range:Float = elapsed * speed;
        if (instant) range = 1;

        positionData(this, range);
    }

    public function addAnimation(state:MenuItemState, func:(sprite:T) -> MenuItemAnimation) 
    {
        final data:MenuItemAnimation = func(sprite);

        if ((data.complexAnim != null && data.complexAnim) && !(sprite is FunkinSprite))
        {
            FlxG.log.warn("to use complex animation, sprite it should be as FunkinSprite");
            return;
        }

        if (data.complexAnim == null) data.complexAnim = false;
        animNames.set(state, data);
    }

    public function changeState(state:MenuItemState, ?updateHitbox:Bool = false):Void
    {
        switch state 
        {
            case MenuItemState.idle:
                onIdle.dispatch(this);
            case MenuItemState.selected:
                onSelected.dispatch(this);
            case MenuItemState.pressed:
                onPressed.dispatch(this);
        }

        if (lastState == state) return;
        this.state = lastState;
        lastState = state;

        switch state 
        {
            case MenuItemState.idle:
                isSelected = false;
                isPressed = false;
                justIdle.dispatch(this);
                playAnimation(state, updateHitbox);

            case MenuItemState.selected:
                isSelected = true;
                justSelected.dispatch(this);
                playAnimation(state, updateHitbox);

            case MenuItemState.pressed:
                isSelected = true;
                isPressed = true;
                justPressed.dispatch(this);
                playAnimation(state, updateHitbox);
        }
    }

    private function playAnimation(state:MenuItemState, ?updateHitbox:Bool = false):Void
    {
        if (!animNames.exists(state)) return;

        final animData:MenuItemAnimation = animNames.get(state);
        if (animData.complexAnim)
        {
            final funkinSpr:FunkinSprite = cast sprite;
            funkinSpr.animationComplex.play(animData.animation);
        }
        else if (sprite.animation != null && sprite.animation.exists(animData.animation))
        {
            sprite.animation.play(animData.animation);
        }

        if (updateHitbox)
        {
            sprite.updateHitbox();
        }
    }

    public override function destroy():Void 
    {
        super.destroy();
        sprite.destroy();
    }

    public override function kill():Void 
    {
        super.kill();
        sprite.kill();
    }

    public override function revive():Void 
    {
        super.revive();
        sprite.revive();
    }
}

class MenuItemPositionData 
{
    /**
     * item.animationData = defaultAnim;
     */
    public static function defaultAnim<T:FlxSprite>(item:MenuItem<T>, range:Float):Void
    {
        final scaledY = FlxMath.remapToRange(item.target, 0, 1, 0, 1.3);
        item.sprite.y = FlxMath.lerp(item.sprite.y, (scaledY * 120) + (FlxG.height * 0.48), range);
        item.sprite.x = FlxMath.lerp(item.sprite.x, (item.target * 20) + 90, range);
    }
    /**
     * item.animationData = onlyYAnim;
     */
    public static function onlyYAnim<T:FlxSprite>(item:MenuItem<T>, range:Float):Void
    {
        final scaledY = FlxMath.remapToRange(item.target, 0, 1, 0, 1.3);
        item.sprite.y = FlxMath.lerp(item.sprite.y, (scaledY * 120) + (FlxG.height * 0.48), range);
    }
}
