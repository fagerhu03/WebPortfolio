import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../platform/browser.dart' as browser;
import '../theme/portfolio_theme.dart';

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: color ?? context.colors.accent,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.8,
      height: 1.6,
    ),
  );
}

class KeyboardSkipLink extends StatefulWidget {
  const KeyboardSkipLink({super.key, required this.onSkip});
  final VoidCallback onSkip;
  @override
  State<KeyboardSkipLink> createState() => _KeyboardSkipLinkState();
}

class _KeyboardSkipLinkState extends State<KeyboardSkipLink> {
  bool _focused = false;
  @override
  Widget build(BuildContext context) => Opacity(
    opacity: _focused ? 1 : 0,
    alwaysIncludeSemantics: true,
    child: IgnorePointer(
      ignoring: !_focused,
      child: FilledButton(
        onFocusChange: (value) => setState(() => _focused = value),
        onPressed: widget.onSkip,
        child: const Text('Skip to projects'),
      ),
    ),
  );
}

class BodyCopy extends StatelessWidget {
  const BodyCopy(this.text, {super.key, this.size = 15});
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(fontSize: size, height: 1.8, color: context.colors.muted),
  );
}

class Tags extends StatelessWidget {
  const Tags(this.tags, {super.key});
  final List<String> tags;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 7,
    runSpacing: 8,
    children: tags
        .map(
          (tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: context.colors.raised,
              border: Border.all(color: context.colors.line),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: context.colors.muted,
              ),
            ),
          ),
        )
        .toList(),
  );
}

class ExternalLink extends StatelessWidget {
  const ExternalLink(
    this.label,
    this.url, {
    super.key,
    this.primary = false,
    this.outlined = false,
    this.icon = Icons.arrow_outward_rounded,
  });
  final String label, url;
  final bool primary, outlined;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Semantics(
    link: true,
    child: Builder(
      builder: (context) {
        void follow() => browser.openUrl(url);
        if (primary) {
          return FilledButton.icon(
            onPressed: follow,
            icon: Icon(icon, size: 18),
            label: Text(label),
          );
        }
        if (outlined) {
          return OutlinedButton.icon(
            onPressed: follow,
            icon: Icon(icon, size: 17),
            label: Text(label),
          );
        }
        return TextButton.icon(
          onPressed: follow,
          icon: Icon(icon, size: 16),
          label: Text(label),
        );
      },
    ),
  );
}

class SurfacePanel extends StatefulWidget {
  const SurfacePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.hover = false,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool hover;
  @override
  State<SurfacePanel> createState() => _SurfacePanelState();
}

class _SurfacePanelState extends State<SurfacePanel> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) {
      if (widget.hover) {
        setState(() => _hovered = true);
      }
    },
    onExit: (_) {
      if (widget.hover) {
        setState(() => _hovered = false);
      }
    },
    child: AnimatedContainer(
      duration: context.reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 160),
      transform: Matrix4.translationValues(
        0,
        _hovered && !context.reduceMotion ? -3 : 0,
        0,
      ),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _hovered
              ? context.colors.accent.withValues(alpha: .65)
              : context.colors.line,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: _hovered ? 30 : 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: widget.child,
    ),
  );
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.columns = 2,
    this.breakpoint = 700,
    this.gap = 22,
  });
  final List<Widget> children;
  final int columns;
  final double breakpoint, gap;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final count = box.maxWidth < breakpoint ? 1 : columns;
      final width = (box.maxWidth - gap * (count - 1)) / count;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: children
            .map((child) => SizedBox(width: width, child: child))
            .toList(),
      );
    },
  );
}

/// A one-time entrance. No timers, looping animation or scroll polling.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.controller,
    required this.child,
  });
  final ScrollController controller;
  final Widget child;
  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_check);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (!mounted || _visible) {
      return;
    }
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) {
      return;
    }
    if (context.reduceMotion ||
        box.localToGlobal(Offset.zero).dy <
            MediaQuery.sizeOf(context).height + 60) {
      setState(() => _visible = true);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible || context.reduceMotion;
    final duration = context.reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 360);
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, .015),
      duration: duration,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: duration,
        alwaysIncludeSemantics: true,
        child: Focus(
          onFocusChange: (focused) {
            if (focused && !_visible) {
              setState(() => _visible = true);
            }
          },
          skipTraversal: true,
          child: widget.child,
        ),
      ),
    );
  }
}

class _ScrollPositionData extends ChangeNotifier {
  double translationY = 0.0;
  double tilt = 0.0;

  void update(double ty, double t) {
    if (translationY != ty || tilt != t) {
      translationY = ty;
      tilt = t;
      notifyListeners();
    }
  }
}

/// Dynamically transforms and tilts a widget based on its scroll position relative to the viewport.
/// Uses a frame-based dampening loop to deliver silky smooth performance on web browsers.
class DynamicScrollMove extends StatefulWidget {
  const DynamicScrollMove({
    super.key,
    required this.controller,
    required this.child,
    this.speed = -0.04,
    this.maxTranslation = 25.0,
    this.tiltSpeed = 0.00004,
    this.maxTilt = 0.02,
  });

  final ScrollController controller;
  final Widget child;
  final double speed;
  final double maxTranslation;
  final double tiltSpeed;
  final double maxTilt;

  @override
  State<DynamicScrollMove> createState() => _DynamicScrollMoveState();
}

class _DynamicScrollMoveState extends State<DynamicScrollMove> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _ScrollPositionData _data = _ScrollPositionData();

  double _currentTargetTranslationY = 0.0;
  double _currentTargetTilt = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    _ticker = createTicker(_onTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateTargets());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    _ticker.dispose();
    _data.dispose();
    super.dispose();
  }

  void _onScroll() {
    _updateTargets();
  }

  void _updateTargets() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;

    final viewHeight = MediaQuery.sizeOf(context).height;
    if (viewHeight <= 0) return;

    final position = box.localToGlobal(Offset.zero);
    final centerDiff = position.dy + (box.size.height / 2) - (viewHeight / 2);

    _currentTargetTranslationY = (centerDiff * widget.speed).clamp(-widget.maxTranslation, widget.maxTranslation);
    _currentTargetTilt = (centerDiff * widget.tiltSpeed).clamp(-widget.maxTilt, widget.maxTilt);

    if (!_ticker.isTicking) {
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    // A damping lerp factor handles chunky mouse wheel steps gracefully
    const double kLerpFactor = 0.12;

    final nextTranslationY = _data.translationY + (_currentTargetTranslationY - _data.translationY) * kLerpFactor;
    final nextTilt = _data.tilt + (_currentTargetTilt - _data.tilt) * kLerpFactor;

    final bool translationClose = (nextTranslationY - _currentTargetTranslationY).abs() < 0.01;
    final bool tiltClose = (nextTilt - _currentTargetTilt).abs() < 0.00001;

    if (translationClose && tiltClose) {
      _data.update(_currentTargetTranslationY, _currentTargetTilt);
      _ticker.stop();
    } else {
      _data.update(nextTranslationY, nextTilt);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return widget.child;

    return AnimatedBuilder(
      animation: _data,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(0.0, _data.translationY)
            ..rotateZ(_data.tilt),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
