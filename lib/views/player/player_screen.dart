import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/providers/audio/audio_state.dart';
import 'package:lull/shared/widgets/scaffold.dart';
import 'package:lull/views/player/widgets/player_header.dart';
import 'package:lull/views/player/widgets/player_title.dart';

import 'widgets/active_sound.dart';
import 'widgets/player_controls.dart';
import 'widgets/progress_bar.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ───────────────────────────────────────────────────

  late final AnimationController _pulseCtrl;
  late final AnimationController _progressCtrl;

  // ── UI state ───────────────────────────────────────────────────────────────
  int _selectedTimer = 30;
  late Map<String, double> _volumes;

  AudioNotifier get audioNotifier => ref.read(audioProvider.notifier);

  bool get _isPlaying => ref.watch(
    audioProvider.select(
      (s) => s.currentSingle?.playbackState == PlaybackState.playing,
    ),
  );

  static const _loopLength = Duration(minutes: 3);
  @override
  void initState() {
    super.initState();

    _volumes = {for (final s in mockSounds) s.id: s.volume};

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _progressCtrl = AnimationController(vsync: this, duration: _loopLength);
    _progressCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isPlaying) {
        _progressCtrl.forward(from: 0);
      }
    });
    _progressCtrl.forward(from: 0.18);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  // ── Playback actions ───────────────────────────────────────────────────────

  void _togglePlay() async {
    await audioNotifier.toggleSound();
    if (_isPlaying) {
      _pulseCtrl.repeat(reverse: true);
      _progressCtrl.forward();
    } else {
      _pulseCtrl.stop();
      _progressCtrl.stop();
    }
  }

  void _stopAll() {
    _pulseCtrl.stop();
    _progressCtrl.forward(from: 0);
    _progressCtrl.stop();
    audioNotifier.stopAll();
  }

  Duration get _position => _loopLength * _progressCtrl.value;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return MyScaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              DesignTokens.spacing4,
              topPadding + DesignTokens.spacing10,
              DesignTokens.spacing4,
              DesignTokens.navHeight + DesignTokens.spacing5,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                PlayerHeader(),
                const SizedBox(height: DesignTokens.spacing5),
                PlayerTitle(),
                const SizedBox(height: DesignTokens.spacing5),
                AnimatedBuilder(
                  animation: _progressCtrl,
                  builder: (_, _) => SoLoudProgressBar(
                    position: _position,
                    length: _loopLength,
                    onSeek: (pos) => _progressCtrl.value =
                        pos.inMilliseconds / _loopLength.inMilliseconds,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing5),
                PlayerControls(
                  isPlaying: _isPlaying,
                  pulseController: _pulseCtrl,
                  onTogglePlay: _togglePlay,
                  onStopAll: _stopAll,
                ),
                // const SizedBox(height: DesignTokens.spacing5),
                // SoundMixer(
                //   sounds: mockSounds,
                //   volumes: _volumes,
                //   onVolumeChanged: (id, v) => setState(() => _volumes[id] = v),
                // ),
                // const SizedBox(height: DesignTokens.spacing5),
                // SleepTimerSection(
                //   selectedMinutes: _selectedTimer,
                //   presets: timerPresets,
                //   onSelect: (min) => setState(() => _selectedTimer = min),
                // ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
