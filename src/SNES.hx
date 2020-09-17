import js.Browser.*;

class SNES extends CCGamepad {
	public static final BUTTON_X = 0;
	public static final BUTTON_A = 1;
	public static final BUTTON_B = 2;
	public static final BUTTON_Y = 3;
	public static final BUTTON_LEFT_BOTTOM = 4;
	public static final BUTTON_RIGHT_BOTTOM = 5;
	public static final BUTTON_SELECT = 8;
	public static final BUTTON_START = 9;

	public function new() {
		console.log('${model.constants.App.NAME} SNES :: build: ${model.constants.App.getBuildDate()}');
		super();
	}

	// static public function main() {
	// 	var app = new SNES();
	// }
}
