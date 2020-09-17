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
		gamePad.onSelect(onSelectHandler);
		gamePad.onStartOnce(onStartHandler);
		gamePad.onUpdate(onUpdateHandler);
	}

	function onSelectHandler(e:GamepadButton) {
		console.log('onSelectHandler: ', e);
	}

	function onStartHandler(e:GamepadButton) {
		console.log('onStartHandler: ', e);
	}

	function onUpdateHandler(e:GamepadButton) {
		console.log('onUpdateHandler: ', e);
	}

	static public function main() {
		var app = new Main();
	}
}
