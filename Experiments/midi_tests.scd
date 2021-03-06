//some info on arturia beatstep pro
//sequencer1 nn: 60 - 72 (13) channel 0
//sequencer2 nn: 60 - 72 (13) channel 1
//drum note numbers: 36 - 51 (16) channel 9

s.boot;

MIDIClient.init;
MIDIIn.connectAll;

MIDIClient.sources; //all MIDI sources in array
MIDIIn.connect(); //if connecting a specific MIDI device

//for handling drums:
(
MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	[vel, nn, chan, src].postln;
	switch(nn,
		36, {Synth.new(\kick, [\rel, vel.linexp(0, 127, 0.2, 2)]);},
		37, {Synth.new(\snare);},
		38, {Synth.new(\hihat);},
		39, {Synth.new(\tom);}
	);

}, chan:9);
)

//for handling some extra setting changes (control portion of sequencer):
(
MIDIdef.cc(\ccMessages, {
	arg key, func, ccNum, chan, srcID, argTemplate, dispatcher;
	[key, func, ccNum, chan, srcID, argTemplate, dispatcher].postln();
});
)


MIDIdef(\noteOnTest).permanent_(true);
MIDIdef.freeAll;

