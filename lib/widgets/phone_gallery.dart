import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/portfolio_data.dart';
import '../theme/portfolio_theme.dart';

class PhoneMockup extends StatelessWidget {
  const PhoneMockup({
    super.key,
    required this.screenshot,
    this.width = 205,
    this.project = '',
  });
  final AppScreenshot screenshot;
  final double width;
  final String project;
  @override
  Widget build(BuildContext context) {
    final picture = Image.asset(
      screenshot.asset,
      fit: BoxFit.contain,
      semanticLabel: '$project — ${screenshot.label}. Actual app screenshot.',
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, error, stack) => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Screenshot unavailable',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    // The Lost in Egypt source images already include a realistic phone.
    // Render the complete original; never wrap it in a second device frame.
    if (screenshot.framed) {
      return SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: 1408 / 2974,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .25),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: picture,
          ),
        ),
      );
    }
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF11151B),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF75818F), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .28),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: ColoredBox(
              color: Colors.black,
              child: AspectRatio(aspectRatio: .478, child: picture),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepScreenshot extends Intent {
  const _StepScreenshot(this.delta);
  final int delta;
}

class PhoneGallery extends StatefulWidget {
  const PhoneGallery({super.key, required this.project, this.phoneWidth = 230});
  final PortfolioProject project;
  final double phoneWidth;
  @override
  State<PhoneGallery> createState() => _PhoneGalleryState();
}

class _PhoneGalleryState extends State<PhoneGallery> {
  int _index = 0;
  final _galleryFocus = FocusNode(debugLabel: 'Screenshot gallery');
  void _step(int delta) {
    setState(
      () => _index = (_index + delta) % widget.project.screenshots.length,
    );
    _galleryFocus.requestFocus();
  }

  @override
  void dispose() {
    _galleryFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shots = widget.project.screenshots;
    if (shots.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text('App screenshots coming soon · Placeholder')),
      );
    }
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowLeft): _StepScreenshot(-1),
        SingleActivator(LogicalKeyboardKey.arrowRight): _StepScreenshot(1),
      },
      child: Actions(
        actions: {
          _StepScreenshot: CallbackAction<_StepScreenshot>(
            onInvoke: (intent) {
              _step(intent.delta);
              return null;
            },
          ),
        },
        child: Focus(
          focusNode: _galleryFocus,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: context.reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                child: PhoneMockup(
                  key: ValueKey(shots[_index].asset),
                  screenshot: shots[_index],
                  width: widget.phoneWidth,
                  project: widget.project.name,
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                liveRegion: true,
                child: Text(
                  shots[_index].label,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (shots.length > 1) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _step(-1),
                      tooltip: 'Previous ${widget.project.name} screenshot',
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    ),
                    Flexible(
                      child: Semantics(
                        label: 'Screenshot ${_index + 1} of ${shots.length}',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${(_index + 1).toString().padLeft(2, '0')} / ${shots.length.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.colors.muted,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _step(1),
                      tooltip: 'Next ${widget.project.name} screenshot',
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
