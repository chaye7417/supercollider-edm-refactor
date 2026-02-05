// lib/utils.scd - 工具函数
(
// 平滑 LFO 生成器
~smoothLFO = { arg rate;
    (LFNoise2.kr(rate) + (LFNoise2.kr(rate * 2) / 2)).fold2;
};

// 等待指定小节数
~wait = { |numBars = 8|
    var barDur = 60 / ~config.bpm * 4 * numBars;
    barDur.wait;
};

// 自动化控制播放器
~makeAutomation = { |targetBus, numBars = 8, startVal = 0.1, endVal = 3, curve = \lin, description = "parameter"|
    var routine = Routine({
        var barDur = 60 / ~config.bpm * 4;
        [
            "Starting " ++ description ++ " automation:",
            startVal, "to", endVal,
            "over", numBars, "bars"
        ].postln;

        {
            var env = EnvGen.kr(
                Env([startVal, endVal], [numBars * barDur], curve),
                doneAction: 2
            );
            Out.kr(targetBus, env);
        }.play;

        (numBars * barDur).wait;
    });
    routine
};

"[utils] 工具函数加载完成".postln;
)
