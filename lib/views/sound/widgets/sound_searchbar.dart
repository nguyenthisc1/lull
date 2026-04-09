import 'package:flutter/widgets.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/shared/widgets/searchbar.dart';

class SoundSearchBar extends StatelessWidget {
  const SoundSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacing6,
        DesignTokens.spacing5,
        DesignTokens.spacing6,
        DesignTokens.spacing3,
      ),
      sliver: SliverToBoxAdapter(
        child: SearchBarInput(controller: controller, hintText: hintText),
      ),
    );
  }
}
