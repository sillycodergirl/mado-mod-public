package states;

import hxvlc.flixel.FlxVideoSprite;
import flixel.FlxState;

class PiracyState extends MusicBeatState {
	var video:FlxVideoSprite;

	override function create() {
		super.create();

		video = new FlxVideoSprite();
		video.bitmap.onFormatSetup.add(()->{
			video.setGraphicSize(FlxG.width, FlxG.height);
			video.updateHitbox();
			video.screenCenter();
		});

		video.bitmap.onEndReached.add(()->{
			FlxG.switchState(cast(Type.createInstance(Main.game.initialState, []), FlxState));
		});

		video.antialiasing = true;
		video.load(Paths.video('piracy'));
		add(video);
		video.play();
	}
}