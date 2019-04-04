//drum machine
//parameters should be controlled through midi or local UI
//about 8 different sounds(synths) with respective controls to tailor the sound profile
//n different synths with controls, but double that(or maybe quadruple if 4 voices), so I can have for instance two "kicks" that are different in tone

s.boot;
s.meter;
s.plotTree;
s.quit;

MIDIClient.init;
MIDIClient.sources;
MIDIIn.connect(0);
MIDIIn.connectAll;

( //global variables
~drum1_pan = 0;
~drum2_pan = 0;
~drum3_pan = 0;
~drum4_pan = 0;
~drum5_pan = 0;
~drum6_pan = 0;
~drum7_pan = 0;
~drum8_pan = 0;
~drum1_2_pan = 0;
~drum2_2_pan = 0;
~drum3_2_pan = 0;
~drum4_2_pan = 0;
~drum5_2_pan = 0;
~drum6_2_pan = 0;
~drum7_2_pan = 0;
~drum8_2_pan = 0;
)

( //MIDI related functions
//for handling drums:
MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	[vel, nn, chan, src].postln;
	//drums
	switch(nn,
		44, {Synth.new(\snare, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum1_pan]);},
		45, {Synth.new(\high_tom, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum2_pan]);},
		46, {Synth.new(\medium_tom, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum3_pan]);},
		47, {Synth.new(\low_tom, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum4_pan]);},
		48, {Synth.new(\hihat, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum5_pan]);},
		49, {Synth.new(\crash, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum6_pan]);},
		50, {Synth.new(\clap, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum7_pan]);},
		51, {Synth.new(\kick, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum8_pan]);},
		36, {Synth.new(\snare, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum1_2_pan]);},
		37, {Synth.new(\high_tom, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum2_2_pan]);},
		38, {Synth.new(\medium_tom, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum3_2_pan]);},
		39, {Synth.new(\low_tom, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum4_2_pan]);},
		40, {Synth.new(\hihat, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum5_2_pan]);},
		41, {Synth.new(\crash, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum6_2_pan]);},
		42, {Synth.new(\clap, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum7_2_pan]);},
		43, {Synth.new(\kick, [\amp, vel.linexp(0,127,0.001,1), \pan, ~drum8_2_pan]);}
	);

	//add stuff to handle the meter
}, chan:9);

//for handling some extra setting changes (control portion of sequencer):
MIDIdef.cc(\ccMessages, {
	arg key, func, ccNum, chan, srcID, argTemplate, dispatcher;
	[key, func, ccNum, chan, srcID, argTemplate, dispatcher].postln();
	switch(func,
		1, {~drum1_pan = key.linlin(0, 127, -1, 1);},
		2, {~drum2_pan = key.linlin(0, 127, -1, 1);},
		3, {~drum3_pan = key.linlin(0, 127, -1, 1);},
		4, {~drum4_pan = key.linlin(0, 127, -1, 1);},
		5, {~drum5_pan = key.linlin(0, 127, -1, 1);},
		6, {~drum6_pan = key.linlin(0, 127, -1, 1);},
		7, {~drum7_pan = key.linlin(0, 127, -1, 1);},
		8, {~drum8_pan = key.linlin(0, 127,-1, 1);},
		9, {~drum1_2_pan = key.linlin(0, 127, -1, 1);},
		10, {~drum2_2_pan = key.linlin(0, 127, -1, 1);},
		11, {~drum3_2_pan = key.linlin(0, 127, -1, 1);},
		12, {~drum4_2_pan = key.linlin(0, 127, -1, 1);},
		13, {~drum5_2_pan = key.linlin(0, 127, -1, 1);},
		14, {~drum6_2_pan = key.linlin(0, 127, -1, 1);},
		15, {~drum7_2_pan = key.linlin(0, 127, -1, 1);},
		16, {~drum8_2_pan = key.linlin(0, 127, -1, 1);}
	)
});
)


