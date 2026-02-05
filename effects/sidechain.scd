// effects/sidechain.scd - 侧链压缩器
(
SynthDef(\sidechainCompressor, {
    arg in, out = 0, sidechain_in, threshold = 0.5, ratio = 4;
    var input, sidechain;

    input = In.ar(in, 2);
    sidechain = In.ar(sidechain_in, 2);

    // 优化侧链信号
    sidechain = sidechain * 15;
    sidechain = HPF.ar(sidechain, 30);

    // 压缩处理
    input = Compander.ar(
        input,
        sidechain,
        thresh: 0.15,
        slopeBelow: 1,
        slopeAbove: 0.2,
        clampTime: 0.002,
        relaxTime: 0.01
    );

    // 增益补偿和限幅
    input = input * 1.2;
    input = Limiter.ar(input, 0.95, 0.002);

    Out.ar(~masterBus, input);
}).add;

"[effects/sidechain] 侧链压缩器加载完成".postln;
)
