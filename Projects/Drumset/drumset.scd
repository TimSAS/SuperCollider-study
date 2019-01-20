//drum machine
//parameters should be controlled through midi or local UI
//about 8 different sounds(synths) with respective controls to tailor the sound profile
//n different synths with controls, but double that(or maybe quadruple if 4 voices), so I can have for instance two "kicks" that are different in tone

s.boot;
s.plotTree;
s.quit;

MIDIClient.init;
MIDIClient.sources;
MIDIIn.connect(0);
MIDIIn.connectAll;

( //MIDI related functions
//for handling drums:
MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	[vel, nn, chan, src].postln;
	//drums
	switch(nn,
		36, {Synth.new(\kick, [\amp, vel.linexp(0,127,0.01,1)]);},
		37, {Synth.new(\snare, [\amp, vel.linexp(0,127,0.01,1)]);},
		38, {Synth.new(\hihat, [\amp, vel.linexp(0,127,0.01,1)]);},
		39, {Synth.new(\tom, [\amp, vel.linexp(0,127,0.01,1)]);}
	);

	//add stuff to handle the meter
}, chan:9);

//for handling some extra setting changes (control portion of sequencer):
MIDIdef.cc(\ccMessages, {
	arg key, func, ccNum, chan, srcID, argTemplate, dispatcher;
	[key, func, ccNum, chan, srcID, argTemplate, dispatcher].postln();
});
)


( //initialize all drum instruments
//kick drum
SynthDef.new(\kick,{
	arg freqA=300, freqB=70, freqC=50, freqDur1=0.01, freqDur2=0.2, freqC1=1, freqC2=(-1),
	atk=0.02, rel=1.5, c1=1, c2=(-8), amp=1, pan=0, out=0;
	var sig, env, freqSweep;
	freqSweep = Env([freqA, freqB, freqB], [freqDur1, freqDur2], [freqC1, freqC2]).ar;
	env = Env([0,1,0], [atk,rel], [c1,c2]).kr(2);
	sig = SinOsc.ar(freqSweep, pi/2);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

//snare
SynthDef.new(\snare, {
	arg out = 0, amp = 1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var snd1 = WhiteNoise.ar(amp - 0.5);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	var sum = HPF.ar(snd1 * env, ffreq)+(snd2*env);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

//tom
SynthDef.new(\tom, {
	arg out = 0, amp = 1, pan = 0;
	var env, sig;
	env = EnvGen.kr(Env.perc(0.01, 0.6, 1, -5), 1);
	sig = SinOsc.ar(140);
	sig = Pan2.ar(sig*env, pan, amp);
	Out.ar(out, sig);
}).add;

//hihat
SynthDef.new(\hihat, {
	arg out = 0, amp = 1, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;
)



x = Synth.new(\kick);
y = Synth.new(\snare);
z = Synth.new(\tom);
i = Synth.new(\hihat);


