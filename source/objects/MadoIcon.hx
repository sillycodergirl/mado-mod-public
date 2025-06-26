package objects;

/**
 * Features:
 * Animated
 * 3 Stages (Normal, Win, Lose)
 * Not tracked on health
 */
class MadoIcon extends FlxSprite {

	var char:String = "";
	var isPlayer:Bool = false;
	public var curMood = '';

	public function new(char:String = 'bf', isPlayer:Bool = false) {
		super();

		this.isPlayer = isPlayer;

		makeIcon(char);
	}

	public function makeIcon(name:String) {
		if (name == char)
			return;

		char = name;

		var filePath = 'gameplay_UI/icons/' + char;
		frames = Paths.getSparrowAtlas(filePath);
		makeAnimation('neutral');
		makeAnimation('losing');
		makeAnimation('winning');
		makeAnimation('transition_neutral');
		makeAnimation('transition_losing');
		makeAnimation('transition_winning');
	}

	private function makeAnimation(name:String) {
		if (name == null || name == "")
			return;

		animation.addByPrefix(name, name, 24, false, (char != 'bf' && isPlayer));
	}

	public function changeIconMood(mood:String) {
		if (mood == curMood)
			return;

		curMood = mood;
		if (animation.exists('transition_$mood')) {
			animation.play('transition_' + mood, true);
			animation.finishCallback = (a)->{
				animation.finishCallback = (a) -> {}
				animation.play(mood, true);
			};
		} else {
			trace("TRANSITION ANIMATION NOT FOUND FOR " + mood);
			animation.play(mood, true);
		}
	}

	public function getCharacter() {
		return char;
	}
}