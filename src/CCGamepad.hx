package;

import js.html.SpanElement;
import haxe.Json;
import js.html.ProgressElement;
import js.html.Element;
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
import js.html.DivElement;

using StringTools;

// https://developer.mozilla.org/en-US/docs/Web/API/Gamepad_API/Using_the_Gamepad_API
// https://github.com/luser/gamepadtest/blob/master/gamepadtest.js
// checked in firefox and Chrome.. the rest I don't use
class CCGamepad {
	var controllers:Array<Gamepad> = []; // {};
	var map:Map<Int, GamePadObject> = new Map();
	var start:Dynamic;
	var gamePads:Array<Gamepad>;
	var gamepad:Gamepad; // 0

	var btnNameField:DivElement;

	public function new() {
		// trace('START :: CCGamepad');
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${model.constants.App.NAME} Dom ready :: build: ${model.constants.App.getBuildDate()}');
			init();
		});
	}

	function init() {
		setupStart();
		setupListeners();
	}

	// ____________________________________ setup ____________________________________

	function setupStart() {
		var div = document.createDivElement();
		div.id = 'start-screen';
		div.className = "container";
		div.innerHTML = '<h2>No gamepad detected</h2><p>If you have one, make sure it\'s plugged in / paired, and press buttons to wake it up.</p>';
		document.body.appendChild(div);
	}

	function setupListeners() {
		window.addEventListener("gamepadconnected", onGamepadConnectedHandler);
		window.addEventListener("gamepaddisconnected", onGamepadDisconnectedHandler);
		// might only work in Firefox
		window.addEventListener("gamepadbuttondown", onGamepadButtonDownHandler);
		window.addEventListener("gamepadbuttonup", onGamepadButtonUpHandler);
		window.addEventListener("gamepadaxismove", onGamepadAxisMoveHandler);
	}

	function setupControllerValues() {
		var btnMap:Map<Int, String> = [];
		btnMap.set(0, 'X');
		btnMap.set(1, 'A');
		btnMap.set(2, 'B');
		btnMap.set(3, 'Y');
		btnMap.set(4, 'Left Bottom');
		btnMap.set(5, 'Right Bottom');
		btnMap.set(6, '');
		btnMap.set(7, '');
		btnMap.set(8, 'Select');
		btnMap.set(9, 'Start');
		var _GamePadObject:GamePadObject = {
			_id: gamepad.id,
			alias: 'fake super nintendo controller (snes)',
			gamepad: gamepad,
			buttonMap: btnMap
		};
		map.set(0, _GamePadObject);
	}

	var btnMap:Map<Int, SpanElement> = [];
	var axisMap:Map<Int, ProgressElement> = [];

	function setupInterface() {
		var btnArray = gamepad.buttons;
		var axixArray = gamepad.axes;

		var d = document.createDivElement();
		d.className = 'container';
		d.setAttribute("id", "controller" + gamepad.index);

		var t = document.createElement("h1");
		t.appendChild(document.createTextNode("gamepad: " + gamepad.id));
		d.appendChild(t);

		var t = document.createDivElement();
		t.id = "name-button";
		d.appendChild(t);

		btnNameField = t;

		var b = document.createDivElement();
		b.className = "buttons";
		for (i in 0...gamepad.buttons.length) {
			var e = document.createSpanElement();
			e.className = "button";
			// e.id = "b" + i;
			e.innerHTML = Std.string(i);
			b.appendChild(e);

			btnMap.set(i, e);
		}
		d.appendChild(b);

		var a = document.createDivElement();
		a.className = "axes";
		for (i in 0...gamepad.axes.length) {
			var p = document.createProgressElement();
			p.className = "axis";
			// p.id = "a" + i;
			p.setAttribute("max", "2");
			p.setAttribute("value", "1");
			p.innerHTML = Std.string(i);
			a.appendChild(p);

			axisMap.set(i, p);
		}
		d.appendChild(a);

		var pre = document.createPreElement();
		pre.innerText = '- id: ${gamepad.id} \n- connected: ${gamepad.connected}\n- index: ${gamepad.index}';
		d.appendChild(pre);

		var start = document.getElementById("start-screen");
		if (start != null) {
			start.style.display = "none";
		}

		document.body.appendChild(d);
	}

	// ____________________________________ handlers ____________________________________
	function onGamepadConnectedHandler(e:GamepadEvent) {
		// Gamepad connected
		console.log("Gamepad connected", e.gamepad);

		gamePads = navigator.getGamepads();
		console.log(gamePads);

		gamepad = navigator.getGamepads()[0];
		console.log(gamepad);

		setupControllerValues();
		setupInterface();

		// gameLoop();
		timeoutVariable = window.setInterval(gameLoop, 500);
	}

	var timeoutVariable:Int;

	function onGamepadDisconnectedHandler(e:GamepadEvent) {
		// Gamepad disconnected
		console.log("Gamepad disconnected", e.gamepad);
		// removegamepad(e.gamepad);
		window.cancelAnimationFrame(start);
		window.clearTimeout(timeoutVariable);
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
		// Gamepad axis move
		console.log("Gamepad axis move", e.button, e.gamepad);
	}

	// ____________________________________ gameLoop____________________________________

	function gameLoop(?value) {
		trace('');
		for (el in btnMap) {
			el.classList.remove('pressed');
		}

		// trace(gamepad.buttons.length);

		for (i in 0...gamepad.buttons.length) {
			var _button:GamepadButton = gamepad.buttons[i];
			// console.log(_button);
			if (_button.pressed) {
				var el = btnMap.get(i);
				el.classList.add('pressed');
				var _gamePadObject = map.get(0);
				var temp = _gamePadObject.buttonMap.get(i);
				btnNameField.innerText = temp;
			}
		}

		// start = window.requestAnimationFrame(gameLoop);
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
