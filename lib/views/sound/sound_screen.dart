import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/l10n/app_localizations.dart';
import 'package:lull/shared/widgets/scaffold.dart';
import 'package:lull/views/sound/widgets/search_bar.dart';
import 'package:lull/views/sound/widgets/sound_header.dart';
import 'package:lull/views/sound/widgets/sound_list.dart';

import './widgets/sound_category.dart';

class SoundScreen extends ConsumerStatefulWidget {
  const SoundScreen({super.key});

  @override
  ConsumerState<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends ConsumerState<SoundScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    return MyScaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SoundHeader(),
          SearchBar(controller: controller, hintText: l10n.homeSearchHint),
          SoundCategoryWidget(),
          SoundList(),
          SliverToBoxAdapter(
            child: SizedBox(height: DesignTokens.navHeightSpacing),
          ),
        ],
      ),
    );
  }
}
