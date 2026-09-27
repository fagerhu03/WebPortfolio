import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../data/portfolio_data.dart';
import '../platform/browser.dart' as browser;
import '../theme/portfolio_theme.dart';
import '../widgets/phone_gallery.dart';
import '../widgets/primitives.dart';
import '../widgets/project_sections.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({
    super.key,
    required this.dark,
    required this.onThemeChanged,
  });
  final bool dark;
  final VoidCallback onThemeChanged;
  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();
  final _keys = List.generate(8, (_) => GlobalKey());
  final _focus = List.generate(8, (_) => FocusNode());
  static const _ids = [
    'top',
    'work',
    'more-projects',
    'about',
    'skills',
    'experience',
    'education',
    'contact',
  ];
  static const _navigation = [
    (1, 'Work'),
    (3, 'About'),
    (4, 'Toolkit'),
    (5, 'Journey'),
    (7, 'Contact'),
  ];
  int _active = 0;
  @override
  void initState() {
    super.initState();
    _scroll.addListener(_trackSection);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = _ids.indexOf(browser.currentSection());
      if (index > 0) {
        _goTo(index, instant: true);
      }
    });
  }

  double _offset(int index) {
    final render = _keys[index].currentContext?.findRenderObject();
    if (render == null) {
      return 0;
    }
    return RenderAbstractViewport.of(
      render,
    ).getOffsetToReveal(render, 0).offset;
  }

  void _trackSection() {
    if (!_scroll.hasClients) {
      return;
    }
    int current = 0;
    for (var i = 1; i < _keys.length; i++) {
      if (_offset(i) <= _scroll.offset + 155) {
        current = i;
      }
    }
    if (_scroll.position.extentAfter < 40) {
      current = 7;
    }
    if (_active != current && mounted) {
      setState(() => _active = current);
    }
  }

  Future<void> _goTo(int index, {bool instant = false}) async {
    if (!_scroll.hasClients) {
      return;
    }
    final target = (_offset(index) - 110).clamp(
      0.0,
      _scroll.position.maxScrollExtent,
    );
    browser.setSection(_ids[index]);
    if (instant || context.reduceMotion) {
      _scroll.jumpTo(target);
    } else {
      await _scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    }
    if (mounted) {
      _focus[index].requestFocus();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    for (final node in _focus) {
      node.dispose();
    }
    super.dispose();
  }

  Widget _anchor(int index, Widget child) => Focus(
    key: _keys[index],
    focusNode: _focus[index],
    skipTraversal: true,
    child: child,
  );
  Widget _reveal(Widget child) =>
      ScrollReveal(controller: _scroll, child: child);
  @override
  Widget build(BuildContext context) {
    final p = context.colors;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, box) {
          final mobile = box.maxWidth < 720;
          final gutter = mobile ? 22.0 : 48.0;
          return Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(.8, -1),
                      radius: 1,
                      colors: [p.indigo.withValues(alpha: .055), p.background],
                      stops: const [0, .65],
                    ),
                  ),
                ),
              ),
              Scrollbar(
                controller: _scroll,
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1240),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: gutter),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 132),
                            _anchor(0, _reveal(_hero(mobile))),
                            _anchor(
                              1,
                              _section(
                                '01 / SELECTED WORK',
                                'Built with purpose.',
                                'Mobile experiences that bring thoughtful interfaces and practical engineering together.',
                                [
                                  _reveal(FeaturedProject(controller: _scroll)),
                                  const SizedBox(height: 24),
                                  ResponsiveGrid(
                                    children: [
                                      for (
                                        var i = 0;
                                        i < mobileProjects.length;
                                        i++
                                      )
                                        _reveal(
                                          MobileProjectCard(
                                            project: mobileProjects[i],
                                            index: i,
                                            controller: _scroll,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            _anchor(
                              2,
                              _section(
                                '02 / BEYOND MOBILE',
                                'Curiosity, in practice.',
                                'Explorations across intelligent software, connected hardware and the cloud.',
                                [
                                  ResponsiveGrid(
                                    children: [
                                      for (
                                        var i = 0;
                                        i < otherProjects.length;
                                        i++
                                      )
                                        _reveal(
                                          OtherProjectCard(
                                            project: otherProjects[i],
                                            icon: [
                                              Icons.auto_awesome_outlined,
                                              Icons.sensors_rounded,
                                              Icons.cloud_outlined,
                                              Icons.center_focus_strong_rounded,
                                            ][i],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            _anchor(
                              3,
                              _section(
                                '03 / ABOUT',
                                'An engineer. A curious builder.',
                                null,
                                [_creativeAbout(mobile)],
                              ),
                            ),
                            _anchor(
                              4,
                              _section(
                                '04 / TOOLKIT',
                                'The tools behind the work.',
                                'A Flutter foundation, with the skills to connect mobile experiences to data and intelligent systems.',
                                [
                                  _reveal(
                                    ResponsiveGrid(
                                      columns: 3,
                                      breakpoint: 860,
                                      children: [
                                        for (
                                          var i = 0;
                                          i < skillGroups.length;
                                          i++
                                        )
                                          SurfacePanel(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  [
                                                    Icons.phone_android_rounded,
                                                    Icons.hub_outlined,
                                                    Icons.psychology_outlined,
                                                    Icons.emoji_objects_outlined,
                                                  ][i < 4 ? i : 0],
                                                  color: p.accent,
                                                  size: 27,
                                                ),
                                                const SizedBox(height: 23),
                                                Text(
                                                  skillGroups[i].$1,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                                const SizedBox(height: 23),
                                                for (final skill
                                                    in skillGroups[i].$2)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 14,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check_rounded,
                                                          size: 15,
                                                          color: p.accent,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            skill,
                                                            style: TextStyle(
                                                              color: p.muted,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _anchor(
                              5,
                              _section(
                                '05 / THE JOURNEY',
                                'Learning through building.',
                                'Focused training, practical projects and a growing engineering foundation.',
                                [_reveal(_training(mobile))],
                              ),
                            ),
                            _anchor(
                              6,
                              _section(
                                '06 / EDUCATION',
                                'A foundation in engineering.',
                                null,
                                [_reveal(_education(mobile))],
                              ),
                            ),
                            _anchor(7, _contact(mobile)),
                            const SizedBox(height: 60),
                            Divider(color: p.line),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 26),
                              child: Wrap(
                                spacing: 30,
                                runSpacing: 12,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '© 2026 Fager Hussein Ahmed',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: p.muted,
                                    ),
                                  ),
                                  Text(
                                    'Thoughtfully built with Flutter Web.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: p.muted,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => _goTo(0),
                                    label: const Text('Back to top'),
                                    icon: const Icon(
                                      Icons.arrow_upward,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: mobile ? 12 : 32,
                right: mobile ? 12 : 32,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: _header(
                      box.maxWidth < 1000 ||
                          MediaQuery.textScalerOf(context).scale(14) > 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 94,
                left: 24,
                child: KeyboardSkipLink(onSkip: () => _goTo(1)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(bool compact) {
    final p = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: p.surface.withValues(alpha: .98),
        border: Border.all(color: p.line),
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: p.shadow,
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Tooltip(
            message: 'Back to top',
            child: TextButton(
              onPressed: () => _goTo(0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: p.softAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'FA',
                      style: TextStyle(
                        color: p.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  if (MediaQuery.sizeOf(context).width >= 420 &&
                      MediaQuery.textScalerOf(context).scale(14) < 20) ...[
                    const SizedBox(width: 10),
                    Text(
                      'Fager Ahmed',
                      style: TextStyle(
                        color: p.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Spacer(),
          if (!compact) ...[
            for (final nav in _navigation)
              TextButton(
                onPressed: () => _goTo(nav.$1),
                style: TextButton.styleFrom(
                  foregroundColor: _active == nav.$1 ? p.accent : p.muted,
                ),
                child: Text(nav.$2),
              ),
            const SizedBox(width: 16),
          ],
          Semantics(
            toggled: widget.dark,
            label: 'Dark theme',
            child: IconButton(
              key: const ValueKey('theme-toggle'),
              tooltip: widget.dark
                  ? 'Switch to light mode'
                  : 'Switch to dark mode',
              onPressed: widget.onThemeChanged,
              icon: Icon(
                widget.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                size: 21,
              ),
            ),
          ),
          if (compact)
            PopupMenuButton<int>(
              tooltip: 'Open navigation',
              icon: const Icon(Icons.menu_rounded),
              onSelected: (i) => _goTo(i),
              itemBuilder: (_) => [
                for (final nav in _navigation)
                  PopupMenuItem(value: nav.$1, child: Text(nav.$2)),
                const PopupMenuItem(value: 6, child: Text('Education')),
              ],
            ),
        ],
      ),
    );
  }

  Widget _hero(bool mobile) {
    final p = context.colors;
    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: p.softAccent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: p.accent.withValues(alpha: .22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 6, color: p.accent),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Open to junior developer opportunities',
                  style: TextStyle(
                    color: p.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Semantics(
          header: true,
          headingLevel: 1,
          child: Text(
            'Fager\nHussein Ahmed.',
            style: TextStyle(
              fontSize: mobile ? 43 : 65,
              height: 1.08,
              fontWeight: FontWeight.w800,
              letterSpacing: mobile ? -1.8 : -3,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Flutter Developer &\nSoftware Engineer',
          style: TextStyle(
            fontSize: mobile ? 21 : 24,
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: p.accent,
            letterSpacing: -.4,
          ),
        ),
        const SizedBox(height: 18),
        const ConstrainedBody(
          'I build useful mobile experiences with Flutter, clear architecture and a curiosity for intelligent technology.',
        ),
        const SizedBox(height: 29),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () => _goTo(1),
              label: const Text('Explore Projects'),
              icon: const Icon(Icons.arrow_downward_rounded, size: 18),
            ),
            const ExternalLink('GitHub', github, icon: Icons.code_rounded),
            const ExternalLink('LinkedIn', linkedin),
          ],
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, box) => box.maxWidth < 820
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    intro,
                    const SizedBox(height: 32),
                    _heroVisual(mobile),
                  ],
                )
              : Row(
                  children: [
                    Expanded(flex: 6, child: intro),
                    const SizedBox(width: 30),
                    Expanded(flex: 4, child: _heroVisual(false)),
                  ],
                ),
        ),
        const SizedBox(height: 36),
        Divider(color: p.line),
        const SizedBox(height: 17),
        Wrap(
          spacing: 35,
          runSpacing: 12,
          children: [
            Eyebrow('MOBILE FIRST', color: p.muted),
            Eyebrow('THOUGHTFULLY ENGINEERED', color: p.muted),
            Eyebrow('BASED IN GIZA, EGYPT', color: p.muted),
          ],
        ),
      ],
    );
  }

  Widget _heroVisual(bool mobile) {
    final p = context.colors;
    return SizedBox(
      height: mobile ? 375 : 460,
      child: LayoutBuilder(
        builder: (context, box) => Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    p.accent.withValues(alpha: .12),
                    p.indigo.withValues(alpha: .07),
                    p.background.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: p.line.withValues(alpha: .65)),
              ),
            ),
            DynamicScrollMove(
              controller: _scroll,
              speed: -0.05,
              maxTranslation: 30.0,
              tiltSpeed: 0.00005,
              maxTilt: 0.025,
              child: Transform.rotate(
                angle: .035,
                child: PhoneMockup(
                  screenshot: featuredProject.screenshots.first,
                  width: mobile ? 151 : 188,
                  project: 'Lost in Egypt',
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: mobile ? 30 : 48,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: p.surface,
                  border: Border.all(color: p.line),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    FlutterLogo(size: 18, style: FlutterLogoStyle.markOnly),
                    const SizedBox(width: 8),
                    Text(
                      'Made with Flutter',
                      style: TextStyle(
                        color: p.text,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: mobile ? 8 : 15,
              child: Container(
                width: 225,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: p.surface,
                  border: Border.all(color: p.line),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: p.shadow,
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('A CLOSER LOOK'),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Lost in Egypt',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: p.text,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Explore Lost in Egypt',
                          onPressed: () => _goTo(1),
                          icon: Icon(
                            Icons.arrow_outward,
                            color: p.accent,
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Travel, with a little intelligence.',
                      style: TextStyle(fontSize: 10, color: p.muted),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(
    String label,
    String title,
    String? description,
    List<Widget> content,
  ) => Padding(
    padding: const EdgeInsets.only(top: 100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow(label),
        const SizedBox(height: 15),
        Semantics(
          header: true,
          child: Text(
            title,
            style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).width < 720 ? 30 : 39,
              height: 1.22,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
            ),
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 15),
          ConstrainedBody(description),
        ],
        const SizedBox(height: 33),
        ...content,
      ],
    ),
  );

  Widget _creativeAbout(bool mobile) {
    return CreativeAboutSection(controller: _scroll, mobile: mobile);
  }

  Widget _training(bool mobile) => SurfacePanel(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
    child: Column(
      children: [
        for (var i = 0; i < training.length; i++)
          TimelineJourneyItem(
            controller: _scroll,
            year: training[i].$1,
            title: training[i].$2,
            institution: training[i].$3,
            description: training[i].$4,
            isFirst: i == 0,
            isLast: i == training.length - 1,
            mobile: mobile,
          ),
      ],
    ),
  );

  Widget _education(bool mobile) => SurfacePanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.school_outlined, size: 30, color: context.colors.accent),
        const SizedBox(height: 20),
        const Eyebrow('2021 — 2026'),
        const SizedBox(height: 12),
        const Text(
          'B.Sc. in Computer & Software Engineering',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        const BodyCopy('Misr University for Science and Technology'),
        const SizedBox(height: 22),
        const Tags(['Graduated with honors', 'GPA 3.24 / 4.00']),
      ],
    ),
  );

  Widget _contact(bool mobile) {
    final p = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 104),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(mobile ? 25 : 48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          border: Border.all(color: p.accent.withValues(alpha: .25)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [p.softAccent, p.surface, p.indigo.withValues(alpha: .075)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('07 / LET’S CONNECT'),
            const SizedBox(height: 18),
            Semantics(
              header: true,
              child: Text(
                'Good things start\nwith a conversation.',
                style: TextStyle(
                  fontSize: mobile ? 32 : 46,
                  fontWeight: FontWeight.w800,
                  height: 1.16,
                  letterSpacing: -1.5,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const ConstrainedBody(
              'Have a junior developer role or a project in mind? I’d love to hear about it.',
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                ExternalLink(
                  'Let’s talk',
                  email,
                  primary: true,
                  icon: Icons.mail_outline_rounded,
                ),
                ExternalLink('LinkedIn', linkedin, outlined: true),
                ExternalLink(
                  'GitHub',
                  github,
                  outlined: true,
                  icon: Icons.code_rounded,
                ),
              ],
            ),
            const SizedBox(height: 27),
            SelectableText(
              'fagerhu03@gmail.com',
              style: TextStyle(color: p.text, fontSize: 14),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: p.muted),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Giza, Egypt',
                    style: TextStyle(color: p.muted, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConstrainedBody extends StatelessWidget {
  const ConstrainedBody(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 580),
    child: BodyCopy(text, size: 16),
  );
}

class CreativeAboutSection extends StatefulWidget {
  const CreativeAboutSection({super.key, required this.controller, required this.mobile});
  final ScrollController controller;
  final bool mobile;

  @override
  State<CreativeAboutSection> createState() => _CreativeAboutSectionState();
}

class _CreativeAboutSectionState extends State<CreativeAboutSection> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkScroll);
    super.dispose();
  }

  void _checkScroll() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final viewHeight = MediaQuery.sizeOf(context).height;
    final position = box.localToGlobal(Offset.zero);

    if (position.dy < viewHeight * 0.85 && !_isVisible) {
      setState(() => _isVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.colors;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _animatedParagraph(
          'I’m a Computer & Software Engineering graduate who enjoys turning useful ideas into maintainable mobile applications.',
          19,
          0,
        ),
        const SizedBox(height: 24),
        _animatedParagraph(
          'Flutter is my main focus. My interests also span AI, computer vision, cloud computing and IoT—especially where these technologies can make everyday mobile experiences more helpful.',
          15,
          200,
        ),
        const SizedBox(height: 24),
        _animatedParagraph(
          'I’m looking for a junior Flutter, mobile development or software engineering role where I can contribute, keep learning and build with a thoughtful team.',
          15,
          400,
        ),
        const SizedBox(height: 32),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          opacity: _isVisible ? 1.0 : 0.0,
          child: const Tags([
            'Useful experiences',
            'Maintainable code',
            'Always learning',
          ]),
        ),
      ],
    );

    final portrait = Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
          width: _isVisible ? 280 : 0,
          height: _isVisible ? 400 : 0,
          decoration: BoxDecoration(
            color: p.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        AnimatedScale(
          scale: _isVisible ? 1.0 : 0.8,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          child: AnimatedRotation(
            turns: _isVisible ? 0 : -0.02,
            duration: const Duration(milliseconds: 800),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/Fager_pic.jpg',
                    width: 260,
                    height: 280,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    semanticLabel: 'Portrait of Fager Hussein Ahmed',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Fager Hussein Ahmed',
                  style: TextStyle(color: p.text, fontWeight: FontWeight.w900, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  'Engineer by training. Builder by nature.',
                  style: TextStyle(color: p.muted, fontSize: 12, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: widget.mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                copy,
                const SizedBox(height: 60),
                Center(child: portrait),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 7, child: copy),
                const SizedBox(width: 80),
                Expanded(flex: 4, child: portrait),
              ],
            ),
    );
  }

  Widget _animatedParagraph(String text, double size, int delayMs) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 800 + delayMs),
      padding: EdgeInsets.only(top: _isVisible ? 0 : 20),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 800 + delayMs),
        opacity: _isVisible ? 1.0 : 0.0,
        child: BodyCopy(text, size: size),
      ),
    );
  }
}

/// A stateful timeline component that tracks scroll offsets to build an
/// interactive vertical journey tracker with dynamically responsive nodes.
class TimelineJourneyItem extends StatefulWidget {
  const TimelineJourneyItem({
    super.key,
    required this.controller,
    required this.year,
    required this.title,
    required this.institution,
    required this.description,
    required this.isFirst,
    required this.isLast,
    required this.mobile,
  });

  final ScrollController controller;
  final String year;
  final String title;
  final String institution;
  final String description;
  final bool isFirst;
  final bool isLast;
  final bool mobile;

  @override
  State<TimelineJourneyItem> createState() => _TimelineJourneyItemState();
}

class _TimelineJourneyItemState extends State<TimelineJourneyItem> {
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkPosition);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPosition());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkPosition);
    super.dispose();
  }

  void _checkPosition() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;

    final viewHeight = MediaQuery.sizeOf(context).height;
    if (viewHeight <= 0) return;

    final position = box.localToGlobal(Offset.zero);
    final activeThreshold = viewHeight * 0.76;
    final active = position.dy < activeThreshold;

    if (_isActive != active) {
      setState(() {
        _isActive = active;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.colors;
    const duration = Duration(milliseconds: 320);

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: duration,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            height: 1.4,
            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
            color: _isActive ? p.text : p.text.withValues(alpha: 0.45),
          ),
          child: Text(widget.title),
        ),
        const SizedBox(height: 5),
        Text(
          widget.institution,
          style: TextStyle(
            fontSize: 14,
            color: _isActive ? p.accent : p.accent.withValues(alpha: 0.45),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedOpacity(
          duration: duration,
          opacity: _isActive ? 1.0 : 0.4,
          child: BodyCopy(widget.description, size: 14),
        ),
      ],
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: widget.mobile ? 44 : 64,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    color: p.line.withValues(alpha: 0.45),
                  ),
                ),
                if (_isActive)
                  Positioned(
                    top: 0,
                    bottom: widget.isLast ? null : 0,
                    height: widget.isLast ? 24 : null,
                    child: Container(
                      width: 2,
                      color: p.accent,
                    ),
                  ),
                Positioned(
                  top: 24,
                  child: AnimatedContainer(
                    duration: duration,
                    width: _isActive ? 15 : 11,
                    height: _isActive ? 15 : 11,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isActive ? p.accent : p.surface,
                      border: Border.all(
                        color: _isActive ? p.accent : p.line,
                        width: _isActive ? 4 : 2,
                      ),
                      boxShadow: _isActive
                          ? [
                              BoxShadow(
                                color: p.accent.withValues(alpha: 0.35),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedPadding(
              duration: duration,
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: _isActive ? 4 : 14,
              ),
              child: AnimatedOpacity(
                duration: duration,
                opacity: _isActive ? 1.0 : 0.35,
                child: widget.mobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Eyebrow(widget.year, color: _isActive ? p.accent : p.muted),
                          const SizedBox(height: 6),
                          details,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Eyebrow(widget.year, color: _isActive ? p.accent : p.muted),
                          ),
                          Expanded(child: details),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
