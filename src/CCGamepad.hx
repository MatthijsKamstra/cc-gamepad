package;

import haxe.Constraints.Function;
import js.html.SpanElement;
import js.html.ProgressElement;
import js.Browser.*;
import js.Browser.navigator;
import js.html.Gamepad;
import js.html.GamepadButton;
import js.html.GamepadEvent;
import js.html.DivElement;

using StringTools;

// https://developer.mozilla.org/en-US/docs/Web/API/Gamepad_API/Using_the_Gamepad_API
// https://github.com/luser/gamepadtest/blob/master/gamepadtest.js
// checked in firefox and Chrome.. the rest I don't use
class CCGamepad {
	var btnMap:Map<Int, SpanElement> = [];
	var axisMap:Map<Int, ProgressElement> = [];
	var btnNameField:DivElement;
	var start:Int; // requestAnimationFrame

	private var _options:SettingsObject = cast {};

	// axis x-dir and y-dir
	public static final AXIS_RIGHT = "{x:1,y:0}";
	public static final AXIS_LEFT = "{x:-1,y:0}";
	public static final AXIS_DOWN = "{x:0,y:1}";
	public static final AXIS_UP = "{x:0,y:-1}";
	public static final AXIS_DOWN_RIGHT = "{x:1,y:1}";
	public static final AXIS_DOWN_LEFT = "{x:-1,y:1}";
	public static final AXIS_UP_RIGHT = "{x:1,y:-1}";
	public static final AXIS_UP_LEFT = "{x:-1,y:-1}";
	public static final AXIS_CENTER = "{x:0,y:0}";
	// public static final AXIS_RIGHT = {x: 1.0, y: 0.0};
	// public static final AXIS_LEFT = {x: -1.0, y: 0.0};
	// public static final AXIS_DOWN = {x: 0.0, y: 1.0};
	// public static final AXIS_UP = {x: 0.0, y: -1.0};
	// public static final AXIS_DOWN_RIGHT = {x: 1.0, y: 1.0};
	// public static final AXIS_DOWN_LEFT = {x: -1.0, y: 1.0};
	// public static final AXIS_UP_RIGHT = {x: 1.0, y: -1.0};
	// public static final AXIS_UP_LEFT = {x: -1.0, y: -1.0};
	// public static final AXIS_CENTER = {x: 0.0, y: 0.0};
	// axis description
	public static final AXIS_RIGHT_DISC = '→';
	public static final AXIS_LEFT_DISC = '←';
	public static final AXIS_DOWN_DISC = '↓';
	public static final AXIS_UP_DISC = '↑';
	public static final AXIS_DOWN_RIGHT_DISC = '↘';
	public static final AXIS_DOWN_LEFT_DISC = '↙';
	public static final AXIS_UP_RIGHT_DISC = '↗';
	public static final AXIS_UP_LEFT_DISC = '↖';
	public static final AXIS_CENTER_DISC = '×';
	// make it easier to get the description of the button
	public static final AXIS_MAP:Map<String, String> = [
		AXIS_RIGHT => AXIS_RIGHT_DISC,
		AXIS_LEFT => AXIS_LEFT_DISC,
		AXIS_DOWN => AXIS_DOWN_DISC,
		AXIS_UP => AXIS_UP_DISC,
		AXIS_DOWN_RIGHT => AXIS_DOWN_RIGHT_DISC,
		AXIS_DOWN_LEFT => AXIS_DOWN_LEFT_DISC,
		AXIS_UP_RIGHT => AXIS_UP_RIGHT_DISC,
		AXIS_UP_LEFT => AXIS_UP_LEFT_DISC,
		AXIS_CENTER => AXIS_CENTER_DISC,
	];
	// id of the button in the gamepad.button array
	public static final BUTTON_X = 0;
	public static final BUTTON_A = 1;
	public static final BUTTON_B = 2;
	public static final BUTTON_Y = 3;
	public static final BUTTON_LEFT_BOTTOM = 4;
	public static final BUTTON_RIGHT_BOTTOM = 5;
	public static final BUTTON_SELECT = 8;
	public static final BUTTON_START = 9;
	// descriptions in text about the button
	public static final BUTTON_X_DISC = 'X';
	public static final BUTTON_A_DISC = 'A';
	public static final BUTTON_B_DISC = 'B';
	public static final BUTTON_Y_DISC = 'Y';
	public static final BUTTON_LEFT_BOTTOM_DISC = 'Left Bottom';
	public static final BUTTON_RIGHT_BOTTOM_DISC = 'Right Bottom';
	public static final BUTTON_SELECT_DISC = 'Select';
	public static final BUTTON_START_DISC = 'Start';
	// make it easier to get the description of the button
	public static final BUTTON_MAP:Map<Int, String> = [
		BUTTON_X => BUTTON_X_DISC,
		BUTTON_A => BUTTON_A_DISC,
		BUTTON_B => BUTTON_B_DISC,
		BUTTON_Y => BUTTON_Y_DISC,
		BUTTON_LEFT_BOTTOM => BUTTON_LEFT_BOTTOM_DISC,
		BUTTON_RIGHT_BOTTOM => BUTTON_RIGHT_BOTTOM_DISC,
		BUTTON_SELECT => BUTTON_SELECT_DISC,
		BUTTON_START => BUTTON_START_DISC
	];

