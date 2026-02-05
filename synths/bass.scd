// synths/bass.scd - 贝斯合成器
(
SynthDef(\bass, {
    var snd, env;
    // 方波振荡器，带轻微滑音
    snd = Pulse.ar(\freq.kr(440) * XLine.kr(1.3, 1, 0.01), 0.13);

    // 低通滤波器包络
    snd = LPF.ar(snd, 80 * (Env.perc(0.01, 0.4, curve: -4).ar * 20).midiratio);

    // 温和的音量调制
    snd = snd * (1 + (0.3 * Env.perc(0.02, 0.1).ar));
    snd = snd.softclip;

    // 次倍频
    snd = snd + (SinOsc.ar(\freq.kr(440) / 2) * -3.dbamp * Env.perc(0.01, 0.3).ar);

    // 主音量包络
    env = Env.perc(
        attackTime: 0.02,
        releaseTime: 0.5,
        level: 0.8,
        curve: -2
    ).ar(Done.freeSelf);

    snd = snd * env;
    snd = snd * 0.dbamp;

    // 低通滤波
    snd = RLPF.ar(snd, freq: 600, rq: 0.7);

    snd = snd ! 2;

    Out.ar(\out.kr(~chordBus), snd * 0.65);
}).add;

"[synths/bass] 贝斯合成器加载完成".postln;
)
