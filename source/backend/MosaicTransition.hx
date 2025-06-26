package backend;

import openfl.filters.ShaderFilter;
import shaders.MosaicShader.MosaicEffect;

class MosaicTransition extends MusicBeatSubstate {
    public static inline var MAX_STRENGTH = 50;
    public static inline var MIN_STRENGTH = 0;


    public static var finishCallback:Void->Void;
    var isTransIn:Bool = false;
    
    var effect:MosaicEffect;

    var duration:Float;
    public function new(duration:Float, isTransIn:Bool) {
        this.duration = duration;
        this.isTransIn = isTransIn;
        super();
    }

    override function create() {
        camera = [FlxG.cameras.list[FlxG.cameras.list.length-1]][0];

        effect = new MosaicEffect();

        var start = isTransIn ? MIN_STRENGTH : MAX_STRENGTH;
        var end = isTransIn ? MAX_STRENGTH : MIN_STRENGTH;

        camera.filters = [new ShaderFilter(effect.shader)];

        FlxTween.num(start, end, duration, {
            onComplete: function(t:FlxTween) {
                camera.filters = [];
                if (finishCallback != null)
                    finishCallback();
                finishCallback = null;
                close(); // prolly close after the function call for loading purposes
            }
        }, (v) -> {
            effect.setStrength(v,v);
        });

        super.create();
    }
}