	public function new() {
		// trace('START :: CCGamepad');
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${model.constants.App.NAME} Dom ready :: build: ${model.constants.App.getBuildDate()}');
			init();
		});
	}

	// ____________________________________ public  ____________________________________

	public function setup() {
		// trace(AXIS_MAP.get("{x:1,y:0}"));

		// for (key in AXIS_MAP.keys()) {
		// 	trace(key, AXIS_MAP.get(key));
		// }
		init();
	}

	public function onButton(func:Function, ?arr:Array<Dynamic>) {
		var action:Action = new Action(func, arr);
		_options.onButton = action;
	}

	public function onButtonOnce(id:Int, func:Function, ?arr:Array<Dynamic>) {
		// trace(BUTTON_MAP.get(id));
		var action:Action = new Action(func, arr, true);
		action.btnid(id);
		_options.onButton = action;
	}

	public function onAxis(func:Function, ?arr:Array<Dynamic>) {
		_options.onAxis = func;
		_options.onAxisParams = arr;
	}

	public function onSelect(func:Function, ?arr:Array<Dynamic>) {
		var action:Action = new Action(func, arr);
		_options.onSelect = action;
	}

	public function onSelectOnce(func:Function, ?arr:Array<Dynamic>) {
		var action:Action = new Action(func, arr, true);
		_options.onSelect = action;
	}

	public function onLeftBottomOnce(func:Function, ?arr:Array<Dynamic>) {
		var action:Action = new Action(func, arr, true);
		_options.onLeftBottom = action;
	}

	public function onRightBottomOnce(func:Function, ?arr:Array<Dynamic>) {
		var action:Action = new Action(func, arr, true);
		_options.onRightBottom = action;
	}

	public function onStart(func:Function, ?arr:Array<Dynamic>) {
		var action:Action = new Action(func, arr);
		_options.onStart = action;
	}

	public function onStartOnce(func:Function, ?arr:Array<Dynamic>) {
		var action:Action = new Action(func, arr, true);
		_options.onStart = action;
	}

	// ____________________________________ init ____________________________________

	function init() {
		setupWarning();
		setupListeners();
	}

	// ____________________________________ setup ____________________________________

	function setupWarning() {
		var containerDiv = document.createDivElement();
		containerDiv.id = 'gamepad-warning';
		containerDiv.setAttribute('style',
			"background-color: rgba(0, 0, 0, 0.3);width: 100vw;height: 100vh;display: flex;justify-content: center;align-items: center;overflow-x: hidden;overflow-y: auto;z-index: 99999999999;position: fixed;top: 0;left: 0;");
		var div = document.createDivElement();
		div.className = "wrapper";
		div.setAttribute('style',
			'background-color: white;width: 300px;text-align: center;border: 1px solid rgba(0, 0, 0, .2);border-radius: .3rem;padding: 1rem 1rem;');
		div.innerHTML = '<i class="fa fa-gamepad fa-5x"></i><h2>No gamepad detected</h2><p>If you have one, make sure it\'s plugged in / paired, and press buttons to wake it up.</p>';
		containerDiv.appendChild(div);
		document.body.appendChild(containerDiv);
	}

	function setupListeners() {
		window.addEventListener("gamepadconnected", onGamepadConnectedHandler);
		window.addEventListener("gamepaddisconnected", onGamepadDisconnectedHandler);
		// might only work in Firefox
		window.addEventListener("gamepadbuttondown", onGamepadButtonDownHandler);
		window.addEventListener("gamepadbuttonup", onGamepadButtonUpHandler);
		window.addEventListener("gamepadaxismove", onGamepadAxisMoveHandler);
	}

	function setupInterface() {
		var gamepad = navigator.getGamepads()[0];

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

		var pre = document.createDivElement();
		pre.innerText = '- index: ${gamepad.index}\n- id: "${gamepad.id}"\n- timestamp: ${gamepad.timestamp}\n- mapping: ${gamepad.mapping}\n- connected: ${gamepad.connected}\n- buttons: ${gamepad.buttons.length}\n- axes: ${gamepad.axes.length}';

		d.appendChild(pre);

		var warningDiv = document.getElementById("gamepad-warning");
		if (warningDiv != null) {
			warningDiv.style.display = "none";
		}

		document.body.appendChild(d);
	}

	// ____________________________________ handlers ____________________________________
	function onGamepadConnectedHandler(e:GamepadEvent) {
		// Gamepad connected
		console.log("Gamepad connected", e.gamepad);

		// setupControllerValues();
		setupInterface();

		gameLoop();
		// timeoutVariable = window.setInterval(gameLoop, 500);
	}

	// var timeoutVariable:Int;

	function onGamepadDisconnectedHandler(e:GamepadEvent) {
		// Gamepad disconnected
		console.log("Gamepad disconnected", e.gamepad);
		// removegamepad(e.gamepad);
		window.cancelAnimationFrame(start);
		// window.clearTimeout(timeoutVariable);
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
	var previousButtonID:Int = null;

	function gameLoop(?value) {
		var gamepad = navigator.getGamepads()[0];
		for (el in btnMap) {
			el.classList.remove('pressed');
		}

		// reset previous value if button is released
		if (previousButtonID != null && !gamepad.buttons[previousButtonID].pressed) {
			previousButtonID = null;
		}

		for (i in 0...gamepad.buttons.length) {
			var currentButton:GamepadButton = gamepad.buttons[i];
			// console.log(currentButton);

			if (currentButton.pressed) {
				var el = btnMap.get(i);
				el.classList.add('pressed');
				// show "description" of button
				btnNameField.innerText = BUTTON_MAP.get(i);
				switch (i) {
					case BUTTON_SELECT:
						if (_options.onSelect != null) {
							var _func = _options.onSelect.func;
							var _arr = (_options.onSelect.arr != null) ? _options.onSelect.arr : [gamepad.timestamp];
							if (_options.onSelect.isOnce == true && previousButtonID != i) {
								Reflect.callMethod(_func, _func, _arr);
							} else if (_options.onSelect.isOnce == false) {
								Reflect.callMethod(_func, _func, _arr);
							}
						}
					case BUTTON_START:
						if (_options.onStart != null) {
							var _func = _options.onStart.func;
							var _arr = (_options.onStart.arr != null) ? _options.onStart.arr : [gamepad.timestamp];
							if (_options.onStart.isOnce == true && previousButtonID != i) {
								Reflect.callMethod(_func, _func, _arr);
							} else if (_options.onStart.isOnce == false) {
								Reflect.callMethod(_func, _func, _arr);
							}
						}
					case BUTTON_RIGHT_BOTTOM:
						if (_options.onRightBottom != null) {
							var _func = _options.onRightBottom.func;
							var _arr = (_options.onRightBottom.arr != null) ? _options.onRightBottom.arr : [gamepad.timestamp];
							if (_options.onRightBottom.isOnce == true && previousButtonID != i) {
								Reflect.callMethod(_func, _func, _arr);
							} else if (_options.onRightBottom.isOnce == false) {
								Reflect.callMethod(_func, _func, _arr);
							}
						}
					case BUTTON_LEFT_BOTTOM:
						if (_options.onLeftBottom != null) {
							var _func = _options.onLeftBottom.func;
							var _arr = (_options.onLeftBottom.arr != null) ? _options.onLeftBottom.arr : [gamepad.timestamp];
							if (_options.onLeftBottom.isOnce == true && previousButtonID != i) {
								Reflect.callMethod(_func, _func, _arr);
							} else if (_options.onLeftBottom.isOnce == false) {
								Reflect.callMethod(_func, _func, _arr);
							}
						}
					default:
						if (_options.onButton != null) {
							var _func = _options.onButton.func;
							var _arr = (_options.onButton.arr != null) ? _options.onButton.arr : [BUTTON_MAP.get(i)];

							// console.log(_options.onButton.id == i);
							// if (_options.onButton.isOnce == true && previousButtonID != i && _options.onButton.id == i) {
							// 	Reflect.callMethod(_func, _func, _arr);
							// } else if (_options.onButton.isOnce == false) {
							// 	Reflect.callMethod(_func, _func, _arr);
							// }

							if (previousButtonID != i && _options.onButton.id == i) {
								Reflect.callMethod(_func, _func, _arr);
							}
						}
				}
				previousButtonID = i;
			}
		}

		var axes = document.getElementsByClassName("axis");
		for (i in 0...gamepad.axes.length) {
			var a = axes[i];
			// a.innerHTML = i + ": " + Syntax.code("(controller.axes[i]).toFixed(4)");
			a.innerHTML = i + ": " + gamepad.axes[i];
			a.setAttribute("value", Std.string(gamepad.axes[i] + 1));

			// console.log(gamepad.axes[i]);
			var joystickX = applyDeadzone(gamepad.axes[gamepad.axes.length - 2], 0.25);
			var joystickY = applyDeadzone(gamepad.axes[gamepad.axes.length - 1], 0.25);

			var joystickStr = '{x:${joystickX},y:${joystickY}}';
			var joystickObj:JoystickObj = {
				x: joystickX,
				y: joystickY,
				desc: AXIS_MAP.get(joystickStr)
			}

			// trace(joystickObj);
			// trace(joystickStr);
			// trace(AXIS_MAP.get(joystickStr));

			if (joystickX == 0 && joystickY == 0) {
				// what? don't use the joystick
			} else {
				btnNameField.innerText = AXIS_MAP.get(joystickStr);
			}

			// if (joystickX == 1)

			// 	btnNameField.innerText = '→';
			// if (joystickX == -1)
			// 	btnNameField.innerText = '←';
			// if (joystickY == 1)
			// 	btnNameField.innerText = '↓';
			// if (joystickY == -1)
			// 	btnNameField.innerText = '↑';
			// if (joystickX == 1 && joystickY == 1)
			// 	btnNameField.innerText = '↘';
			// if (joystickX == 1 && joystickY == -1)
			// 	btnNameField.innerText = '↗';
			// if (joystickX == -1 && joystickY == 1)
			// 	btnNameField.innerText = '↙';
			// if (joystickX == -1 && joystickY == -1)
			// 	btnNameField.innerText = '↖';
			// // if (joystickX == 0 && joystickY == 0)
			// 	btnNameField.innerText = '×';

			// trace('public static final AXIS_OBJ = ${btnNameField.innerText}; // ${joystickObj}');

			// if (joystickZ >= 1 || joystickZ <= -1) {
			// 	btnNameField.innerText = 'migical';
			// }
			if (_options.onAxis != null) {
				if (joystickX != 0 || joystickY != 0) {
					var _func = _options.onAxis;
					var _arr = (_options.onAxisParams != null) ? _options.onAxisParams : [joystickObj];
					Reflect.callMethod(_func, _func, _arr);
				}
			}
		}

		start = window.requestAnimationFrame(gameLoop);
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

typedef JoystickObj = {
	@:optional var desc:String;
	var x:Float;
	var y:Float;
}

typedef SettingsObject = {
	@:optional var _id:String;
	// select
	// @:optional var onSelect:Function;
	// @:optional var onSelectParams:Array<Dynamic>;
	// @:optional var onSelectOnce:Bool;
	@:optional var onSelect:Action;
	// start
	@:optional var onStart:Action;
	// left bottom
	@:optional var onLeftBottom:Action;
	// right bottom
	@:optional var onRightBottom:Action;
	// buttons
	@:optional var onButton:Action;
	// Axis
	@:optional var onAxis:Function;
	@:optional var onAxisParams:Array<Dynamic>;
}

class Action {
	public var func:Function;
	public var arr:Array<Dynamic>;
	public var id:Int;
	public var isOnce:Bool = false; // default trigger often 60fps

	public function new(func:Function, ?arr:Array<Dynamic>, ?isOnce = false) {
		this.func = func;
		this.arr = arr;
		this.isOnce = isOnce;
	}

	public function btnid(id) {
		this.id = id;
	}
}
