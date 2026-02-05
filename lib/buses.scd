// lib/buses.scd - 音频和控制总线
(
~buses = (
    // 音频总线
    chord: Bus.audio(s, 2),      // 和弦/旋律输出
    sidechain: Bus.audio(s, 2),  // 侧链信号
    master: Bus.audio(s, 2),     // 主总线（限幅前）

    // 控制总线
    decayTime: Bus.control(s, 1),
    filterCutoff: Bus.control(s, 1)
);

// 便捷访问（保持向后兼容）
~chordBus = ~buses.chord;
~sidechain = ~buses.sidechain;
~masterBus = ~buses.master;
~decayTimeBus = ~buses.decayTime;
~filterCutoffBus = ~buses.filterCutoff;

// 设置控制总线初始值
~buses.decayTime.set(0.3);
~buses.filterCutoff.set(20000);

"[buses] 总线创建完成".postln;
)
