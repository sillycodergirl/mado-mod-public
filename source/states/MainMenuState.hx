package states;

import options.MadoModSettings;
import flixel.addons.transition.FlxTransitionableState;
import shaders.MosaicShader.MosaicEffect;
import options.OptionsState;
import hxvlc.flixel.FlxVideoSprite;
import backend.CoolUtil;

class MainMenuState extends MusicBeatState {
	public static var psychEngineVersion:String = '0.7.3'; // This is also used for Discord RPC
	public static var introCompleted:Bool = false;

	var video:FlxVideoSprite;

	var table:FlxSprite;
	var logo:FlxSprite;
	var buttons:FlxTypedGroup<FlxSprite>;
	var mouse:FlxSprite;
	var mouseTracker:FlxSprite;

	var mouseEnabled:Bool = false;
	var buttonIDs:Array<String> = ['mado', 'options', 'credits'];
	var queuedSkip:Bool = false;

	override function create() {
		FlxG.camera.follow(null);

		super.create();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Main Menu", null);
		#end

		if (ClientPrefs.data.seenMouseWarning) {
			doMenuStuff();
			return;
		}

		new FlxTimer().start(1, (t)->{
			var sprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/mouseWarning'));
			sprite.screenCenter();
			sprite.alpha = 0;
			add(sprite);
			FlxTween.tween(sprite, {alpha: 1}, 0.5, {ease:FlxEase.cubeOut});
			FlxG.sound.play(Paths.sound('misc/popup'));
			new FlxTimer().start(3.5, (t)->{
				FlxTween.tween(sprite, {alpha: 0}, 1, {ease:FlxEase.cubeOut, onComplete: (t)->{
					remove(sprite);
					sprite.destroy();
					ClientPrefs.data.seenMouseWarning = true;
					ClientPrefs.saveSettings();
					doMenuStuff();
				}});
			});
		});

	}

	function doMenuStuff() {
		if (!introCompleted) {
			video = new FlxVideoSprite(0, 0);
			video.antialiasing = true;
			video.load(Paths.video('mado_intro'));
			video.bitmap.onFormatSetup.add(function() {
				video.setGraphicSize(FlxG.width, FlxG.height);
				video.updateHitbox();
				video.screenCenter();
			});
			video.bitmap.onPlaying.add(function() {
				FlxG.sound.playMusic(Paths.music('menu/mado_menu_intro'));
			});

			add(video);
			video.play();
		}

		Conductor.bpm = 102;

		table = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/table'));
		table.scale.set(0.7, 0.7);
		table.screenCenter();

		logo = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/logo'));
		logo.scale.set(0.7, 0.7);
		logo.screenCenter();
		logo.x -= logo.width / 2.55;

		buttons = new FlxTypedGroup<FlxSprite>();

		for (i in 0...buttonIDs.length) {
			var id = buttonIDs[i];
			var sprite:FlxSprite = new FlxSprite();
			sprite.frames = Paths.getSparrowAtlas('mainmenu/menubuttons');
			sprite.animation.addByPrefix('idle', id + '_idle');
			sprite.animation.addByPrefix('select', id + '_select');
			sprite.animation.play('idle');
			sprite.screenCenter(X);
			sprite.scale.set(0.7, 0.7);
			sprite.x += sprite.width + ((i % 2 == 0) ? 55 : 0);
			sprite.y = 150 + ((i * sprite.height) + 45);
			sprite.ID = i;
			sprite.updateHitbox();

			buttons.add(sprite);
		}

		mouseTracker = new FlxSprite(0, 0);
		mouseTracker.makeGraphic(20, 20, FlxColor.TRANSPARENT);

		mouse = new FlxSprite(0, 0);
		mouse.frames = Paths.getSparrowAtlas('mainmenu/cursor');
		mouse.animation.addByPrefix('normal', 'cursor_normal');
		mouse.animation.addByPrefix('click', 'cursor_click');
		mouse.animation.addByPrefix('hover', 'cursor_select');
		mouse.animation.play('normal');

		if (introCompleted)
			switchToMenu();
	}

