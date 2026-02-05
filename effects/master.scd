// effects/master.scd - 主效果器（压缩 + 限幅）
(
SynthDef(\masterFX, {
    arg in, out = 0, thresh = 0.5, ratio = 4;
    var input, compressed;

    input = In.ar(in, 2);

    compressed = CompanderD.ar(
        input,
        thresh,
        0.8,
        1 / ratio,
        0.01,
        0.1
    );

    // 增益
    compressed = compressed * 1.8;

    // 限幅
    compressed = Limiter.ar(
        compressed,
        level: 0.999,
        dur: 0.01
    );

    Out.ar(out, compressed);
}).add;

"[effects/master] 主效果器加载完成".postln;
)
