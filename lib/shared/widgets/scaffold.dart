import 'package:flutter/material.dart';
import 'package:lull/core/theme/app_colors.dart';
import 'package:lull/shared/widgets/appbar.dart';

/// A reusable Scaffold widget for consistent app layout.
///
/// This widget wraps [Scaffold] and allows for optional customizations
/// such as appBar, body, floatingActionButton, etc.
/// By default, it applies a gradient background unless a [backgroundColor] is specified.
class MyScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final Widget? drawer;
  final bool extendBodyBehindAppBar;
  final String? title;

  const MyScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.backgroundColor,
    this.drawer,
    this.extendBodyBehindAppBar = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Default: always use gradient background unless a backgroundColor is provided
    return Scaffold(
      appBar: appBar ?? MyAppBar(title: title),
      body: backgroundColor == null
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.bottomCenter,
                  colors: AppColors.backgroundGradient,
                ),
              ),
              child: body,
            )
          : body,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
      drawer: drawer,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
