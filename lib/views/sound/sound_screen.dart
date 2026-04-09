import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/providers/audio/audio_provider.dart';
import 'package:lull/shared/l10n/app_localizations.dart';
import 'package:lull/shared/widgets/scaffold.dart';
import 'package:lull/shared/widgets/sound_mixer.dart';
import 'package:lull/views/sound/widgets/sound_header.dart';
import 'package:lull/views/sound/widgets/sound_list.dart';
import 'package:lull/views/sound/widgets/sound_searchbar.dart';

import './widgets/sound_category.dart';

class SoundScreen extends ConsumerStatefulWidget {
  const SoundScreen({super.key});

  @override
  ConsumerState<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends ConsumerState<SoundScreen> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final soundList = ref.watch(audioProvider.select((s) => s.sounds));
    final soundLength = soundList.isNotEmpty;

    return MyScaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SoundHeader(),
              SoundSearchBar(
                controller: controller,
                hintText: l10n.homeSearchHint,
              ),
              SoundCategoryWidget(),
              SoundList(),
              SliverToBoxAdapter(
                child: SizedBox(height: DesignTokens.navHeightSpacing),
              ),
            ],
          ),
          if (soundLength)
            Positioned(
              bottom: DesignTokens.navHeightSpacing,
              right: DesignTokens.spacing6,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'soundMixerFab',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(DesignTokens.radiusXl),
                          ),
                        ),
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.only(
                              top: DesignTokens.spacing2,
                              bottom: DesignTokens.navHeightSpacing,
                            ),
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: DesignTokens.spacing6,
                                    left: DesignTokens.spacing5,
                                    right: DesignTokens.spacing5,
                                  ),
                                  child: SoundMixer(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.multitrack_audio_rounded),
                    label: Text('Mixer'),
                  ),
                  // Positioned sound length number
                  Positioned(
                    top: -DesignTokens.spacing3, // raised above button
                    right: -DesignTokens.spacing2, // a bit off right edge
                    child: CircleAvatar(
                      radius: DesignTokens.spacing3,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondaryContainer,
                      child: Text(
                        '${soundList.length}',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
