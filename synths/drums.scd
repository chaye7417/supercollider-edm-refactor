// synths/drums.scd - 鼓组合成器
(
// Kick
SynthDef(\kick, {
    arg amp = 0.1, out = 0, sidechain_out;
    var snd;
    snd = SinOsc.ar(40 * (Env.perc(0.001, 0.000001).ar * 30).midiratio * [1, 2.3, 3.5, 7.8]);
    snd = snd * Env.perc(0.001, [0.3, 0.1, 0.00005, 0.01]).ar;
    snd = snd.sum;
    snd = snd * (1 + (Env.perc(0, 0.03).ar * 5));
    snd = snd.clip2;
    snd = snd + PitchShift.ar(snd, 0.02, [0.9, 1.1]);
    snd = snd * Env.linen(0.0, 0.2, 0.3, curve: -4).ar(Done.freeSelf) * amp;
    Out.ar(out, snd * 0.6);
    Out.ar(sidechain_out, snd * 1);
}).add;

// Clap
SynthDef(\clap_1, {
    var snd, env, filterCutoff;
    filterCutoff = In.kr(~filterCutoffBus, 1);

    env = Env([0, 1, 0.3, 1, 0.3, 1, 0], [0.001, 0.01, 0.001, 0.015, 0.001, 0.1], -4).ar(Done.freeSelf);
    snd = Hasher.ar(Sweep.ar);
    snd = BPF.ar(snd, 1000, 1) * 12.dbamp;
    snd = snd * env;
    snd = snd * -20.dbamp;
    snd = LPF.ar(snd, filterCutoff, 0.1);
    snd = Pan2.ar(snd, \pan.kr(0));
    Out.ar(\out.kr(~masterBus), snd * 7);
}).add;

// Hi-hat
SynthDef(\hat_1, {
    var snd, filterCutoff;

    filterCutoff = In.kr(~filterCutoffBus, 1);

    snd = Pulse.ar(40 * [2, 3.2, 4.6, 5.8, 6.7, 8.5]);
    snd = snd.sum;
    snd = FreqShift.ar(snd, 73);
    snd = BPF.ar(snd, [9.3e3, 7e3] * 0.9, 0.04).sum * 6.dbamp;
    snd = snd + RHPF.ar(Hasher.ar(Sweep.ar) * 2.dbamp * Env.perc(0.05, 0.1).ar, 11e3, 0.1);
    snd = LPF.ar(snd, 7300);
    snd = HPF.ar(snd, 6e3);
    snd = LPF.ar(snd, filterCutoff, 0.3);
    snd = snd * -8.dbamp;
    snd = snd * Env.perc(0.02, 0.15, curve: -2).ar(Done.freeSelf);
    snd = snd ! 2;
    Out.ar(\out.kr(0), snd * 0.4);
}).add;

"[synths/drums] 鼓组合成器加载完成".postln;
)
