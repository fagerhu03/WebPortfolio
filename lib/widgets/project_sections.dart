import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/portfolio_theme.dart';
import 'phone_gallery.dart';
import 'primitives.dart';

class FeaturedProject extends StatelessWidget {
  const FeaturedProject({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final narrow = box.maxWidth < 780;
      final p = context.colors;
      final details = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('GRADUATION PROJECT  /  2026'),
          const SizedBox(height: 15),
          Semantics(
            header: true,
            child: Text(
              featuredProject.name,
              style: TextStyle(
                fontSize: narrow ? 35 : 44,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
                height: 1.15,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const BodyCopy('A more thoughtful way\nto explore Egypt.', size: 21),
          const SizedBox(height: 27),
          _caseBlock(
            context,
            'THE CHALLENGE',
            'Travel planning is scattered across maps, search and recommendations. Finding useful local information can take people out of the experience.',
          ),
          const SizedBox(height: 19),
          _caseBlock(
            context,
            'THE APPROACH',
            'Bring personalized discovery, AI-assisted planning, camera-based landmark recognition and Google Maps into one Flutter companion.',
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              for (final feature in [
                'Travel community',
                'Arabic & English',
                'RTL support',
              ])
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_rounded, size: 16, color: p.accent),
                    const SizedBox(width: 6),
                    Text(
                      feature,
                      style: TextStyle(fontSize: 12, color: p.muted),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 25),
          Tags(featuredProject.tags),
          const SizedBox(height: 24),
          ExternalLink(
            'Explore the repository',
            featuredProject.repository!,
            outlined: true,
            icon: Icons.code_rounded,
          ),
        ],
      );
      final gallery = Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: RadialGradient(
            center: const Alignment(0, -.25),
            radius: .95,
            colors: [
              p.accent.withValues(alpha: .15),
              p.indigo.withValues(alpha: .045),
              p.surface,
            ],
          ),
        ),
        child: DynamicScrollMove(
          controller: controller,
          child: PhoneGallery(
            project: featuredProject,
            phoneWidth: narrow ? 222 : 238,
          ),
        ),
      );
      return SurfacePanel(
        padding: EdgeInsets.all(narrow ? 22 : 38),
        child: Column(
          children: [
            narrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [details, const SizedBox(height: 30), gallery],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: details),
                      const SizedBox(width: 38),
                      Expanded(flex: 5, child: gallery),
                    ],
                  ),
            const SizedBox(height: 28),
            Divider(color: p.line),
            const SizedBox(height: 23),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow('MY CONTRIBUTION'),
                  const SizedBox(height: 9),
                  const BodyCopy(contribution, size: 14),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
  Widget _caseBlock(BuildContext context, String title, String copy) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Eyebrow(title, color: context.colors.muted),
      const SizedBox(height: 7),
      BodyCopy(copy, size: 14),
    ],
  );
}

class MobileProjectCard extends StatelessWidget {
  const MobileProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.controller,
  });
  final PortfolioProject project;
  final int index;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final p = context.colors;
    final accents = [
      const Color(0xFFB99A58),
      const Color(0xFF7979CF),
      const Color(0xFF4D9D70),
      const Color(0xFFAF657A),
    ];
    return SurfacePanel(
      hover: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 413,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              gradient: RadialGradient(
                center: const Alignment(0, -.1),
                radius: .95,
                colors: [accents[index].withValues(alpha: .19), p.surface],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 22,
                  left: 24,
                  child: Text(
                    '0${index + 2}',
                    style: TextStyle(
                      color: p.muted,
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Center(
                  child: DynamicScrollMove(
                    controller: controller,
                    speed: 0.03, // Slight variations for multi-grid feel
                    child: PhoneGallery(project: project, phoneWidth: 164),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 8, 26, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(project.category),
                const SizedBox(height: 12),
                Semantics(
                  header: true,
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.6,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                BodyCopy(project.description, size: 14),
                const SizedBox(height: 20),
                Tags(project.tags),
                const SizedBox(height: 13),
                ExternalLink(
                  'View ${project.name} on GitHub',
                  project.repository!,
                  icon: Icons.arrow_outward_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OtherProjectCard extends StatelessWidget {
  const OtherProjectCard({
    super.key,
    required this.project,
    required this.icon,
  });
  final PortfolioProject project;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SurfacePanel(
    hover: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: context.colors.indigo),
        const SizedBox(height: 22),
        Eyebrow(project.category, color: context.colors.muted),
        const SizedBox(height: 10),
        Semantics(
          header: true,
          child: Text(
            project.name,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 12),
        BodyCopy(project.description, size: 14),
        const SizedBox(height: 22),
        Tags(project.tags),
      ],
    ),
  );
}
