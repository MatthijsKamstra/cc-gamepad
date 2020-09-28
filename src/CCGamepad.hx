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
	var isWarning:Bool = true; // warning before use
	var isVisualizer:Bool = false; // visualize the buttons (usefull to map the values of the controller)

	// pad (up/down/left/right) -> probably always needed!
	var onAxisFunc:Function;
	// other buttons, must be set individually
	var buttonActionArray:Array<Action> = [];

	// for visuals
	var btnMap:Map<Int, SpanElement> = [];
	var axisMap:Map<Int, ProgressElement> = [];
	var btnNameField:DivElement;

	// kill animation frame
	var requestID:Int; // requestAnimationFrame
	// remember previous button
	var previousButtonID:Int = null;

	// private var _options:SettingsObject = cast {};
	// axis x-dir and y-dir
	// [mck] this is probably a very bad idea...
	public static final AXIS_RIGHT = "{x:1,y:0}";
	public static final AXIS_LEFT = "{x:-1,y:0}";
	public static final AXIS_DOWN = "{x:0,y:1}";
	public static final AXIS_UP = "{x:0,y:-1}";
	public static final AXIS_DOWN_RIGHT = "{x:1,y:1}";
	public static final AXIS_DOWN_LEFT = "{x:-1,y:1}";
	public static final AXIS_UP_RIGHT = "{x:1,y:-1}";
	public static final AXIS_UP_LEFT = "{x:-1,y:-1}";
	public static final AXIS_CENTER = "{x:0,y:0}";
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
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${App.NAME} Dom ready :: build: ${App.getBuildDate()}');
			init();
		});
	}

	// ____________________________________ public  ____________________________________

	/**
	 * setup Gamepad,
	 * @param isVisualizer  	use a controller visualizer to (default: false)
	 * @param isWarning			use a warning before activating (default: true)
	 */
	public function setup(?isVisualizer:Bool = false, ?isWarning:Bool = true) {
		this.isVisualizer = isVisualizer;
		this.isWarning = isWarning;
		init();
	}

	public function setVisualizer(isVisualizer:Bool = false) {
		this.isVisualizer = isVisualizer;
	}

	public function setWarning(isWarning:Bool = true) {
		this.isWarning = isWarning;
	}

	// ____________________________________ buttons ____________________________________

	/**
	 * [Description]
	 * @param buttonID
	 * @param func
	 * @param isTriggeredOnce
	 */
	public function onButton(buttonID:Int, func:Function, ?isTriggeredOnce:Bool = false) {
		var action:Action = new Action(func, isTriggeredOnce);
		action.id = buttonID;
		action.description = BUTTON_MAP.get(buttonID);
		buttonActionArray.push(action);
	}

	// syntatic sugar for the previous function
	public function onButtonOnce(buttonID:Int, func:Function) {
		onButton(buttonID, func, true);
	}

	// ____________________________________ specific buttons ____________________________________

	/**
	 * Press select button
	 * @param func 				onActivated trigger function
	 * @param isTriggeredOnce 	(default: false) want to call it every fps or just once
	 */
	public function onSelect(func:Function, ?isTriggeredOnce:Bool = false) {
		var action:Action = new Action(func, isTriggeredOnce);
		action.id = BUTTON_SELECT;
		buttonActionArray.push(action);
	}

	// syntatic sugar for the previous function
	public function onSelectOnce(func:Function) {
		onSelect(func, true);
	}

	/**
	 * Press start button
	 * @param func 				onActivated trigger function
	 * @param isTriggeredOnce 	(default: false) want to call it every fps or just once
	 */
	public function onStart(func:Function, ?isTriggeredOnce:Bool = false) {
		var action:Action = new Action(func, isTriggeredOnce);
		action.id = BUTTON_START;
		buttonActionArray.push(action);
	}

	// syntatic sugar for the previous function
	public function onStartOnce(func:Function) {
		onStart(func, true);
	}

	/**
	 * Press select button
	 * @param func 				onActivated trigger function
	 * @param isTriggeredOnce 	(default: false) want to call it every fps or just once
	 */
	public function onLeftBottom(func:Function, ?isTriggeredOnce:Bool = false) {
		var action:Action = new Action(func, isTriggeredOnce);
		action.id = BUTTON_LEFT_BOTTOM;
		buttonActionArray.push(action);
	}

	// syntatic sugar for the previous function
	public function onLeftBottomOnce(func:Function) {
		onLeftBottom(func, true);
	}

	/**
	 * Press select button
	 * @param func 				onActivated trigger function
	 * @param isTriggeredOnce 	(default: false) want to call it every fps or just once
	 */
	public function onRightBottom(func:Function, ?isTriggeredOnce:Bool = false) {
		var action:Action = new Action(func, isTriggeredOnce);
		action.id = BUTTON_RIGHT_BOTTOM;
		buttonActionArray.push(action);
	}

	// syntatic sugar for the previous function
	public function onRightBottomOnce(func:Function) {
		onRightBottom(func, true);
	}

	// ____________________________________ axis ____________________________________

	public function onAxis(func:Function) {
		onAxisFunc = func;
	}

	// ____________________________________ init ____________________________________

	function init() {
		if (this.isWarning)
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

		containerDiv.onclick = (e) -> {
			// console.log(e);
			containerDiv.style.display = "none";
		}
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

		document.body.appendChild(d);

		var heart = document.createSpanElement();
		heart.id = 'heart';
		heart.textContent = '❤';
		var w = document.body.clientWidth;
		var h = document.body.clientHeight;
		heart.setAttribute('style', 'display: block;position: absolute;top: ${h / 2}px;left: ${w / 2}px;');
		document.body.appendChild(heart);

		// console.warn('TODO: remove this element better (click example)');
		// d.style.display = "none";
	}

	// ____________________________________ gamepad handlers ____________________________________

	function onGamepadConnectedHandler(e:GamepadEvent) {
		// Gamepad connected
		console.log("Gamepad connected", e.gamepad);

		// show visualizer
		if (this.isVisualizer)
			setupInterface();

		// hide warning if needed
		var warningDiv = document.getElementById("gamepad-warning");
		if (warningDiv != null) {
			warningDiv.style.display = "none";
		}

		// force the focus on the body
		document.body.focus();

		// start game loop
		gameLoop();
	}

	function onGamepadDisconnectedHandler(e:GamepadEvent) {
		// Gamepad disconnected
		console.log("Gamepad disconnected", e.gamepad);
		window.cancelAnimationFrame(requestID);
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
		var gamepad = navigator.getGamepads()[0];

		if (isVisualizer) {
			for (el in btnMap) {
				el.classList.remove('pressed');
			}
		}

		// reset previous value if button is released
		if (previousButtonID != null && !gamepad.buttons[previousButtonID].pressed) {
			// [mck] also buttonUp actions
			previousButtonID = null;
		}

		for (i in 0...gamepad.buttons.length) {
			var currentButton:GamepadButton = gamepad.buttons[i];

			if (currentButton.pressed) {
				// update visualizer
				if (isVisualizer) {
					var el = btnMap.get(i);
					el.classList.add('pressed');
					// show "description" of button
					btnNameField.innerText = BUTTON_MAP.get(i);
				}

				for (j in 0...buttonActionArray.length) {
					var _action = buttonActionArray[j];
					if (_action.id == i) {
						_action.gamepadButton = currentButton;
						_action.timestamp = Date.now().getTime();
						if (_action.isOnce == true && previousButtonID != i) {
							Reflect.callMethod(_action.func, _action.func, [_action]);
						} else if (_action.isOnce == false) {
							Reflect.callMethod(_action.func, _action.func, [_action]);
						}
					}
				}

				previousButtonID = i;
			}
		}

		for (i in 0...gamepad.axes.length) {
			var joystickX = applyDeadzone(gamepad.axes[gamepad.axes.length - 2], 0.25);
			var joystickY = applyDeadzone(gamepad.axes[gamepad.axes.length - 1], 0.25);
			var joystickStr = '{x:${joystickX},y:${joystickY}}';
			var joystickObj:JoystickObj = {
				x: joystickX,
				y: joystickY,
				desc: AXIS_MAP.get(joystickStr)
			}
			if (isVisualizer) {
				var axes = document.getElementsByClassName("axis");
				var a = axes[i];
				// a.innerHTML = i + ": " + Syntax.code("(controller.axes[i]).toFixed(4)");
				a.innerHTML = i + ": " + gamepad.axes[i];
				a.setAttribute("value", Std.string(gamepad.axes[i] + 1));
				// console.log(gamepad.axes[i]);
				if (joystickX == 0 && joystickY == 0) {
					// what? don't use the joystick
				} else {
					btnNameField.innerText = AXIS_MAP.get(joystickStr);
				}

				var heart = document.getElementById('heart');
				heart.style.left = (Std.parseInt(heart.style.left) + joystickX) + 'px';
				heart.style.top = (Std.parseInt(heart.style.top) + joystickY) + 'px';
			}

			if (onAxisFunc != null) {
				if (joystickX != 0 || joystickY != 0) {
					var _func = onAxisFunc;
					var _arr = [joystickObj];
					Reflect.callMethod(_func, _func, _arr);
				}
			}
		}
		requestID = window.requestAnimationFrame(gameLoop);
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

typedef JoystickObj = {
	@:optional var desc:String;
	var x:Float;
	var y:Float;
}

class Action {
	// nummerical value of the button
	@:isVar public var id(get, set):Int;
	// only used when buttons
	@:isVar public var gamepadButton(get, set):GamepadButton;
	// timestamp
	@:isVar public var timestamp(get, set):Float;
	// description (currently only set by button)
	@:isVar public var description(get, set):String;

	public var func:Function;
	public var isOnce:Bool = false; // default trigger often 60fps

	public function new(func:Function, ?isOnce = false) {
		this.func = func;
		this.isOnce = isOnce;
	}

	// ____________________________________ getter/setter ____________________________________
	function get_id():Int {
		return id;
	}

	function set_id(value:Int):Int {
		return id = value;
	}

	function get_gamepadButton():GamepadButton {
		return gamepadButton;
	}

	function set_gamepadButton(value:GamepadButton):GamepadButton {
		return gamepadButton = value;
	}

	function get_timestamp():Float {
		return timestamp;
	}

	function set_timestamp(value:Float):Float {
		return timestamp = value;
	}

	function get_description():String {
		return description;
	}

	function set_description(value:String):String {
		return description = value;
	}
}
