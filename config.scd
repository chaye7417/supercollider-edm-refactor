// config.scd - 全局配置
// 包含 BPM、根音、服务器设置、和弦定义
(
~config = (
    // 音乐参数
    bpm: 128,
    root: 25,

    // 服务器配置
    hardwareBufferSize: 5120,
    memSize: 8192 * 16,
    numBuffers: 1024 * 16,
    latency: 1
);

// 和弦定义（相对于 root 的 MIDI 偏移）
~chords = (
    c1: [-22, -6, -3, 4],
    c2: [-20, -4, -3, 4],
    c3: [-18, -1, 4, 8],
    c4: [-23, -3, -1, 4],
    c5: [-18, -1, 4, 9],
    c6: [-23, -4, -3, -1],
    c7: [-25, -6, -3, 2, 4]
);

// 便捷访问（保持向后兼容）
~c1 = ~chords.c1;
~c2 = ~chords.c2;
~c3 = ~chords.c3;
~c4 = ~chords.c4;
~c5 = ~chords.c5;
~c6 = ~chords.c6;
~c7 = ~chords.c7;

"[config] 配置加载完成".postln;
)
