package;

import haxe.ds.StringMap;
import js.html.Navigator;
import haxe.ds.ArraySort;
import js.Browser.*;
import js.Browser.navigator;
import svg.*;
import js.Syntax;
import js.html.Gamepad;
import js.html.GamepadButton;
import js.html.GamepadEvent;

using StringTools;

// https://developer.mozilla.org/en-US/docs/Web/API/Gamepad_API/Using_the_Gamepad_API
// https://github.com/luser/gamepadtest/blob/master/gamepadtest.js
// checked in firefox and Chrome.. the rest I don't use
class CCGamepad {
	var controllers:Array<Gamepad> = []; // {};
	var map:Map<String, GamePadObject> = new Map();

	public function new() {
		// trace('START :: CCGamepad');
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${model.constants.App.NAME} Dom ready :: build: ${model.constants.App.getBuildDate()}');

			initSetup();
			init();
		});
	}

	function initSetup() {
		var div = document.createDivElement();
		div.id = 'start-screen';
		div.innerHTML = '<h2>No gamepad detected</h2><p>If you have one, make sure it\'s plugged in / paired, and press buttons to wake it up.</p>';
		document.body.appendChild(div);
	}

	function init() {
		window.addEventListener("gamepadconnected", onGamepadConnectedHandler);
		window.addEventListener("gamepaddisconnected", onGamepadDisconnectedHandler);
		// might only work in Firefox
		window.addEventListener("gamepadbuttondown", onGamepadButtonDownHandler);
		window.addEventListener("gamepadbuttonup", onGamepadButtonUpHandler);
		window.addEventListener("gamepadaxismove", onGamepadAxisMoveHandler);
	}

	// ____________________________________ handlers ____________________________________
	function onGamepadConnectedHandler(e:GamepadEvent) {
		// Gamepad connected
		console.log("Gamepad connected", e.gamepad);
		var gamePads:Array<Gamepad> = navigator.getGamepads();
		console.log(gamePads);

		var gamepad = navigator.getGamepads()[0];
		console.log(gamepad);
	}

	function onGamepadDisconnectedHandler(e:GamepadEvent) {
		// Gamepad disconnected
		console.log("Gamepad disconnected", e.gamepad);
		// removegamepad(e.gamepad);
	}

	function onGamepadButtonDownHandler(e) {
		// Gamepad button down
		console.log("Gamepad button down", e.button, e.gamepad);
	}

	function onGamepadButtonUpHandler(e) {
		// Gamepad button up
		console.log("Gamepad button up", e.button, e.gamepad);
	}

	function onGamepadAxisMoveHandler(e) {
		// Gamepad axis movbe
		console.log("Gamepad axis move", e.button, e.gamepad);
		// removegamepad(e.gamepad);
	}

	/**
	 * var joystickX = applyDeadzone(gamepad.axes[0], 0.25);
	 * @param number
	 * @param threshold
	 */
	function applyDeadzone(number:Float, threshold:Float) {
		var percentage = (Math.abs(number) - threshold) / (1 - threshold);
		if (percentage < 0)
			percentage = 0;
		return percentage * (number > 0 ? 1 : -1);
	}

	static public function main() {
		var app = new CCGamepad();
	}
}

typedef GamePadObject = {
	@:optional var _id:String;
	var gamepad:Gamepad;
	var alias:String;
	var buttonMap:Map<Int, String>;
}
