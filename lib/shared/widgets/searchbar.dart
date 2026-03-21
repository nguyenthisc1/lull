import 'package:flutter/material.dart';
import 'package:lull/core/constants/design_tokens.dart';
import 'package:lull/core/theme/app_colors.dart';

class SearchBarInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SearchBarInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search...',
  });

  @override
  State<SearchBarInput> createState() => _SearchBarInputState();
}

class _SearchBarInputState extends State<SearchBarInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final textColor = baseColor.withValues(alpha: .2);
    final iconColor = _isFocused ? baseColor : textColor;

    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: textColor),
        prefixIcon: Icon(Icons.search, color: iconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.primary.withValues(alpha: 0.04), // Transparent background
        contentPadding: const EdgeInsets.symmetric(
          vertical: DesignTokens.spacing5,
          horizontal: DesignTokens.spacing3,
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
