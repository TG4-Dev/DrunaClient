import 'package:druna_app/core/theme/druna_theme.dart';
import 'package:flutter/material.dart';

class DrunaButton extends StatelessWidget {
  const DrunaButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.secondary = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool secondary;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final content = loading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
    if (secondary) {
      return OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: style.copyWith(
          side: const WidgetStatePropertyAll(
            BorderSide(color: Color(0xFF49494F)),
          ),
        ),
        child: content,
      );
    }
    return FilledButton(
      onPressed: loading ? null : onPressed,
      style: style,
      child: content,
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 56, super.key});
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Druna',
    image: true,
    child: Text(
      'ü',
      style: TextStyle(
        fontSize: size,
        height: .7,
        fontWeight: FontWeight.w900,
        letterSpacing: -8,
      ),
    ),
  );
}

class DrunaAvatar extends StatelessWidget {
  const DrunaAvatar({
    required this.name,
    this.index = 0,
    this.size = 48,
    this.selected = false,
    this.imageUrl,
    super.key,
  });

  final String name;
  final int index;
  final double size;
  final bool selected;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final color = personPalette[index.abs() % personPalette.length];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: selected ? Colors.white : Colors.transparent,
          width: selected ? 2.5 : 0,
        ),
        boxShadow: selected
            ? [BoxShadow(color: color.withValues(alpha: .45), blurRadius: 18)]
            : null,
        image: imageUrl != null && imageUrl!.isNotEmpty
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      alignment: Alignment.center,
      child: imageUrl == null || imageUrl!.isEmpty
          ? Text(
              name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase(),
              style: TextStyle(
                fontSize: size * .35,
                fontWeight: FontWeight.w800,
              ),
            )
          : null,
    );
  }
}

class StatePanel extends StatelessWidget {
  const StatePanel({
    required this.title,
    required this.message,
    this.icon = Icons.cloud_off_rounded,
    this.onRetry,
    super.key,
  });
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: DrunaColors.surfaceRaised,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: DrunaColors.muted),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              child: DrunaButton(label: 'Повторить', onPressed: onRetry),
            ),
          ],
        ],
      ),
    ),
  );
}

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({required this.child, this.colors, super.key});
  final Widget child;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1.05),
          radius: 1.05,
          colors:
              colors ??
              [
                DrunaColors.accent.withValues(alpha: .28),
                DrunaColors.background,
              ],
          stops: const [0, .72],
        ),
      ),
      child: SafeArea(child: child),
    ),
  );
}

void showMessage(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? DrunaColors.coral : DrunaColors.surfaceRaised,
        behavior: SnackBarBehavior.floating,
      ),
    );
}
