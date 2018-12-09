//drum machine
//parameters should be controlled through midi or local UI
//about 8 different sounds(synths) with respective controls to tailor the sound profile
//n different synths with controls, but double that(or maybe quadruple if 4 voices), so I can have for instance two "kicks" that are different in tone

s.boot;
s.quit;
s.meter;
s.plotTree;

//kick drum
(
SynthDef.new(\kick,{
	arg freqA=500, freqB=50, freqC=10, freqDur1=0.01, freqDur2=0.2, freqC1=1, freqC2=(-1),
	atk=0.02, rel=1.5, c1=1, c2=(-12), amp=1, pan=0, out=0;
	var sig, env, freqSweep;
	freqSweep = Env([freqA, freqB, freqB], [freqDur1, freqDur2], [freqC1, freqC2]).ar;
	env = Env([0,1,0], [atk,rel], [c1,c2]).kr(2);
	sig = SinOsc.ar(freqSweep, pi/2);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\kick);

//snare

//tom

//hat


//most common 4 sounds: kick, snare, tom, hat
//sounds to research: crash cymbal, ride cymbal, closed/open hihat, hadclap, rim shoot, low/mid/high tom,
//bass drum, snare drum, kick, snare, cow... hmm quite a few drum/percussion sounds =)