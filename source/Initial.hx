package;

import flixel.FlxState;
import backend.Highscore;
import states.StoryMenuState;
import flixel.addons.transition.FlxTransitionableState;

class Initial extends MusicBeatState {
    override function create() {

        Paths.clearStoredMemory();

		#if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

        FlxG.save.bind('funkin', CoolUtil.getSavePath());
        ClientPrefs.loadPrefs();

        Highscore.load();

        if (FlxG.save.data.weekCompleted != null) {
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

        if (FlxG.save.data != null && FlxG.save.data.fullscreen) {
            FlxG.fullscreen = FlxG.save.data.fullscreen;
        }
        persistentUpdate = true;
        persistentDraw = true;

        FlxG.mouse.visible = false;

        super.create();

        #if !cpp
        FlxG.switchState(new states.PiracyState());
        #else
        FlxG.switchState(cast(Type.createInstance(Main.game.initialState, []), FlxState));
        #end
    }
}