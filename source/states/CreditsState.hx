package states;

import objects.BackToMenu;

class CreditsState extends MusicBeatState {

	var table:FlxSprite;
	var doodles:FlxSprite;
	var mouseTracker:FlxSprite;
	var mouse:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var backToMenu:BackToMenu;

	var tipText:FlxText;

	var currentPosition:Int = 0;

	var socialLinks:Array<Array<String>> = [
		["https://www.x.com/IBNVintage", 'https://x.com/UltraWeh'],
		['https://x.com/gdLevelTwelve', 'https://x.com/byzafyre'],
		['https://x.com/sillycodergirl', 'https://x.com/Ari_the_when'],
		['https://x.com/CartoonSpeed', 'https://x.com/themariogal'],
		['https://x.com/TLimbless', '']
	];

	override function create() {
		super.create();

		table = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/table'));
		table.scale.set(0.7, 0.7);
		table.updateHitbox();
		table.screenCenter();
		add(table);

		doodles = new FlxSprite();
		doodles.frames = Paths.getSparrowAtlas('credits/credits');
		for (i in 0...5) {
			doodles.animation.addByPrefix(Std.string(i), 'creditsdoodles$i');
		}
		doodles.animation.play('0');
		doodles.scale.set(0.7, 0.7);
		doodles.updateHitbox();
		doodles.screenCenter();
		doodles.x += 20; //idk why but they're offcentered just a little bit
		doodles.y -= 10;
		add(doodles);

		leftArrow = new FlxSprite(40,0);
		leftArrow.frames = Paths.getSparrowAtlas('credits/arrow');
		leftArrow.animation.addByPrefix('idle', 'button');
		leftArrow.animation.addByPrefix('select', 'select');
		leftArrow.animation.play('idle');
		leftArrow.screenCenter(Y);
		add(leftArrow);

		rightArrow = new FlxSprite(doodles.width + 130,0);
		rightArrow.flipX = true;
		rightArrow.frames = Paths.getSparrowAtlas('credits/arrow');
		rightArrow.animation.addByPrefix('idle', 'button');
		rightArrow.animation.addByPrefix('select', 'select');
		rightArrow.animation.play('idle');
		rightArrow.screenCenter(Y);
		add(rightArrow);

		tipText = new FlxText(0, (doodles.y + doodles.height) + 67, FlxG.width, "Click the page to view the person's social link!");
		tipText.screenCenter(X);
		tipText.setFormat(Paths.font('rpg.ttf'), 40, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		tipText.borderSize = 3;
		add(tipText);
		FlxTween.tween(tipText, {alpha: 0}, 1.6, {ease: FlxEase.cubeOut, startDelay: 7});

		backToMenu = new BackToMenu(5, 5);
		add(backToMenu);

		mouseTracker = new FlxSprite(0, 0);
		mouseTracker.makeGraphic(20, 20, FlxColor.TRANSPARENT);
		add(mouseTracker);

		mouse = new FlxSprite(0, 0);
		mouse.frames = Paths.getSparrowAtlas('mainmenu/cursor');
		mouse.animation.addByPrefix('normal', 'cursor_normal');
		mouse.animation.addByPrefix('click', 'cursor_click');
		mouse.animation.addByPrefix('hover', 'cursor_select');
		mouse.animation.play('normal');
		add(mouse);
	}

	override function update(elapsed:Float) {
		if (controls.BACK) {
			MusicBeatState.switchState(new MainMenuState());
		}

		if (leftArrow != null && leftArrow.animation.curAnim.name == 'idle')
			leftArrow.animation.play('idle');
		if (rightArrow!= null && rightArrow.animation.curAnim.name == 'idle')
			rightArrow.animation.play('idle');

		if (mouseTracker != null) {
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
		if (FlxG.overlap(mouse, backToMenu)){
			backToMenu.toggleHover(true);
			if (FlxG.mouse.justPressed) backToMenu.click();
		} else {
			backToMenu.toggleHover(false);
		}

		if (FlxG.overlap(mouse, leftArrow) ) {
			mouse.animation.play('hover');

			if (FlxG.mouse.justPressed) {
				leftArrow.animation.play('select');
				changePage(-1);
			}
		}

		if (FlxG.overlap(mouse, rightArrow) ) {
			mouse.animation.play('hover');

			if (FlxG.mouse.justPressed) {
				rightArrow.animation.play('select');
				changePage(1);
			}
		}

		if (FlxG.mouse.justPressed) {
			var minX = doodles.x; // very left of doodles
			var maxX = minX + doodles.width; // very right of doodles
			var minY = doodles.y;
			var maxY = minY + doodles.height;

			// do nothing if we're not in that zone
			if (FlxG.mouse.x < minX || FlxG.mouse.x > maxX || FlxG.mouse.y < minY || FlxG.mouse.y > maxY) {
				return;
			}

			var isOnLeft = FlxG.mouse.x < minX + (doodles.width / 2);

			var target = socialLinks[currentPosition][isOnLeft ? 0 : 1];
			if (target.length < 3)
				return;

			CoolUtil.browserLoad(socialLinks[currentPosition][isOnLeft ? 0 : 1]);
		}
	}

	function changePage(amt:Int) {
		currentPosition += amt;

		if (currentPosition >= socialLinks.length) currentPosition = 0;
		if (currentPosition < 0) currentPosition = socialLinks.length - 1;

		FlxG.sound.play(Paths.sound('menu/pageTurn'));

		doodles.animation.play(Std.string(currentPosition), true);
	}
}