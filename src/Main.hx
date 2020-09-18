import CCGamepad.JoystickObj;
import js.Browser.*;
import js.html.GamepadButton;

using StringTools;

class Main {
	public function new() {
		// trace('START :: CCGamepad');
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${model.constants.App.NAME} Setup :: build: ${model.constants.App.getBuildDate()}');
			init();
		});
	}

	function init() {
		var gamePad = new SNES();
		gamePad.setup();
		gamePad.onSelectOnce(onSelectHandler); // specific type, just press once
		gamePad.onStartOnce(onStartHandler); // specific type, just press once
		gamePad.onLeftBottomOnce(onLeftBottomHandler); // specific type, just press once
		gamePad.onRightBottomOnce(onRightBottomHandler); // specific type, just press once
		gamePad.onButton(onButton); // all other button, just fire as much as possible
		gamePad.onButtonOnce(CCGamepad.BUTTON_B, onButtonOnce); // all other button, just fire as much as possible
		gamePad.onAxis(onAxis); // all other button, just fire as much as possible
	}

	function onSelectHandler(e) {
		console.log('onSelectHandler: ', e);
	}

	function onStartHandler(e) {
		console.log('onStartHandler: ', e);
	}

	function onButtonOnce(e) {
		console.log('>> onButtonOnce: ', e);
	}

	function onLeftBottomHandler(e) {
		console.log('onLeftBottomHandler: ', e);
	}

	function onRightBottomHandler(e) {
		console.log('onRightBottomHandler: ', e);
	}

	function onAxis(e:JoystickObj) {
		// console.log('onAxis: ', joystickObj);
		switch (e.desc) {
			case CCGamepad.AXIS_LEFT_DISC:
				console.log('--> ${e.desc}');
			case CCGamepad.AXIS_RIGHT_DISC:
				console.log('--> ${e.desc}');
			case CCGamepad.AXIS_UP_DISC:
				console.log('--> ${e.desc}');
			case CCGamepad.AXIS_DOWN_DISC:
				console.log('--> ${e.desc}');
			case CCGamepad.AXIS_DOWN_RIGHT_DISC:
				console.log('--> ${e.desc}');
			case CCGamepad.AXIS_DOWN_LEFT_DISC:
				console.log('--> ${e.desc}');
			case CCGamepad.AXIS_UP_RIGHT_DISC:
				console.log('--> ${e.desc}');
			case CCGamepad.AXIS_UP_LEFT_DISC:
				console.log('--> ${e.desc}');
			case CCGamepad.AXIS_CENTER_DISC:
				console.log('--> ${e.desc}');

			default:
				trace("case '" + e + "': trace ('" + e + "');");
		}
	}

	function onButton(disc:String) {
		// console.log('onUpdateHandler: ', e);
		switch (disc) {
			case CCGamepad.BUTTON_A_DISC:
				console.log('--> $disc');
			case CCGamepad.BUTTON_B_DISC:
				console.log('--> $disc');
			case CCGamepad.BUTTON_X_DISC:
				console.log('--> $disc');
			case CCGamepad.BUTTON_Y_DISC:
				console.log('--> $disc');
			default:
				trace("case '" + disc + "': trace ('" + disc + "');");
		}
	}

	static public function main() {
		var app = new Main();
	}
}
