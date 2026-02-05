// synths/leads.scd - 旋律/打击合成器
(
// Kalimba（拇指琴）
SynthDef(\kalimba, {
    |out = 0, freq = 440, amp = 0.1, mix = 0.1, relMin = 2.5, relMax = 3.5, haasDelay = 0.01|
    var snd, sndH, sndL, sndR, dry, wet, processed, releaseEnv;

    snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.005, Rand(relMin, relMax), 1, -8));

    sndH = SinOsc.ar(freq * [4, 6, 8]) * EnvGen.ar(Env.perc(0.001, 0.1, 1, -8)) * [-15, -18, -20].dbamp;
    snd = snd + sndH.sum;

    snd = (snd * (1 - mix)) + (DynKlank.ar(`[
        [240*ExpRand(0.9, 1.1), 3020*ExpRand(0.9, 1.1), 5151*ExpRand(0.9, 1.1), 7200*ExpRand(0.9, 1.1)],
        [-7, -2, 0, 2].dbamp,
        [0.8, 0.1, 0.08, 0.05]
    ], PinkNoise.ar * EnvGen.ar(Env.perc(0.001, 0.01))) * mix);

    sndL = snd;
    sndR = DelayC.ar(snd, 0.03, haasDelay);

    sndL = sndL * LFNoise2.kr(0.5).range(0.95, 1);
    sndR = sndR * LFNoise2.kr(0.5).range(0.95, 1);

    dry = [sndL, sndR] * amp;

    releaseEnv = Env.new(
        levels: [1, 1, 0],
        times: [0.5, 10],
        curve: [0, -3]
    ).ar(2);

    wet = FreeVerb2.ar(
        dry[0], dry[1],
        mix: 1,
        room: 1,
        damp: 0
    );
    wet = HPF.ar(wet, 100);
    wet = wet * 1.5;

    processed = (dry + wet) * releaseEnv;

    Out.ar(out, processed * 0.5);
}).add;

// Ping（带混响的短促音色）
SynthDef(\ping2, {
    arg freq = 440, pan = 0, amp = 1;
    var snd, env, dry, wet, processed;

    snd = LFTri.ar(freq * XLine.ar(1.2, 1, 0.003));
    snd = snd * (1 + (Rand(1, 5) * Env.perc(0.0, 0.01 * ExpRand(0.5, 3), curve: -8).ar));
    snd = snd.tanh + (snd.fold2 * -5.dbamp);
    snd = snd * (1 + (Rand(1, 2) * Env.perc(0.0, 0.01 * ExpRand(0.5, 3), curve: -8).ar));
    snd = snd * (1 + (0.5 * Env.perc(0.001, 0.01).delay(0.03).ar));
    snd = Latch.ar(snd, Impulse.ar(ExpRand(4e3, 16e3)));
    snd = snd + (PinkNoise.ar * -10.dbamp);
    snd = LPF.ar(snd, 4000);
    snd = snd * freq.explin(440, 1000, 0, -10).dbamp;

    snd = Pan2.ar(snd, pan);
    snd = snd * -20.dbamp * amp;

    env = Env.perc(0.001, 0.8 * ExpRand(1, 3), curve: -8).ar;
    dry = snd * env;

    wet = FreeVerb2.ar(
        dry[0], dry[1],
        mix: 0.7,
        room: 1,
        damp: 0
    );
    wet = HPF.ar(wet, 100);
    wet = wet * 1.5;

    processed = dry + wet;

    Out.ar(\out.kr(~masterBus), processed * 1);
}).add;

// Perc（金属打击音色）
SynthDef(\perc_1, {
    arg freq = 1000, amp = 1, freqRatio = 1.5, noiseMix = 0.7;
    var sndL, sndR, noiseL, noiseR, stereoOut, soundEnv, releaseEnv, dry, wet, processed;

    noiseL = WhiteNoise.ar * 0.7 + PinkNoise.ar * 0.3;
    noiseR = WhiteNoise.ar * 0.7 + PinkNoise.ar * 0.3;

    // 左声道
    sndL = SinOsc.ar(freq * [1, 2.3, 4.8, 7.8] * XLine.ar(2, 1, 0.001));
    sndL = sndL * Env.perc(0, [0.5, 0.05, 0.14, 0.2]).ar;
    sndL = sndL * [0, -10, -8, -13].dbamp;
    sndL = sndL.sum;
    sndL = sndL * (1 + (Rand(5, 20) * Env.perc(0, 0.05).ar));
    sndL = sndL * Rand(0, 5).dbamp;
    sndL = (sndL * (1 - noiseMix)) + (noiseL * BPF.ar(PinkNoise.ar, freq * [1, 2.3, 4.8, 7.8].sum, 0.3) * noiseMix);
    sndL = sndL.tanh;
    sndL = sndL * (1 + (SinOsc.ar(3230 * ((freq / 940) ** 1.1)) * Env.perc(0, 0.3).ar));
    sndL = sndL + PitchShift.ar(sndL * -5.dbamp, ExpRand(0.02, 0.03), 1.8);
    sndL = sndL + PitchShift.ar(sndL * -7.dbamp, ExpRand(0.02, 0.03), 0.7);

    // 右声道
    sndR = SinOsc.ar(freq * freqRatio * [1, 2.3, 4.8, 7.8] * XLine.ar(2, 1, 0.001));
    sndR = sndR * Env.perc(0, [0.5, 0.05, 0.14, 0.2]).ar;
    sndR = sndR * [0, -10, -8, -13].dbamp;
    sndR = sndR.sum;
    sndR = sndR * (1 + (Rand(5, 20) * Env.perc(0, 0.05).ar));
    sndR = sndR * Rand(0, 5).dbamp;
    sndR = (sndR * (1 - noiseMix)) + (noiseR * BPF.ar(PinkNoise.ar, freq * freqRatio * [1, 2.3, 4.8, 7.8].sum, 0.3) * noiseMix);
    sndR = sndR.tanh;
    sndR = sndR * (1 + (SinOsc.ar(3230 * ((freq * freqRatio / 940) ** 1.1)) * Env.perc(0, 0.3).ar));
    sndR = sndR + PitchShift.ar(sndR * -5.dbamp, ExpRand(0.02, 0.03), 1.8);
    sndR = sndR + PitchShift.ar(sndR * -7.dbamp, ExpRand(0.02, 0.03), 0.7);

    sndL = sndL * (1 + (LFNoise2.ar(freq * 0.1) * 0.3));
    sndR = sndR * (1 + (LFNoise2.ar(freq * 0.1) * 0.3));

    sndL = BPF.ar(sndL, LFNoise2.kr(0.5).range(freq * 0.8, freq * 1.2), 0.5);
    sndR = BPF.ar(sndR, LFNoise2.kr(0.5).range(freq * 0.8, freq * 1.2), 0.5);

    soundEnv = Env.perc(0.001, 0.5).ar;

    releaseEnv = Env.new(
        levels: [1, 1, 0],
        times: [0.5, 10],
        curve: [0, -3]
    ).ar(2);

    dry = [sndL, sndR] * -21.dbamp * amp * soundEnv;

    wet = FreeVerb2.ar(
        dry[0], dry[1],
        mix: 0.7,
        room: 1,
        damp: 0
    );
    wet = HPF.ar(wet, 100);
    wet = wet * 1.5;

    processed = (dry + wet) * releaseEnv;

    Out.ar(\out.kr(0), processed);
}).add;

"[synths/leads] 旋律合成器加载完成".postln;
)
