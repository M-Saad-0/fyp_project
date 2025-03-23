import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownWidgetCustom extends StatelessWidget {
  final String markdownData;
  const MarkdownWidgetCustom({super.key, required this.markdownData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SelectionArea(
      child: Markdown(
        physics: NeverScrollableScrollPhysics(),
        data: markdownData,
        shrinkWrap: true,
        styleSheet: MarkdownStyleSheet(
          h1: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          h2: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          h3: TextStyle(
            color: theme.colorScheme.surfaceContainerLow ?? Colors.teal, // For newer themes
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          p: TextStyle(
            color: theme.textTheme.bodyLarge?.color ?? Colors.black87,
            fontSize: 16,
          ),
          blockquote: TextStyle(
            color: theme.hintColor,
            fontStyle: FontStyle.italic,
            backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          ),
          code: TextStyle(
            backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
            color: theme.colorScheme.error,
            fontFamily: 'monospace',
            fontSize: 14,
          ),
          listBullet: TextStyle(
            color: theme.colorScheme.primaryContainer,
            fontSize: 18,
          ),
          a: TextStyle(
            color: theme.colorScheme.secondary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
