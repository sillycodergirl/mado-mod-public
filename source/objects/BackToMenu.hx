package objects;

import states.MainMenuState;

class BackToMenu extends FlxSprite {
	var posX = 0.0;
	var posY = 0.0;

	public var isToPlayState:Bool = false;

	public function new(x, y) {
		super(x, y);

		this.posX = x;
		this.posY = y;

		frames = Paths.getSparrowAtlas('mainmenu/backarrow');
		animation.addByPrefix('idle', 'backbuttonclean', 12);
		animation.addByPrefix('hover', 'backbuttonhighlight', 12);
		animation.play('idle');
	}

	public function toggleHover(doHover:Bool = false) {
		var targetAnim = doHover ? 'hover' : 'idle';
		if (animation.curAnim.name == targetAnim) return;
		
		// hover animation is 20% larger than the non hovered one
		if (doHover) {
			scale.set(0.8, 0.8);
			setPosition(posX - 11.5, posY - 17.5);
		} else {
			scale.set(1, 1);
			setPosition(posX, posY);
		}
		animation.play(targetAnim);
	}

	public function click() {
		if (isToPlayState)
			MusicBeatState.switchState(new PlayState());
		else
			MusicBeatState.switchState(new MainMenuState());
	}
}