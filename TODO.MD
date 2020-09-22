# TODO

> a journey of a thousand miles begins with a single step

```haxe
pad.A;
pad.B;
pad.X;
pad.Y;
pad.LEFT_SHOULDER_0;
pad.RIGHT_SHOULDER_0;
pad.LEFT_SHOULDER_1;
pad.RIGHT_SHOULDER_1;
pad.SELECT;

pad.START;
pad.LEFT_STICK_BUTTON;
pad.LEFT_STICK_BUTTON;
pad.UP;
pad.DOWN;
pad.LEFT;
pad.RIGHT;
pad.LEFT_STICK_X;
pad.LEFT_STICK_Y;
pad.RIGHT_STICK_X;
pad.RIGHT_STICK_Y;

"GAMEPAD_KEY_U": 0, // up
"GAMEPAD_KEY_R": 1, // right
"GAMEPAD_KEY_D": 2, // down
"GAMEPAD_KEY_L": 3, // left
// --- DIGITAL ---
"GAMEPAD_KEY_A": 4,
"GAMEPAD_KEY_B": 5,
"GAMEPAD_KEY_C": 6,
"GAMEPAD_KEY_X": 7,
"GAMEPAD_KEY_Y": 8,
"GAMEPAD_KEY_Z": 9,
"GAMEPAD_KEY_L1": 10,
"GAMEPAD_KEY_R1": 11,
"GAMEPAD_KEY_L3": 12,
"GAMEPAD_KEY_R3": 13,
"GAMEPAD_KEY_S1": 14, // select
"GAMEPAD_KEY_S2": 15, // start
// --- ANALOG ---
"GAMEPAD_KEY_LX": 16,
"GAMEPAD_KEY_LY": 17,
"GAMEPAD_KEY_RX": 18,
"GAMEPAD_KEY_RY": 19,
"GAMEPAD_KEY_L2": 20,
"GAMEPAD_KEY_R2": 21,

Events
connected

pad.on('connected', function(evt) { console.log(evt); });
// {"index":0,"timestamp":1338874409909,"type":"connected"}

disconnected

pad.on('disconnected', function(evt) { console.log(evt); });
// {"timestamp":1338874409909,"type":"disconnected"}

axismove

pad.on('axismove', function(evt) { console.log(evt); });
// {"button":"RIGHT_STICK_X","timestamp":1338874409909,
// "type":"axismove","value":0.003921627998352051}

buttondown

pad.on('buttondown', function(evt) { console.log(evt); });
// {"button":"A","timestamp":1338873574415,"type":"buttondown"}

buttonup

pad.on('buttonup', function(evt) { console.log(evt); });
// {"button":"A","timestamp":1338873574415,"type":"buttonup"}
```
