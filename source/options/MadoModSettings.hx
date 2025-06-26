package options;

import options.Option;
import flxanimate.data.AnimationData.OneOfTwo;
import objects.BackToMenu;


typedef OptionStuff = OneOfTwo<Option, Dynamic>; 
/**
 * I re-did the options menu to have a small amount of stuff
 * I hate this.
 */
class MadoModSettings extends MusicBeatState {

	var optionSprites:FlxSpriteGroup;
	var optionList:Array<Option> = [];

	var currentNum:Int;
	var currentOption:OptionStuff = null;

	var fpsText:FlxText;
	var backToMenu:BackToMenu;
	var topArrow:FlxSprite;
	var bottomArrow:FlxSprite;
	static var seenFramerateText:Bool = false;

	public static var isPlayState:Bool = false;

	var mouse:FlxSprite;

	override function create() {
		super.create();

		var bg = new FlxSprite(0,0).loadGraphic(Paths.image('options/options_bg'));
		add(bg);

		optionSprites = new FlxSpriteGroup();
		add(optionSprites);


		fpsText = new FlxText(0, 0, FlxG.width, '### FPS');
		fpsText.setFormat(Paths.font('rpg.ttf'), 16, FlxColor.WHITE, CENTER);
		fpsText.alpha = 0;
		add(fpsText);

		addOption({
			name: 'Set Keybinds',
			type: 'keybindSetting',
			getValue: ()->{
				return true;
			}
		});

		var option:Option = new Option('Downscroll',
			'If checked, notes go Down instead of Up, simple enough.',
			'downScroll', 
			'bool');
		addOption(option);

		var option:Option = new Option('Flashing Lights', "",
			'flashing', 'bool');
		addOption(option);

		var option:Option = new Option('Framerate', "",
			'framerate', 'int');
		addOption(option);
		final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
		option.minValue = 60;
		option.maxValue = 240;
		option.defaultValue = Std.int(FlxMath.bound(refreshRate, option.minValue, option.maxValue));
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;

		var option:Option = new Option('Show FPS', "",
			'showFPS', 'bool');
		option.onChange = onChangeFPSCounter;
		addOption(option);


		var option:Option = new Option('GPU Caching', "",
			'cacheOnGPU', 'bool');
		addOption(option);

		var option:Option = new Option('Ghost Tapping', "If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping', 'bool');
		addOption(option);

		var option:Option = new Option('Sustains as One Note',
			"If checked, Hold Notes can't be pressed if you miss,\nand count as a single Hit/Miss.\nUncheck this if you prefer the old Input System.",
			'guitarHeroSustains', 'bool');
		addOption(option);

		updateSelection();

		backToMenu = new BackToMenu(30, 30);
		backToMenu.isToPlayState = isPlayState;
		add(backToMenu);

		topArrow = new FlxSprite(45,0);
		topArrow.angle = 90;
		topArrow.frames = Paths.getSparrowAtlas('credits/arrow');
		topArrow.animation.addByPrefix('idle', 'button');
		topArrow.animation.addByPrefix('select', 'select');
		topArrow.animation.play('idle');
		topArrow.screenCenter(Y);
		topArrow.y -= 50;
		add(topArrow);

		bottomArrow = new FlxSprite(45,0);
		bottomArrow.angle = 270;
		bottomArrow.frames = Paths.getSparrowAtlas('credits/arrow');
		bottomArrow.animation.addByPrefix('idle', 'button');
		bottomArrow.animation.addByPrefix('select', 'select');
		bottomArrow.animation.play('idle');
		bottomArrow.screenCenter(Y);
		bottomArrow.y += 50;
		add(bottomArrow);

		mouse = new FlxSprite(0, 0);
		mouse.frames = Paths.getSparrowAtlas('mainmenu/cursor');
		mouse.animation.addByPrefix('normal', 'cursor_normal');
		mouse.animation.addByPrefix('click', 'cursor_click');
		mouse.animation.addByPrefix('hover', 'cursor_select');
		mouse.animation.play('normal');
		add(mouse);

		var tipText = new FlxText(0, 20, FlxG.width, "Click anywhere on the screen to change the setting!");
		tipText.screenCenter(X);
		tipText.setFormat(Paths.font('rpg.ttf'), 40, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		tipText.borderSize = 3;
		add(tipText);
		FlxTween.tween(tipText, {alpha: 0}, 1.6, {ease: FlxEase.cubeOut, startDelay: 2});
	}

	function addOption(option:OptionStuff) {
		optionList.push(option);
	
		var text = new FlxText(0, 0, FlxG.width, option.name, 65);
		text.setFormat(Paths.font('rpg.ttf'), 65, FlxColor.fromString((option.type == 'int' || option.getValue()) ? '0xFFFFFF' : '0x434343'), CENTER, OUTLINE, FlxColor.BLACK);
		text.updateHitbox();
		optionSprites.add(text);
	}

	function updateSelection(addAmt:Int = 0) {
		currentNum += addAmt;
		if (currentNum >= optionList.length) currentNum = 0;
		if (currentNum < 0) currentNum = optionList.length - 1;

		currentOption = optionList[currentNum];

		if (currentOption.name == 'Framerate') {
			var spr = optionSprites.members[currentNum];
			fpsText.screenCenter(XY);
			fpsText.text = Std.string(currentOption.getValue()) + ' FPS';
			fpsText.y += spr.height / 1.8;
			fpsText.alpha = 1;

			if (!seenFramerateText) {
				seenFramerateText = true;
				var tipText = new FlxText(0, 45, FlxG.width, "Use your left/right UI Bind to change this setting.");
				tipText.screenCenter(X);
				tipText.setFormat(Paths.font('rpg.ttf'), 40, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
				tipText.borderSize = 3;
				add(tipText);
				FlxTween.tween(tipText, {alpha: 0}, 1.6, {ease: FlxEase.cubeOut, startDelay: 2});
			}
		} 
		else {
			fpsText.alpha = 0;
		}

		for (text in optionSprites.members) {
			var idx = optionSprites.members.indexOf(text);
			text.screenCenter(X);
			text.alpha = (idx == currentNum) ? 1 : 0.5;
			var centeredIndex = idx - currentNum;
			var centerOffset = FlxG.height / 2 - text.height / 2;
			var targetY = centerOffset + (centeredIndex * (text.height + 20));
			text.y = targetY;
		}
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}

	function onChangeFPSCounter() {
		if (Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}

	var holdTick = 0.05;
	override function update(elapsed:Float) {
		holdTick += elapsed;

		if ((controls.UI_LEFT || controls.UI_RIGHT) && currentOption.type == 'int' && holdTick >= 0.05) {
			holdTick = 0;
			var add = controls.UI_LEFT ? -currentOption.changeValue : currentOption.changeValue;

			var holdValue = Std.int(FlxMath.bound(currentOption.getValue() + add, currentOption.minValue, currentOption.maxValue));
			currentOption.setValue(holdValue);
			currentOption.change();
			fpsText.text = Std.string(currentOption.getValue()) + ' FPS';
		}

		if (mouse != null) {
			if (FlxG.mouse.pressed) {
				if (mouse.animation.curAnim.name != 'click') {
					mouse.animation.play('click');
				}
			} else {
				if (mouse.animation.curAnim.name != 'normal') {
					mouse.animation.play('normal');
				}
			}
			mouse.setPosition(FlxG.mouse.screenX, FlxG.mouse.screenY);
			checkMouse();
		}

		super.update(elapsed);
	}

	function checkMouse() {
		var isHoveringBack = FlxG.overlap(mouse, backToMenu);
		var isHoveringUp = FlxG.overlap(mouse, topArrow);
		var isHoveringDown = FlxG.overlap(mouse, bottomArrow);
		var canClick = !isHoveringBack && !isHoveringUp && !isHoveringDown;
		backToMenu.toggleHover(isHoveringBack);
		if (isHoveringBack) {
			mouse.animation.play('hover');
			if (FlxG.mouse.justPressed) backToMenu.click();
		}
		if (isHoveringUp) {
			mouse.animation.play('hover');
			if (FlxG.mouse.justPressed) updateSelection(-1);
		}
		if (isHoveringDown) {
			mouse.animation.play('hover');
			if (FlxG.mouse.justPressed) updateSelection(1);
		}

		if (canClick && FlxG.mouse.justPressed && currentOption.type != 'int')
			toggleBool();
	}

	function toggleBool() {
		if (currentOption.type == 'bool') {
			currentOption.setValue(!currentOption.getValue());
			currentOption.change();
			optionSprites.members[currentNum].color = FlxColor.fromString(currentOption.getValue() ? '0xFFFFFF' : '0x434343');
		} else if (currentOption.type == 'keybindSetting') {
			openSubState(new options.ControlsSubState());
		}
	}

	override function destroy() {
		ClientPrefs.saveSettings();
		super.destroy();
	}
}
