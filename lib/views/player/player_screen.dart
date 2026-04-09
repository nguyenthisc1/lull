import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/shared/widgets/scaffold.dart';
import 'package:lull/views/player/widgets/player_header.dart';
import 'package:lull/views/player/widgets/player_title.dart';
import 'package:lull/views/player/widgets/sleep_timer.dart';
import 'package:lull/shared/widgets/sound_mixer.dart';

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
  late final Ticker _sleepTimerTicker;

  // ── UI state ───────────────────────────────────────────────────────────────
  int _selectedTimer = 30;
  Duration _sleepTimeLeft = Duration.zero;
  bool _sleepTimerActive = false;

  // Tracks the ticker's elapsed at the last 1-second decrement, so we only
  // decrement once per wall-clock second (Ticker fires every frame, not every second).
  Duration _lastTickElapsed = Duration.zero;

  static const List<int> _sleepTimerPresets = [10, 30, 60, 0]; // 0 = Off

  AudioNotifier? _audioNotifier;
  bool? _lastIsPlaying;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    if (_selectedTimer > 0) {
      _sleepTimerActive = true;
      _sleepTimeLeft = Duration(minutes: _selectedTimer);
    }

    // Ticker fires every frame (~60 fps). We gate on a 1-second wall-clock
    // interval using _lastTickElapsed so we only decrement once per second.
    _sleepTimerTicker = createTicker((Duration elapsed) {
      if (!(_lastIsPlaying ?? false) || !_sleepTimerActive || !mounted) return;

      final sinceLastDecrement = elapsed - _lastTickElapsed;
      if (sinceLastDecrement < const Duration(seconds: 1)) return;

      _lastTickElapsed = elapsed;

      setState(() {
        if (_sleepTimeLeft > const Duration(seconds: 1)) {
          _sleepTimeLeft -= const Duration(seconds: 1);
        } else {
          _sleepTimeLeft = Duration.zero;
          _sleepTimerActive = false;
          _pulseCtrl.stop();
          _audioNotifier?.stopAll();
          _sleepTimerTicker.stop();
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioNotifier = ref.read(audioProvider.notifier);

    final isPlaying = ref.watch(
      audioProvider.select((s) => s.isAnyPlaying),
    );
    _updateSleepTimerTicker(isPlaying);
    _lastIsPlaying = isPlaying;
  }

  void _updateSleepTimerTicker(bool isPlaying) {
    if (_sleepTimerActive && isPlaying && !_sleepTimerTicker.isActive) {
      _sleepTimerTicker.start();
    }
    if (!_sleepTimerActive || !isPlaying) {
      _sleepTimerTicker.stop();
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _sleepTimerTicker.dispose();
    super.dispose();
  }

  // ── Playback actions ───────────────────────────────────────────────────────

  void _togglePlay(bool isPlaying) async {
    await _audioNotifier?.togglePlayAll();
    if (!isPlaying) {
      // Starting playback
      _pulseCtrl.repeat(reverse: true);
      if (_sleepTimerActive && !_sleepTimerTicker.isActive) {
        _lastTickElapsed = Duration.zero;
        _sleepTimerTicker.start();
      }
    } else {
      // Pausing playback
      _pulseCtrl.stop();
      _sleepTimerTicker.stop();
    }
    setState(() {
      _lastIsPlaying = !isPlaying;
    });
  }

  void _stopAll() {
    _pulseCtrl.stop();
    _sleepTimerTicker.stop();
    _audioNotifier?.stopAll();
  }

  void _onSelectSleepTimer(int min, bool isPlaying) {
    setState(() {
      _selectedTimer = min;
      if (min > 0) {
        _sleepTimeLeft = Duration(minutes: min);
        _sleepTimerActive = true;
        if (_sleepTimerTicker.isActive) _sleepTimerTicker.stop();
        if (isPlaying) {
          _lastTickElapsed = Duration.zero;
          _sleepTimerTicker.start();
        }
      } else {
        _sleepTimeLeft = Duration.zero;
        _sleepTimerActive = false;
        _sleepTimerTicker.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final isPlaying = ref.watch(
      audioProvider.select((s) => s.isAnyPlaying),
    );
    _lastIsPlaying = isPlaying; // Sync last known

    // Start/stop ticker as needed based on state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSleepTimerTicker(isPlaying);
    });

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
                SoLoudProgressBar(
                  sleepTimeLeft: _sleepTimerActive && _selectedTimer > 0
                      ? _sleepTimeLeft
                      : null,
                  isOff: _selectedTimer == 0,
                ),
                const SizedBox(height: DesignTokens.spacing5),
                SleepTimer(
                  selectedMinutes: _selectedTimer,
                  presets: _sleepTimerPresets,
                  onSelect: (min) => _onSelectSleepTimer(min, isPlaying),
                  sleepTimeLeft: _sleepTimerActive && _selectedTimer > 0
                      ? _sleepTimeLeft
                      : null,
                ),
                const SizedBox(height: DesignTokens.spacing8),
                PlayerControls(
                  isPlaying: isPlaying,
                  pulseController: _pulseCtrl,
                  onTogglePlay: () => _togglePlay(isPlaying),
                  onStopAll: _stopAll,
                ),

                const SizedBox(height: DesignTokens.spacing5),
                SoundMixer(),
                const SizedBox(height: DesignTokens.spacing5),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
