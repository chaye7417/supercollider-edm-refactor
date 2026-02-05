// main.scd - 电子舞曲重构 主入口文件
// 使用方法：在 SuperCollider 中执行此文件，然后执行 sequences/arrangement.scd
(
// 获取项目根目录
~projectRoot = PathName(thisProcess.nowExecutingPath).pathOnly;

// 服务器配置
s.options.hardwareBufferSize = 5120;
s.options.memSize = 8192 * 16;
s.options.numBuffers = 1024 * 16;
s.latency = 1;

// 等待服务器启动
s.waitForBoot({
    "========== 开始加载模块 ==========".postln;

    // 1. 加载配置
    (~projectRoot ++ "config.scd").load;
    s.sync;

    // 2. 加载总线
    (~projectRoot ++ "lib/buses.scd").load;
    s.sync;

    // 3. 加载工具函数
    (~projectRoot ++ "lib/utils.scd").load;
    s.sync;

    // 4. 加载合成器
    (~projectRoot ++ "synths/drums.scd").load;
    s.sync;
    (~projectRoot ++ "synths/bass.scd").load;
    s.sync;
    (~projectRoot ++ "synths/pads.scd").load;
    s.sync;
    (~projectRoot ++ "synths/leads.scd").load;
    s.sync;
    (~projectRoot ++ "synths/noise.scd").load;
    s.sync;

    // 5. 加载效果器
    (~projectRoot ++ "effects/sidechain.scd").load;
    s.sync;
    (~projectRoot ++ "effects/master.scd").load;
    s.sync;

    // 6. 加载播放器函数
    (~projectRoot ++ "lib/players.scd").load;
    s.sync;

    "========== 模块加载完成 ==========".postln;

    // 7. 创建效果器链
    Routine({
        // 创建侧链压缩器
        ~sidechainComp = Synth.tail(nil, \sidechainCompressor, [
            \in, ~chordBus,
            \out, ~masterBus,
            \sidechain_in, ~sidechain,
            \threshold, 0.5,
            \ratio, 4
        ]);

        s.sync;

        // 创建主效果器
        ~masterComp = Synth.tail(nil, \masterFX, [
            \in, ~masterBus,
            \out, 0,
            \thresh, 0.8,
            \ratio, 4
        ]);

        s.sync;

        "========== 效果器链创建完成 ==========".postln;
        "".postln;
        "项目初始化完成！".postln;
        "执行 sequences/arrangement.scd 开始播放".postln;
        "或使用 ~stopAllPlayers.value 停止所有播放器".postln;
    }).play;
});
)
