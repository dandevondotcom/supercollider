s.boot;

/* wave algorithm reference */

// saw wave
(
f = {
        ({arg i;
                var j = i + 1;
                SinOsc.ar(300 * j, 0,  j.reciprocal * 0.5);
        } ! 30).sum // we sum this function 30 times
!2}; // and we make it a stereo signal
)


// square wave
(
f = {
        ({arg i;
                var j = i * 2 + 1; // the odd harmonics (1,3,5,7,etc)
                SinOsc.ar(300 * j, 0, 1/j)
        } ! 20).sum;
};
)

// triangle wave
(
f = {
        ({arg i;
                var j = i * 2 + 1;
                SinOsc.ar(300 * j, pi/2, 0.7/j.squared) // cosine wave (phase shift)
        } ! 20).sum;
};
)

// "bat" wave controlled via mouse X
(
f = {
        ({arg i;
                var j = i * 2.cubed + 1;
		SinOsc.ar(MouseX.kr(200,800) * j/pi, 0, 1/j)
        } ! 20).sum;
};
)

f.plot(name: "bat wave"); // let's plot the wave form
f.play; // listen to it
f.freqscope; // view and listen to it

{ ({ SinOsc.ar(rrand(80, 800), 0, 0.1)} ! 15).sum }.play

// bell sound
(
b = {
Mix.fill( 10, {
    SinOsc.ar(rrand(200, 700), 0, 0.1)
    * EnvGen.ar(Env.perc(0.0001, rrand(2, 6)))
});
}
)
Klang
b.freqscope;

(
SynthDef(\mybell, {arg freq=333, amp=0.4, dur=2, pan=0.0;
    var signal;
    signal = Mix.fill(10, {
		SinOsc.ar(freq+(430.rand), 1.0.rand, 10.reciprocal)
        * EnvGen.ar(Env.perc(0.0001, dur), doneAction:2) }) ;
    signal = Pan2.ar(signal * amp, pan);
    Out.ar(0, signal);
}).add
)
// let's try our bell
Synth(\mybell) // same sound all the time
Synth(\mybell, [\freq, 444+(400.rand)]) // new frequency, but same sound
// try to redefine the SynthDef above and you will now get a different bell:
Synth(\mybell) // same sound all the time

(
{ ({ SinOsc.ar(rrand(180, 1200), 0.5*pi, 0.1) // the partial
        *
    // each partial gets its own envelope of 0.5 to 5 seconds
    EnvGen.ar(Env.perc(rrand(0.00001, 0.01), rrand(0.5, 50)))
} ! 12).sum }.play
)

{SinOsc.ar([880, 883], 0.2*pi, 0.5).sum!2}.play



(    // create controls directly with literal arrays:
SynthDef(\dynsynth, {| freqs = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    amps = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    rings = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]|
    Out.ar(0, DynKlang.ar(`[freqs, amps, rings]))
}).add
)

(
var bufsize, ms, slid, cspec, rate;
var harmonics = 20;
GUI.qt;

x = Synth(\dynsynth).setn(
                \freqs, Array.fill(harmonics, {|i| 110*(i+1)}),
                \amps, Array.fill(harmonics, {0})
                );

// GUI :
w = Window("harmonics", Rect(200, 470, 20*harmonics+40,140)).front;
ms = MultiSliderView(w, Rect(20, 10, 20*harmonics, 110));
ms.value_(Array.fill(harmonics,0.0));
ms.isFilled_(true);
ms.indexThumbSize_(10.0);
ms.strokeColor_(Color.blue);
ms.fillColor_(Color.blue(alpha: 0.2));
ms.gap_(10);
ms.action_({
    x.setn(\amps, ms.value*harmonics.reciprocal);
});
)