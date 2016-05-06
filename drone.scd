(
s= Server.local;
s.boot;
s.makeGui;
s.meter;
SynthDef(\sins, {
    | freq = 200, dur = 22, amp = 0.75|
    var bnq = Array.with(
        1-SinOsc.ar(freq, mul: 0.7),
        1-SinOsc.ar((freq * 4) * 1.0533610359546 * (SinOsc.kr(0.01, mul: 0.01)+ 1), mul: 0.6),
        1-SinOsc.ar((freq * 5)  * 1.2541124095491 * (SinOsc.kr(0.01, mul:  0.01) + 1), mul: 0.5),
        1-SinOsc.ar((freq * 6) * 1.8768759933376 *(SinOsc.kr(0.01)-1), mul: 0.02);
    );
    var att, sustain, amplitude, mix, env, envGen, resonance, verb;
    att = dur*0.002;
    sustain = dur;
    amplitude = amp;
    mix = bnq[0] + bnq[1] + bnq[2] + bnq[3] * 0.01;
    env = Env.linen(att, sustain, dur, amplitude, \cub);
    envGen = EnvGen.kr(env, 1, doneAction: 2);
    resonance = Klank.ar(`[
        [(freq*0.001) * 521, (freq*0.001) * 732, (freq*0.001) * 934],  // freqs
		[0.7, 0.45, 0.25],// amps
		[0.8, 0.8, 0.8]   // ring times
		],
        mix);
        verb = FreeVerb.ar(resonance, 0.7, 1, 0.5, Line.kr(0, 0.6, 0.5, mul: 0.7));
    (LeakDC.ar(Out.ar(0,(verb*envGen)!2)));
}).add;

// ~drone = Synth.new(\sins);
// ~drone.play;
// ~drone.set("freq", 50, "dur", 2000);
// t = Synth.new(\tris);


5.do( { arg item;
	var synth;
    synth = Synth.new(\sins);
    synth.set(\dur, rrand(1200, 1400), \freq, [50, 100, 200, 400, 800, 120].choose, \amp, [0.1, 0.3, 0.5].choose );
    //synth.play;
});

)


[1,2,3].choose