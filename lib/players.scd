// lib/players.scd - 播放器函数
(
// 活动播放器字典
~activePlayers = Dictionary.new;

// 停止所有播放器
~stopAllPlayers = {
    ~activePlayers.do { |player|
        player.stop;
    };
    ~activePlayers.clear;
    "所有播放器已停止".postln;
};

// 停止特定播放器
~stopPlayer = { |playerName|
    if(~activePlayers[playerName].notNil) {
        ~activePlayers[playerName].stop;
        ~activePlayers.removeAt(playerName);
        (playerName ++ " 已停止").postln;
    };
};

// Kick 播放器
~makekickPlayer = { |synthName, pattern, oct = 0, playerName|
    var synth;
    var routine = Routine({
        loop {
            pattern.do { |note, i|
                if(note != \) {
                    if(synth.isNil) {
                        s.bind {
                            synth = Synth(\kick, [
                                \amp, 0.3,
                                \out, ~masterBus,
                                \sidechain_out, ~sidechain
                            ]);
                        };
                    };
                    s.bind { synth.set(\freq, (~config.root + (12 * oct) + note).midicps) };
                } {
                    if(synth.notNil) {
                        s.bind { synth.set(\gate, 0) };
                        synth = nil;
                    };
                };
                (60 / ~config.bpm / 2 * [1/2, 1/2].wrapAt(i)).wait;
            };
        };
    });
    ~activePlayers[playerName] = routine;
    routine
};

// 和弦播放器
~makeChordPlayer = { |synthName, pattern, oct = 0, playerName, shouldLoop = true|
    var chordSynths;
    var isPlaying = true;

    var routine = Routine({
        while { isPlaying } {
            pattern.do { |chord, i|
                if(chord != \) {
                    if(chordSynths.notNil) {
                        chordSynths.do { |synth|
                            s.bind { synth.set(\gate, 0) };
                        };
                    };
                    s.bind {
                        chordSynths = chord.collect { |note|
                            var synth = Synth(synthName, [
                                \out, ~chordBus,
                                \decayBus, ~decayTimeBus
                            ]);
                            synth.set(\freq, (~config.root + (12 * oct) + note).midicps);
                            synth.set(\gate, 1);
                            synth
                        };
                    };
                } {
                    if(chordSynths.notNil) {
                        chordSynths.do { |synth|
                            s.bind { synth.set(\gate, 0) };
                        };
                        chordSynths = nil;
                    };
                };
                (60 / ~config.bpm / 2 * [1/2, 1/2].wrapAt(i)).wait;
            };

            if(shouldLoop.not) {
                isPlaying = false;
            };
        };

        if(chordSynths.notNil) {
            chordSynths.do { |synth|
                s.bind { synth.set(\gate, 0) };
            };
        };
        ~activePlayers.removeAt(playerName);
        ("Player " ++ playerName ++ " finished and cleaned up.").postln;
    });

    ~activePlayers[playerName] = routine;
    routine
};

// 单次触发合成器
~makeSingleSynth = { |synthName, args, playerName|
    var routine = Routine({
        s.bind {
            var fullArgs = args ++ [\out, ~chordBus];
            Synth(synthName, fullArgs);
        };
    });
    ~activePlayers[playerName] = routine;
    routine
};

// 通用 Synth 播放器
~makeSynthPlayer = { |synthName, pattern, oct = 0, playerName|
    var synth;
    var routine = Routine({
        loop {
            pattern.do { |note, i|
                if(note != \) {
                    if(synth.isNil) {
                        s.bind {
                            synth = Synth(synthName, [
                                \out, ~masterBus
                            ]);
                        };
                    };
                    s.bind { synth.set(\freq, (~config.root + (12 * oct) + note).midicps) };
                } {
                    if(synth.notNil) {
                        s.bind { synth.set(\gate, 0) };
                        synth = nil;
                    };
                };
                (60 / ~config.bpm / 2 * [1/2, 1/2].wrapAt(i)).wait;
            };
        };
    });
    ~activePlayers[playerName] = routine;
    routine
};

// Ping 播放器（带左右声像交替）
~makePingPlayer = { |pattern, oct = 0, playerName|
    var currentSynth;
    var isRight = true;

    var routine = Routine({
        loop {
            pattern.do { |note, i|
                if(note != \) {
                    var randomPan;
                    if(isRight) {
                        randomPan = rrand(0.4, 1.0);
                    } {
                        randomPan = rrand(-1.0, -0.4);
                    };

                    s.bind {
                        currentSynth = Synth(\ping2, [
                            \freq, (~config.root + (12 * oct) + note).midicps,
                            \out, ~chordBus,
                            \pan, randomPan,
                            \amp, 1
                        ]);
                    };
                    isRight = isRight.not;
                };
                (60 / ~config.bpm / 2 * [1/2, 1/2].wrapAt(i)).wait;
            };
        };
    });

    ~activePlayers[playerName] = routine;
    routine
};

"[players] 播放器函数加载完成".postln;
)
