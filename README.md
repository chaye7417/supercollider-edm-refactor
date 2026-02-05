# 电子舞曲重构

SuperCollider 电子舞曲项目，采用模块化架构组织代码，便于维护和扩展。

## 功能特性

- 模块化文件结构，代码清晰易读
- 完整的合成器集合（鼓组、贝斯、Pad、旋律、噪声氛围）
- 侧链压缩和主混音效果器
- 灵活的播放器系统，支持和弦、单音、自动化控制
- 预留 SuperDirt 兼容性，方便后续 Strudel/Tidal 集成

## 项目结构

```
电子舞曲重构/
├── main.scd              # 主入口文件
├── config.scd            # 配置（BPM、根音、和弦定义）
├── lib/
│   ├── buses.scd         # 音频/控制总线
│   ├── utils.scd         # 工具函数
│   └── players.scd       # 播放器函数
├── synths/
│   ├── drums.scd         # kick、clap、hat
│   ├── bass.scd          # bass
│   ├── pads.scd          # chord、pad、pad2
│   ├── leads.scd         # kalimba、ping、perc
│   └── noise.scd         # 噪声/氛围合成器
├── effects/
│   ├── sidechain.scd     # 侧链压缩器
│   └── master.scd        # 主效果器
└── sequences/
    └── arrangement.scd   # 编曲序列
```

## 环境要求

- SuperCollider 3.12+
- macOS / Windows / Linux

## 使用方法

### 1. 启动项目

在 SuperCollider IDE 中打开 `main.scd`，选中所有代码后执行（macOS: `Cmd+Enter`）。

等待控制台显示：
```
项目初始化完成！
执行 sequences/arrangement.scd 开始播放
```

### 2. 播放编曲

打开 `sequences/arrangement.scd`，执行代码开始播放。

### 3. 停止播放

在 SuperCollider 中执行：
```supercollider
~stopAllPlayers.value;
```

或按 `Cmd+.` 停止所有声音。

## 自定义

### 修改 BPM 和调性

编辑 `config.scd`：
```supercollider
~config = (
    bpm: 128,    // 修改速度
    root: 25,    // 修改根音（MIDI 音符号）
    // ...
);
```

### 修改和弦进行

在 `config.scd` 中编辑和弦定义：
```supercollider
~chords = (
    c1: [-22, -6, -3, 4],  // 相对于 root 的 MIDI 偏移
    c2: [-20, -4, -3, 4],
    // ...
);
```

### 创建新编曲

在 `sequences/` 文件夹中创建新的 `.scd` 文件，参考 `arrangement.scd` 的结构。

## 合成器列表

| 名称 | 类型 | 说明 |
|------|------|------|
| `\kick` | 鼓组 | 电子底鼓，带侧链输出 |
| `\clap_1` | 鼓组 | 电子拍手 |
| `\hat_1` | 鼓组 | 电子踩镲 |
| `\bass` | 贝斯 | 方波贝斯，带滤波器包络 |
| `\chord` | Pad | 8 声部锯齿波和弦 |
| `\pad` | Pad | 正弦波铺底 |
| `\pad2` | Pad | 三角波铺底 |
| `\kalimba` | 旋律 | 拇指琴音色 |
| `\ping2` | 旋律 | 短促音色，带混响 |
| `\perc_1` | 打击 | 金属打击音色 |
| `\whiteNoise` | 氛围 | 白噪声 Pad |
| `\sweepNoise` | 氛围 | 滤波器扫描噪声 |
| `\wash` | 氛围 | 三角波 + 混响 + LFO |

## 后续计划

- [ ] SuperDirt 集成，支持 Strudel/Tidal 控制
- [ ] 添加更多合成器预设
- [ ] MIDI 控制器映射

## 许可证

MIT License
