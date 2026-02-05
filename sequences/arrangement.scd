// sequences/arrangement.scd - 编曲序列
// 运行此文件前，确保已加载 main.scd
(
Routine({
    // 清理之前的播放器
    ~stopAllPlayers.value;

    // ========== 第一段：Intro（4小节）==========
    ~makeSingleSynth.(\sweepNoise, [
        \numBars, 4,
        \amp, 0.1,
        \startLevel, 0.3,
        \endLevel, 0.3,
        \startFreq, 10000,
        \endFreq, 1000,
        \rq, 0.8
    ], \sweepPlayer).play;

    // 和弦进行
    ~makeChordPlayer.(\chord, [
        ~c1, \, ~c1, \,
        ~c1, \, ~c1, \,
        ~c1, \, ~c1, \,
        ~c1, \, ~c2, \,

        ~c2, \, ~c2, \,
        ~c2, \, ~c2, \,
        ~c2, \, ~c2, \,
        ~c2, \, ~c2, \,

        ~c3, \, ~c3, \,
        ~c3, \, ~c3, \,
        ~c3, \, ~c5, \,
        ~c5, \, ~c5, \,

        ~c4, \, ~c4, \,
        ~c4, \, ~c6, \,
        ~c6, \, ~c6, \,
        ~c6, \, ~c6, \,
    ], 3, \mainChords).play;

    ~wait.value(4);

    // ========== 第二段：Build（4小节）==========
    ~makeSingleSynth.(\sweepNoise, [
        \numBars, 4,
        \amp, 0.1,
        \startLevel, 0.5,
        \endLevel, 1,
        \startFreq, 1000,
        \endFreq, 10000,
        \rq, 0.8
    ], \sweepPlayer).play;

    ~makeAutomation.value(~decayTimeBus, 1, 0.3, 0.5, \lin, "decay time").play;
    ~wait.value(1);

    ~makeAutomation.value(~decayTimeBus, 1, 0.5, 1.5, \lin, "decay time").play;
    ~wait.value(1);

    ~makeAutomation.value(~decayTimeBus, 2, 1.5, 0.5, \lin, "decay time").play;
    ~wait.value(1);

    // ========== 第三段：Kick 进入（1小节）==========
    ~makekickPlayer.(\kick, [
        0, \, \, \,
    ], 0, \kickPattern).play;

    ~wait.value(1);

    ~makeSingleSynth.(\sweepNoise, [
        \numBars, 8,
        \amp, 0.1,
        \startLevel, 0.5,
        \endLevel, 0,
        \startFreq, 10000,
        \endFreq, 1000,
        \rq, 0.8
    ], \sweepPlayer).play;

    // Bass 进入
    ~makeChordPlayer.(\bass, [
        \, \, [-22], \,
        \, \, [], \,
        \, \, [-22], \,
        \, \, [-20], \,

        \, \, [-20], \,
        \, \, [], \,
        \, \, [-20], \,
        \, \, [-20], \,

        \, \, [-18], \,
        \, \, [], \,
        \, \, [-18], \,
        \, \, [-18], \,

        \, \, [-23], \,
        \, \, [], \,
        \, \, [-23], \,
        \, \, [-23], \,
    ], 2, \bassPattern).play;

    ~wait.value(4);

    // ========== 第四段：打击乐进入（4小节）==========
    ~makeChordPlayer.(\kalimba, [
        \, \, \, \,
        \, \, \, \,
        \, \, \, \,
        \, \, \, \,

        \, \, \, \,
        \, \, \, \,
        \, \, \, \,
        \, \, \, \,

        \, \, \, \,
        \, \, \, \,
        \, \, \, \,
        \, \, \, \,

        \, \, \, \,
        \, \, \, \,
        \, \, \, \,
        \, \, [4], \,
    ], 4, \percPattern).play;

    // Clap 和白噪声
    ~makeChordPlayer.(\whiteNoise, [
        \, \, \, \,
        \, \, \, \,
        [-3], \, \, \,
        \, \, \, \,
    ], 5, \noisePattern).play;

    ~makeSynthPlayer.(\clap_1, [
        \, \, \, \,
        0, \, \, \,
    ], 0, \clapPattern).play;

    ~makeSingleSynth.(\sweepNoise, [
        \numBars, 4,
        \amp, 0.1,
        \startLevel, 0.5,
        \endLevel, 0.5,
        \startFreq, 1000,
        \endFreq, 10000,
        \rq, 0.8
    ], \sweepPlayer).play;

    ~wait.value(4);

    // ========== 第五段：Hi-hat 和 Ping 进入（4小节）==========
    ~makeSingleSynth.(\sweepNoise, [
        \numBars, 8,
        \amp, 0.1,
        \startLevel, 0.5,
        \endLevel, 0,
        \startFreq, 10000,
        \endFreq, 1000,
        \rq, 0.8
    ], \sweepPlayer).play;

    ~makeChordPlayer.(\hat_1, [
        [0], \, [0], \
    ], 3, \hatPattern).play;

    ~makePingPlayer.([[-3], \, [-4], \, \, [4], \,], 5, \pingPattern).play;

    ~wait.value(4);

    // ========== 第六段：Wash 效果（4小节）==========
    ~makeSingleSynth.(\wash, [
        \numBars, 4,
        \amp, 0.5,
        \startLevel, 2,
        \endLevel, 0.6,
        \startFreq, 150,
        \endFreq, 2500,
        \startLfoAmount, 0.8,
        \endLfoAmount, 1.0,
        \startLfoRate, 4,
        \endLfoRate, 40
    ], \washPlayer).play;

    ~makeAutomation.value(~decayTimeBus, 2, 0.5, 3, \lin, "decay time").play;
    ~wait.value(2);

    ~makeAutomation.value(~decayTimeBus, 2, 3, 0.4, \lin, "decay time").play;
    ~wait.value(2);

    // ========== 第七段：Breakdown（8小节）==========
    ~stopPlayer.(\pingPattern);
    ~stopPlayer.(\mainChords);
    ~stopPlayer.(\bassPattern);

    ~makeAutomation.value(
        ~filterCutoffBus,
        8,
        500,
        10000,
        \exp,
        "filter cutoff"
    ).play;

    ~makeSingleSynth.(\sweepNoise, [
        \numBars, 4,
        \amp, 0.1,
        \startLevel, 0.3,
        \endLevel, 0.3,
        \startFreq, 10000,
        \endFreq, 1000,
        \rq, 0.6
    ], \sweepPlayer).play;

    // 新和弦进行（切分节奏）
    ~makeChordPlayer.(\chord, [
        ~c1, \, \, ~c1,
        \, \, ~c1, \,
        \, ~c1, \, \,
        ~c1, \, \, ~c1,

        \, \, ~c2, \,
        \, ~c2, \, \,
        ~c2, \, \, ~c2,
        \, \, ~c2, \,

        \, ~c3, \, \,
        ~c3, \, \, ~c3,
        \, \, ~c3, \,
        \, ~c3, \, \,

        ~c4, \, \, ~c4,
        \, \, ~c4, \,
        \, ~c4, \, \,
        ~c6, \, \, ~c6,
    ], 3, \mainChords).play;

    // 新 Bass 进行
    ~makeChordPlayer.(\bass, [
        \, \, [-22], \,
        \, \, [-22], \,
        \, \, [-22], \,
        \, \, [-22], \,

        \, \, [-20], \,
        \, \, [-20], \,
        \, \, [-20], \,
        \, \, [-20], \,

        \, \, [-18], \,
        \, \, [-18], \,
        \, \, [-18], \,
        \, \, [-18], \,

        \, \, [-23], \,
        \, \, [-23], \,
        \, \, [-23], \,
        \, \, [-23], \,
    ], 2, \bassPattern).play;

    ~wait.value(4);
    ~wait.value(4);

    "编曲播放完成".postln;
}).play;
)
