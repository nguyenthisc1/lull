import 'package:flutter/material.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/shared/widgets/scaffold.dart';
import 'widgets/active_sound.dart';
import 'widgets/player_controls.dart';
import 'widgets/player_header.dart';
import 'widgets/progress_bar.dart';
import 'widgets/sleep_timer_section.dart';
import 'widgets/sound_mixer.dart';
import 'widgets/waveform.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ───────────────────────────────────────────────────

  late final AnimationController _waveCtrl;
  late final AnimationController _pulseCtrl;

  /// Simulates SoLoud.instance.getPosition(handle) / getLength(handle).
  /// Replace with a periodic Timer polling SoLoud in production.
  late final AnimationController _progressCtrl;

  // ── UI state ───────────────────────────────────────────────────────────────

  bool _isPlaying = true;
  int _selectedTimer = 30;
  late Map<String, double> _volumes;

  static const _loopLength = Duration(minutes: 3);

  @override
  void initState() {
    super.initState();

    _volumes = {for (final s in mockSounds) s.id: s.volume};

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

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
    _waveCtrl.dispose();
    _pulseCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  // ── Playback actions ───────────────────────────────────────────────────────

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _waveCtrl.repeat();
      _pulseCtrl.repeat(reverse: true);
      _progressCtrl.forward();
    } else {
      _waveCtrl.stop();
      _pulseCtrl.stop();
      _progressCtrl.stop();
    }
  }

  void _stopAll() {
    setState(() => _isPlaying = false);
    _waveCtrl.stop();
    _pulseCtrl.stop();
    _progressCtrl.forward(from: 0);
    _progressCtrl.stop();
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
              topPadding + DesignTokens.spacing8,
              DesignTokens.spacing4,
              DesignTokens.navHeight + DesignTokens.spacing5,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                PlayerHeader(soundCount: mockSounds.length),
                const SizedBox(height: DesignTokens.spacing5),
                PlayerWaveform(
                  controller: _waveCtrl,
                  isPlaying: _isPlaying,
                ),
                const SizedBox(height: DesignTokens.spacing4),
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
                const SizedBox(height: DesignTokens.spacing5),
                SoundMixer(
                  sounds: mockSounds,
                  volumes: _volumes,
                  onVolumeChanged: (id, v) =>
                      setState(() => _volumes[id] = v),
                ),
                const SizedBox(height: DesignTokens.spacing5),
                SleepTimerSection(
                  selectedMinutes: _selectedTimer,
                  presets: timerPresets,
                  onSelect: (min) => setState(() => _selectedTimer = min),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
