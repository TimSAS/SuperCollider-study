s.boot;
s.meter;
s.quit;

{Pulse.ar(freq: MouseX.kr(300, 2500), mul: MouseY.kr(0, 1))}.play;
{Pulse.ar(freq: MouseX.kr(300, 2500), mul: MouseY.kr(0, 1))}.scope;

{SinOsc.ar}.plot;
{Saw.ar}.plot;
{Pulse.ar}.plot;
{LFPulse.ar}.plot;

{SinOsc.kr(1).poll}.play;
{LFPulse.kr(1).poll}.play;

{LFNoise0.ar(40).poll}.play;

// minval and maxval privided in order, no keywords
{MouseX.kr(300, 2500).poll}.play;
// minval, maxval and lag provided, skipped warp
{MouseX.kr(minval: 300, maxval: 2500, lag: 10).poll}.play;

{LFNoise0.kr(10).range(500, 1500).poll}.play;
{SinOsc.ar(freq: LFPulse.kr(1).range(50, 200)).poll}.scope;

//two are equavalent:
{SinOsc.kr(1).range(100,200).poll}.play;
{SinOsc.kr(1, mul: 50, add: 150).poll}.play;

{Out.ar(1, SinOsc.ar(440, 0, 0.1))}.play;

// start the effect
f = {Out.ar(0, BPF.ar(in: In.ar(55), freq: MouseY.kr(1000, 5000), rq: 0.1))}.play;
// start the source
n = {Out.ar(55, WhiteNoise.ar(0.5))}.play;