( //initialize all drum instruments
//1. snare
SynthDef.new(\snare, {
	arg out = 0, amp = 1, sinfreq = 180, att = 0.01, rel = 0.13, ffreq = 2000, pan = 0;
	var snd1 = WhiteNoise.ar(amp/4);
	var snd2 = SinOsc.ar(sinfreq,0,amp/2);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	var sum = HPF.ar(snd1 * env, ffreq)+(snd2*env);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

//2. high tom
SynthDef.new(\high_tom, {
	arg out = 0, amp = 1, sinfreq = 160, att = 0.01, relTom = 0.5, relNoise = 0.2, pan = 0;
	var snd1 = WhiteNoise.ar(amp/20);
	var snd2 = SinOsc.ar(sinfreq,0,amp/2);
	var envTom = EnvGen.kr(Env.perc(att, relTom), doneAction: 2);
	var envNoise = EnvGen.kr(Env.perc(att, relNoise));
	var sum = (snd1 * envNoise)+(snd2*envTom);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

//3. medium tom
SynthDef.new(\medium_tom, {
	arg out = 0, amp = 1, sinfreq = 120, att = 0.01, relTom = 0.5, relNoise = 0.2, pan = 0;
	var snd1 = WhiteNoise.ar(amp/20);
	var snd2 = SinOsc.ar(sinfreq,0,amp/2);
	var envTom = EnvGen.kr(Env.perc(att, relTom), doneAction: 2);
	var envNoise = EnvGen.kr(Env.perc(att, relNoise));
	var sum = (snd1 * envNoise)+(snd2*envTom);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

//4. low tom
SynthDef.new(\low_tom, {
	arg out = 0, amp = 1, sinfreq = 80, att = 0.01, relTom = 0.5, relNoise = 0.2, pan = 0;
	var snd1 = WhiteNoise.ar(amp/20);
	var snd2 = SinOsc.ar(sinfreq,0,amp/2);
	var envTom = EnvGen.kr(Env.perc(att, relTom), doneAction: 2);
	var envNoise = EnvGen.kr(Env.perc(att, relNoise));
	var sum = (snd1 * envNoise)+(snd2*envTom);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

//5. hihat
SynthDef.new(\hihat, {
	arg out = 0, amp = 1, att = 0.02, rel = 0.13, ffreq = 9000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

//6. crash
SynthDef.new(\crash, {
	arg out = 0, amp = 1, pan = 0;
	var ampRelative = 0.2;
	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack, sig;

	locutoffenv = EnvGen.ar(Env.perc(0.25,4), doneAction: 2) * 20000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1,2)) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1,2,0.25));

	thwack = EnvGen.ar(Env.perc(0.001, 0.001, 1));

	freqs = {exprand(300, 20000)}.dup(100);
	res = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;

	sig = (amp*ampRelative) * ((res * 1) + (lodriver * 2) + thwack).dup;
	Out.ar(out, Pan2.ar(sig, pan));

}).add;

//7. clap
SynthDef.new(\clap, {
	arg out = 0, amp = 1, pan = 0, dur = 1;
    var env1, env2, snd, noise1, noise2;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
            [0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
            [0, -3, 0, -3, 0, -3, 0, -4]
        )
    );

    noise1 = WhiteNoise.ar(env1);
    noise1 = HPF.ar(noise1, 600);
    noise1 = LPF.ar(noise1, XLine.kr(7200, 4000, 0.03));
    noise1 = BPF.ar(noise1, 1620, 3);

    // noise 2 - 1 longer single
    env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = LPF.ar(noise2, 7600);
    noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

    snd = noise1 + noise2;
    snd = snd * 2;
    snd = snd.softclip;

    Out.ar(out, Pan2.ar(snd,pan,amp));
}).add;

//8. kick drum
SynthDef.new(\kick,{
    arg startPitch = 60, endPitch=40, clickLevel=0.7, pitchRel = 0.35, noiseLevel=0.25, noiseRel= 0.23, out = 0, amp = 1, pan = 0;
    var pitchEnv = EnvGen.ar(Env.perc(0.01, pitchRel), doneAction: 2);
    var clickOsc = SinOsc.ar(pitchEnv*(startPitch-endPitch)+endPitch);
    var clickEnv = EnvGen.ar(Env.perc(0.001, pitchRel))*clickLevel;
    var noiseOsc = PinkNoise.ar();
    var noiseEnv = EnvGen.ar(Env.perc(0.01, noiseRel))*noiseLevel;
    var snd =  amp * noiseOsc * noiseEnv +clickOsc *clickEnv;
    Out.ar(out,Pan2.ar(snd, pan));
}).add;
)

Synth.new(\snare);
Synth.new(\high_tom);
Synth.new(\medium_tom);
Synth.new(\low_tom);
Synth.new(\hihat);
Synth.new(\crash);
Synth.new(\clap);
Synth.new(\kick);



