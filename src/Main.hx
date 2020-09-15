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
class Main {
	var controllers:Array<Gamepad> = []; // {};
	var map:Map<String, GamePadObject> = new Map();

	public function new() {
		// trace('START :: main');
		document.addEventListener("DOMContentLoaded", function(event) {
			trace('START :: main');

			init();
		});
	}

	function init() {
		window.addEventListener("gamepadconnected", connecthandler);
		window.addEventListener("gamepaddisconnected", disconnecthandler);
	}

	// ____________________________________ handlers ____________________________________

	function disconnecthandler(e:GamepadEvent) {
		// console.log(e);
		removegamepad(e.gamepad);
	}

	function connecthandler(e:GamepadEvent) {
		// console.log(e);
		addgamepad(e.gamepad);
	}

	// ____________________________________ add/remove ____________________________________

	function addgamepad(gamepad:Gamepad) {
		controllers[gamepad.index] = gamepad;

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
		map.set(gamepad.id, _GamePadObject);

		console.log(map.get(gamepad.id));

		console.log(gamepad);
		console.log('"${gamepad.id}"');
		console.log(gamepad.index);
		console.log(gamepad.buttons);
		console.log(gamepad.axes);

		var d = document.createElement("div");
		d.setAttribute("id", "controller" + gamepad.index);

		var t = document.createElement("h1");
		t.appendChild(document.createTextNode("gamepad: " + gamepad.id));
		d.appendChild(t);

		var t = document.createDivElement();
		t.id = "name-button";
		d.appendChild(t);

		var b = document.createElement("div");
		b.className = "buttons";
		for (i in 0...gamepad.buttons.length) {
			var e = document.createElement("span");
			e.className = "button";
			// e.id = "b" + i;
			e.innerHTML = Std.string(i);
			b.appendChild(e);
		}
		d.appendChild(b);

		var a = document.createElement("div");
		a.className = "axes";
		for (i in 0...gamepad.axes.length) {
			var p = document.createElement("progress");
			p.className = "axis";
			// p.id = "a" + i;
			p.setAttribute("max", "2");
			p.setAttribute("value", "1");
			p.innerHTML = Std.string(i);
			a.appendChild(p);
		}
		d.appendChild(a);

		// See https://github.com/luser/gamepadtest/blob/master/index.html
		var start = document.getElementById("start");
		if (start != null) {
			start.style.display = "none";
		}

		document.body.appendChild(d);
		window.requestAnimationFrame(updateStatus);
	}

	function removegamepad(gamepad:Gamepad) {
		var d = document.getElementById("controller" + gamepad.index);
		document.body.removeChild(d);
		controllers.remove(controllers[gamepad.index]);
		// Syntax.code("delete controllers[gamepad.index];");
	}

	function updateStatus(e:Float) {
		var t = document.getElementById("name-button");

		for (j in 0...controllers.length) {
			var controller:Gamepad = controllers[j];
			var _gamePadObject = map.get(controller.id);
			var d = document.getElementById("controller" + j);
			var buttons = d.getElementsByClassName("button");
			for (i in 0...controller.buttons.length) {
				var b = buttons[i];
				var gamebadButton:GamepadButton = controller.buttons[i];
				var pressed = gamebadButton.pressed;
				var val = gamebadButton.value;
				var pct = Math.round(val * 100) + "%";
				b.style.backgroundSize = pct + " " + pct;
				if (pressed) {
					b.className = "button pressed";
					var temp = _gamePadObject.buttonMap.get(i);
					t.innerText = "button name: " + temp;
				} else {
					// t.innerText = "";
					b.className = "button";
				}
			}
			var axes = d.getElementsByClassName("axis");
			for (i in 0...controller.axes.length) {
				var a = axes[i];
				// a.innerHTML = i + ": " + Syntax.code("(controller.axes[i]).toFixed(4)");
				a.innerHTML = i + ": " + controller.axes[i];
				a.setAttribute("value", Std.string(controller.axes[i] + 1));
			}
		}

		window.requestAnimationFrame(updateStatus);
	}

	static public function main() {
		var app = new Main();
	}
}

typedef GamePadObject = {
	@:optional var _id:String;
	var gamepad:Gamepad;
	var alias:String;
	var buttonMap:Map<Int, String>;
}
