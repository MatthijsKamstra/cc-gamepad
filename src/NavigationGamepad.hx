import js.html.NodeList;
import js.html.Element;
import CCGamepad.JoystickObj;
import js.Browser.*;
import js.html.GamepadButton;

using StringTools;

class NavigationGamepad {
	var current = 0;
	var focusable:NodeList;

	public function new() {
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${App.NAME} NavigationGamepad :: build: ${App.getBuildDate()}');
			init();
		});
	}

	function init() {
		focusable = document.querySelectorAll('button, a[href], input, select, textarea, [tabindex]:not([tabindex="-1"])');

		console.log(focusable);

		var gamePad = new SNES();
		gamePad.setup();
		// gamePad.onSelectOnce(onSelectHandler); // specific type, just press once
		gamePad.onStartOnce(onStartHandler); // specific type, just press once
		// gamePad.onLeftBottomOnce(onLeftBottomHandler); // specific type, just press once
		// gamePad.onRightBottomOnce(onRightBottomHandler); // specific type, just press once
		// // gamePad.onButton(onButton); // all other button, just fire as much as possible
		// gamePad.onButtonOnce(CCGamepad.BUTTON_B, onButtonB); // all other button, just fire as much as possible
		// gamePad.onAxis(onAxis); // all other button, just fire as much as possible
	}

	// ____________________________________ Handlers ____________________________________

	function onButtonB(e) {
		console.log('onSelectHandler: ', e);
		clickItem(current);
	}

	function onStartHandler(e) {
		console.log('onStartHandler: ', e);
		clickItem(current);
	}

	function onLeftBottomHandler(e) {
		console.log('onLeftBottomHandler: ', e);
		prevItem(current);
	}

	function onRightBottomHandler(e) {
		console.log('onRightBottomHandler: ', e);
		nextItem(current);
	}

	// ____________________________________ page controle ____________________________________

	function nextItem(index) {
		index++;
		current = index % focusable.length;

		if (current >= focusable.length)
			current = 0;

		cast(focusable[current], Element).focus();
		console.log(cast(focusable[current], Element).textContent);
	}

	function prevItem(index) {
		index--;
		current = index % focusable.length;

		if (current < 0)
			current = focusable.length - 1;

		cast(focusable[current], Element).focus();
		console.log(cast(focusable[current], Element).textContent);
	}

	function clickItem(index) {
		if (cast(focusable[index], Element) != null) {
			cast(focusable[index], Element).click();
		}
	}

	static public function main() {
		var app = new NavigationGamepad();
	}
}
