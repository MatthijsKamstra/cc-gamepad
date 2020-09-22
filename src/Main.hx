import js.html.Gamepad;
import CCGamepad.JoystickObj;
import js.Browser.*;

using StringTools;

class Main {
	public function new() {
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${App.NAME} Setup :: build: ${App.getBuildDate()}');
			init();
		});
	}

	function init() {
		var gamePad = new SNES();
		gamePad.setup(true); // show visualizer
		// gamePad.onSelect(onSelectHandler); // press Select, get triggerted 60 fps
		gamePad.onSelectOnce(onSelectHandler); // press Select, get triggerte once
		// gamePad.onStart(onStartHandler);
		gamePad.onStartOnce(onStartHandler);

		// gamePad.onLeftBottom(onLeftBottomHandler); // fires 60 fps
		gamePad.onLeftBottom(onLeftBottomHandler, true); // only fires once
		gamePad.onRightBottomOnce(onRightBottomHandler); // syntatic sugar

		gamePad.onButton(CCGamepad.BUTTON_B, onButton);
		gamePad.onButtonOnce(CCGamepad.BUTTON_A, onButtonOnce); // all other button, just fire as much as possible

		gamePad.onAxis(onAxis);
	}

	function onSelectHandler(e:CCGamepad.Action) {
		console.log('onSelectHandler: ', e);
	}

	function onStartHandler(e:CCGamepad.Action) {
		console.log('onStartHandler: ', e);
	}

	function onButtonOnce(e:CCGamepad.Action) {
		console.log('>> onButtonOnce: ', e);
	}

	function onLeftBottomHandler(e:CCGamepad.Action) {
		console.log('onLeftBottomHandler: ', e);
	}

	function onRightBottomHandler(e:CCGamepad.Action) {
		console.log('onRightBottomHandler: ', e);
	}

	function onAxis(e:JoystickObj) {
		console.log('onAxis: ', e);
		// switch (e.desc) {
		// 	case CCGamepad.AXIS_LEFT_DISC:
		// 		console.log('--> ${e.desc}');
		// 	case CCGamepad.AXIS_RIGHT_DISC:
		// 		console.log('--> ${e.desc}');
		// 	case CCGamepad.AXIS_UP_DISC:
		// 		console.log('--> ${e.desc}');
		// 	case CCGamepad.AXIS_DOWN_DISC:
		// 		console.log('--> ${e.desc}');
		// 	case CCGamepad.AXIS_DOWN_RIGHT_DISC:
		// 		console.log('--> ${e.desc}');
		// 	case CCGamepad.AXIS_DOWN_LEFT_DISC:
		// 		console.log('--> ${e.desc}');
		// 	case CCGamepad.AXIS_UP_RIGHT_DISC:
		// 		console.log('--> ${e.desc}');
		// 	case CCGamepad.AXIS_UP_LEFT_DISC:
		// 		console.log('--> ${e.desc}');
		// 	case CCGamepad.AXIS_CENTER_DISC:
		// 		console.log('--> ${e.desc}');

		// 	default:
		// 		trace("case '" + e + "': trace ('" + e + "');");
		// }
	}

	function onButton(e:CCGamepad.Action) {
		console.log('onButton: ', e);
		// switch (disc) {
		// 	case CCGamepad.BUTTON_A_DISC:
		// 		console.log('--> $disc');
		// 	case CCGamepad.BUTTON_B_DISC:
		// 		console.log('--> $disc');
		// 	case CCGamepad.BUTTON_X_DISC:
		// 		console.log('--> $disc');
		// 	case CCGamepad.BUTTON_Y_DISC:
		// 		console.log('--> $disc');
		// 	default:
		// 		trace("case '" + disc + "': trace ('" + disc + "');");
		// }
	}

	static public function main() {
		var app = new Main();
	}
}
