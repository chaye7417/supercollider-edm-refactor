// synths/noise.scd - 噪声/氛围合成器
(
// 白噪声 Pad
SynthDef(\whiteNoise, {
    arg out = ~chordBus, amp = 0.5, gate = 1, pan = 0, fadeTime = 0.41;
    var sndL, sndR, env, filterCutoff;

    filterCutoff = In.kr(~filterCutoffBus, 1);

    sndL = BPF.ar(WhiteNoise.ar(), 7000 * [1.2, 1.6, 1.3, 1.4], 1).sum;
    sndR = BPF.ar(WhiteNoise.ar(), 7000 * [1.2, 1.6, 1.3, 1.4], 1).sum;

    sndL = LPF.ar(sndL, filterCutoff, 0.3);
    sndR = LPF.ar(sndR, filterCutoff, 0.3);

    env = EnvGen.kr(
        Env(
            levels: [0, 0, 1, 0],
            times: [0.01, fadeTime, 0.1],
            curve: \sin
        ),
        gate,
        doneAction: 2
    );

    Out.ar(out, [sndL, sndR] * env * amp * 0.02);
}).add;

// Sweep 噪声（带滤波器扫描）
SynthDef(\sweepNoise, {
    arg out = ~masterBus, amp = 0.5, gate = 1, pan = 0, numBars = 4,
        startLevel = 0, endLevel = 1, startFreq = 30, endFreq = 14000,
        rq = 1.5;
    var sndL, sndR, filterL, filterR, env, sweepTime;

    sweepTime = numBars * (60 / ~config.bpm * 4);

    sndL = WhiteNoise.ar();
    sndR = WhiteNoise.ar();

    filterL = LPF.ar(
        sndL,
        freq: XLine.kr(startFreq, endFreq, sweepTime),
        mul: 1
    );

    filterR = LPF.ar(
        sndR,
        freq: XLine.kr(startFreq, endFreq, sweepTime),
        mul: 1
    );

    filterL = RLPF.ar(
        filterL,
        freq: XLine.kr(startFreq, endFreq, sweepTime) * 1,
        rq: rq
    );

    filterR = RLPF.ar(
        filterR,
        freq: XLine.kr(startFreq, endFreq, sweepTime) * 1,
        rq: rq
    );

    filterL = DelayN.ar(filterL, 0.01, 0.01);

    env = EnvGen.kr(
        Env([startLevel, endLevel],
            [sweepTime],
            \lin),
        gate,
        doneAction: 2
    );

    Out.ar(out, [filterL, filterR] * env * amp * 0.3);
}).add;

// Wash（三角波 + 混响 + LFO）
SynthDef(\wash, {
    arg out = 0, amp = 0.5, gate = 1, numBars = 4,
        startLevel = 0, endLevel = 1,
        startFreq = 200, endFreq = 2000,
        startLfoAmount = 0.0,
        endLfoAmount = 1.0,
        startLfoRate = 1,
        endLfoRate = 8;

    var snd, mainEnv, sweepTime, lfo, lfoRate, lfoAmount, wet, delayedL, delayedR, delayTime, originalSnd;

    sweepTime = numBars * (60 / ~config.bpm * 4);
    delayTime = 60 / ~config.bpm;

    mainEnv = EnvGen.kr(
        Env([startLevel, endLevel, 0],
            [sweepTime, 0.1],
            \lin)
    );

    EnvGen.kr(
        Env([1, 1, 0], [sweepTime + 10, 0.1], \lin),
        doneAction: 2
    );

    lfoRate = XLine.kr(startLfoRate, endLfoRate, sweepTime);
    lfoAmount = Line.kr(startLfoAmount, endLfoAmount, sweepTime);

    lfo = LFPulse.kr(
        freq: lfoRate,
        width: 0.5
    ).range(0, 1);

    lfo = (lfo * lfoAmount) + (1 - lfoAmount);

    snd = LFTri.ar(XLine.kr(startFreq, endFreq, sweepTime));
    snd = snd ! 2;

    snd = HPF.ar(snd, 800);
    snd = BPeakEQ.ar(snd, 1200, 0.5, 3);
    snd = HPF.ar(snd, 400);

    originalSnd = snd * -15.dbamp * amp * mainEnv * lfo;

    delayedL = DelayN.ar(originalSnd[0], delayTime * 2, delayTime) * 0.4;
    delayedR = DelayN.ar(originalSnd[1], delayTime * 2, delayTime * 2) * 0.3;

    snd = [
        originalSnd[0] + delayedR,
        originalSnd[1] + delayedL
    ];

    wet = FreeVerb2.ar(
        snd[0], snd[1],
        mix: 0.6,
        room: 0.9,
        damp: 0.2
    );

    wet = wet + GVerb.ar(
        snd.sum * 0.3,
        roomsize: 150,
        revtime: 5,
        damping: 0.2,
        spread: 50,
        drylevel: 0,
        earlyreflevel: 0.1,
        taillevel: 0.6
    );

    snd = (snd + wet) * 0.5;

    Out.ar(out, snd);
}).add;

"[synths/noise] 噪声合成器加载完成".postln;
)