	override function update(elapsed:Float) {
		if (FlxG.keys.justPressed.ENTER) {
			if (video != null) {
				queuedSkip = true;
			}
		}

		if (FlxG.sound.music != null) {
			Conductor.songPosition = FlxG.sound.music.time;
		}

		if (mouseTracker != null && mouseEnabled) {
			var mouseOffsetX = FlxG.mouse.screenX - FlxG.width / 2;
			var mouseOffsetY = FlxG.mouse.screenY - FlxG.height / 2;
			var scaledX = CoolUtil.clamp(mouseOffsetX * (1 / 6), -(FlxG.width / 6), FlxG.width / 6);
			var scaledY = CoolUtil.clamp(mouseOffsetY * (1 / 6), -(FlxG.height / 6), FlxG.height / 6);
			mouseTracker.setPosition((FlxG.width / 2) + scaledX, (FlxG.height / 2) + scaledY);

			var currentPos = FlxG.camera.scroll;
			var targetPos = mouseTracker.getPosition();

			var lerpSpeed = 0.02;
			FlxG.camera.scroll.set(FlxMath.lerp(currentPos.x, targetPos.x - FlxG.camera.width / 2, lerpSpeed),
				FlxMath.lerp(currentPos.y, targetPos.y - FlxG.camera.height / 2, lerpSpeed));
		}

		if (mouse != null && mouseEnabled) {
			if (FlxG.mouse.visible) FlxG.mouse.visible = false;
			if (FlxG.mouse.pressed) {
				if (mouse.animation.curAnim.name != 'click') {
					mouse.animation.play('click');
				}
			} else {
				if (mouse.animation.curAnim.name != 'normal') {
					mouse.animation.play('normal');
				}
			}

			// Use screenX and screenY to prevent the mouse jittering from the moving camera.
			mouse.setPosition(FlxG.mouse.screenX, FlxG.mouse.screenY);
			checkForMouse();
		}
		super.update(elapsed);
	}

	override function beatHit() {
		// Checks every beat to see if we have a skip in the queue
		if (queuedSkip && !introCompleted) {
			switchToMenu();
			queuedSkip = false;
		}
		super.beatHit();
	}

	override function stepHit() {
		// I'm not using the onEnded callback for this bc it crashes the game
		if (curStep == 126 && !introCompleted) {
			switchToMenu();
		}
		super.stepHit();
	}

	function switchToMenu() {

		if (!introCompleted) {
			FlxG.sound.playMusic(Paths.music('menu/mado_menu_loop'));
			FlxG.camera.flash(FlxColor.WHITE, 1.3);

			// This is a hack for the way hxvlc works since video.destroy() doesnt work when a video isnt playing.
			if (video != null) {
				video.pause();

				if (queuedSkip)
					video.destroy();
				else
					remove(video);

				video = null;
			}
		}

		introCompleted = true;
		mouseEnabled = true;

		add(table);
		add(logo);
		add(buttons);
		add(mouseTracker);
		add(mouse);
	}

	function checkForMouse() {
		if (!mouseEnabled)
			return;

		buttons.forEach(function(button:FlxSprite) {
			if (FlxG.overlap(button, mouse)) {
				if (mouse.animation.curAnim.name == 'normal') {
					mouse.animation.play('hover');
				}

				if (FlxG.mouse.justPressed) {
					// mouseEnabled = false;
					switch (buttonIDs[button.ID]) {
						case 'mado':
							var black = new FlxSprite().makeGraphic(Std.int(FlxG.width * 1.5), Std.int(FlxG.height * 1.5), FlxColor.BLACK);
							black.screenCenter();
							black.alpha = 0;
							add(black);
							FlxG.sound.music.fadeOut(0.8, 0);
							FlxTween.tween(black, {alpha: 1}, 0.8, {onComplete: (t)->{
								var songLowercase:String = Paths.formatToSongPath("snooze");
								var poop:String = backend.Highscore.formatSong(songLowercase, 1);

								PlayState.SONG = backend.Song.loadFromJson(poop, songLowercase);
								PlayState.isStoryMode = false;
								PlayState.storyDifficulty = 1;
								FlxTransitionableState.skipNextTransIn = true;
								LoadingState.loadAndSwitchState(new PlayState());
							}});
						case 'options':
							MadoModSettings.isPlayState = false;
							MusicBeatState.switchState(new options.MadoModSettings());
						case 'credits':
							MusicBeatState.switchState(new states.CreditsState());
					}
				}
			}
		});
	}
}
