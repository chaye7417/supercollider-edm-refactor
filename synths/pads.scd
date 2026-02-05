// synths/pads.scd - Pad 和弦合成器
(
// 主和弦合成器
SynthDef(\chord, {
    arg freq = 440, gate = 1, amp = 0.5, decayBus,
        masterPan = 0, masterAmp = 1, out = 0;
    var voices, snd, ampEnv, modEnv, wet, processed;
    var decayTime;

    decayTime = In.kr(decayBus, 1);

    voices = 8.collect({ |i|
        var detune = LFNoise2.kr(
            freq: 0.1,
            mul: 0.015,
            add: i * 0.001
        );
        var randomPan = LFNoise2.kr(
            freq: 0.15,
            mul: 0.3
        );
        var pan = ((i / 3.5) - 1) + randomPan;
        pan = (pan + masterPan).clip(-1, 1);
        Pan2.ar(
            LFSaw.ar(
                freq: freq * (1 + detune),
                iphase: LFNoise0.kr(1).range(0, 2.0)
            ),
            pan
        )
    });

    snd = Mix(voices) / 8;

    ampEnv = EnvGen.kr(
        Env.adsr(
            attackTime: 0,
            decayTime: decayTime * 0.8,
            sustainLevel: 0,
            releaseTime: 1
        ),
        gate: gate,
        doneAction: 2
    );

    modEnv = EnvGen.kr(
        Env.adsr(
            attackTime: 0,
            decayTime: decayTime * 0.4,
            sustainLevel: 0,
            releaseTime: 1
        ),
        gate: gate
    );

    snd = LPF.ar(snd, freq: 500 + (modEnv * 3500));
    snd = snd * ampEnv * amp * masterAmp;

    wet = FreeVerb2.ar(
        snd[0], snd[1],
        mix: 0.1,
        room: 1,
        damp: 0
    );
    wet = HPF.ar(wet, 100);
    processed = XFade2.ar(snd, wet * 0.7, 0.6);

    Out.ar(out, processed * 0.8);
}).add;

// Pad 1 - 正弦波基础
SynthDef(\pad, {
    arg freq = 440, gate = 1, amp = 1, pan = 0;
    var snd, env;
    env = Env.asr(5, 1, 5, curve: \sin).ar(Done.freeSelf, gate);
    freq = freq * [1, 2, 1, 2, 2, 1, 2, 1];
    freq = freq * (({ ~smoothLFO.(8) } ! freq.size) * 0.2).midiratio;
    snd = SinOsc.ar(freq);
    snd = snd * [0, -10, 0, -10, -10, 0, -10, 0].dbamp;
    snd = snd * (1 + ({ ~smoothLFO.(5) } ! snd.size));
    snd = Splay.ar(snd);
    snd = snd + BPF.ar({ PinkNoise.ar } ! 2, freq * 4, 0.1);
    snd = snd + Latch.ar(snd * -25.dbamp, Impulse.ar(ExpRand(4e3, 16e3)));
    snd = snd * -18.dbamp;
    snd = Pan2.ar(snd, pan);
    snd = snd * env * amp;
    Out.ar(\out.kr(0), snd);
}).add;

// Pad 2 - 三角波基础
SynthDef(\pad2, {
    arg freq = 440, gate = 1, amp = 1, pan = 0;
    var snd, env;
    env = Env.asr(5, 1, 5, curve: \sin).ar(Done.freeSelf, gate);
    freq = freq * [1, 2, 1, 3, 4, 1, 2, 1];
    freq = freq * (({ ~smoothLFO.(8) } ! freq.size) * 0.2).midiratio;
    snd = LFTri.ar(freq);
    snd = snd * [0, -10, 0, -15, -19, 0, -10, 0].dbamp;
    snd = snd * (1 + ({ ~smoothLFO.(5) } ! snd.size));
    snd = Splay.ar(snd);
    snd = LPF.ar(snd, 500);
    snd = snd + DelayC.ar(snd, 0.2, SinOsc.ar(1/4.5, [0, pi] + Rand(0, pi)).linlin(-1, 1, 0, 1) * 1e-3);
    snd = snd * -23.dbamp;
    snd = Pan2.ar(snd, pan);
    snd = snd * env * amp;
    Out.ar(\out.kr(0), snd);
}).add;

"[synths/pads] Pad 合成器加载完成".postln;
)
