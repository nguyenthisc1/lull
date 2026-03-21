import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lull/core/constants/app_images.dart';
import 'package:lull/shared/widgets/scaffold.dart';
import 'package:lull/shared/widgets/searchbar.dart';

import '../../core/constants/design_tokens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    return MyScaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HomeSearchBar(controller: controller, hintText: l10n.homeSearchHint),
          const SliverToBoxAdapter(child: _GreetingHeader()),
          _HomeCategorySection(
            cards: [
              _CategoryCardParams(
                imagePath: AppImages.imgRain3,
                title: l10n.homeRainTitle,
                description: l10n.homeRainDescription,
                height: 250,
              ),
              _CategoryCardParams(
                imagePath: AppImages.imgNature4,
                title: l10n.homeNatureTitle,
                description: l10n.homeNatureDescription,
              ),
              _CategoryCardParams(
                center: true,
                title: l10n.homeWhiteNoiseTitle,
                description: l10n.homeWhiteNoiseDescription,
              ),
              _CategoryCardParams(
                imagePath: AppImages.imgThunder1,
                title: l10n.homeThunderTitle,
                description: l10n.homeThunderDescription,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Components ──────────────────────────────────────────────────────────────

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar({required this.controller, required this.hintText});

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

class _HomeCategorySection extends StatelessWidget {
  const _HomeCategorySection({required this.cards});

  final List<_CategoryCardParams> cards;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        ...cards.map(
          (params) => Padding(
            padding: const EdgeInsets.fromLTRB(
              DesignTokens.spacing6,
              DesignTokens.spacing5,
              DesignTokens.spacing6,
              DesignTokens.spacing3,
            ),
            child: _CategoryCard(
              imagePath: params.imagePath,
              title: params.title,
              description: params.description,
              width: params.width,
              height: params.height,
              center: params.center,
            ),
          ),
        ),
      ]),
    );
  }
}

class _CategoryCardParams {
  final String? imagePath;
  final String title;
  final String description;
  final double width;
  final double height;
  final bool center;
  _CategoryCardParams({
    this.imagePath,
    required this.title,
    required this.description,
    this.width = double.infinity,
    this.height = 360,
    this.center = false,
  });
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    this.imagePath,
    required this.title,
    required this.description,
    this.width = double.infinity,
    this.height = 360,
    this.center = false,
  });

  final String? imagePath;
  final String title;
  final String description;
  final double width;
  final double height;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXxl),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imagePath != null && imagePath!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radiusXxl),
              child: Image.asset(
                imagePath!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: AppColors.primaryGradient2,
                ),
              ),
            ),
          if (center)
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.displaySmall.copyWith(
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing1),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: AppTypography.titleSmall.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          else
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.62),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(DesignTokens.radiusXxl),
                    bottomRight: Radius.circular(DesignTokens.radiusXxl),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  DesignTokens.spacing6,
                  DesignTokens.spacing6,
                  DesignTokens.spacing6,
                  DesignTokens.spacing6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.displaySmall.copyWith(
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacing1),
                    Text(
                      description,
                      style: AppTypography.titleSmall.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Greeting header ──────────────────────────────────────────────────────────
class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(
        DesignTokens.spacing6,
        topPadding + DesignTokens.spacing6,
        DesignTokens.spacing6,
        DesignTokens.spacing5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeSubtitle,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 5,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing3),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: l10n.homeTitleMain,
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: l10n.homeTitlePrimary,
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
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
