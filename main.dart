import 'package:flutter/material.dart';

void main() {
  runApp(const NehemiahApp());
}

class NehemiahApp extends StatelessWidget {
  const NehemiahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Nehemiah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0E1621),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC7A45D),
          brightness: Brightness.dark,
        ),
      ),
      home: const ScriptureFeedScreen(),
    );
  }
}

enum ExperienceType { verse, story, prayer, reflection }

class ScriptureExperience {
  const ScriptureExperience({
    required this.type,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.reference,
    required this.passage,
    required this.gradient,
    this.callToAction = 'Read the passage',
  });

  final ExperienceType type;
  final String eyebrow;
  final String title;
  final String body;
  final String reference;
  final String passage;
  final List<Color> gradient;
  final String callToAction;
}

const experiences = <ScriptureExperience>[
  ScriptureExperience(
    type: ExperienceType.verse,
    eyebrow: 'VERSE',
    title: 'Be still.',
    body: '“Be still, and know that I am God.”',
    reference: 'Psalm 46:10',
    passage:
        'God is our refuge and strength, a very present help in trouble. Therefore we will not fear, though the earth gives way...',
    gradient: [
      Color(0xFF102331),
      Color(0xFF304A52),
      Color(0xFF8A7655),
    ],
  ),
  ScriptureExperience(
    type: ExperienceType.story,
    eyebrow: 'JONAH • EPISODE 1',
    title: 'The call',
    body:
        'God told Jonah to go to Nineveh and speak against its wickedness. Jonah now faced a choice: obey—or run.',
    reference: 'Jonah 1:1–2',
    passage:
        'Now the word of the Lord came to Jonah the son of Amittai, saying, “Arise, go to Nineveh, that great city, and call out against it...”',
    gradient: [
      Color(0xFF101827),
      Color(0xFF243B50),
      Color(0xFF6B5846),
    ],
    callToAction: 'Continue the story',
  ),
  ScriptureExperience(
    type: ExperienceType.prayer,
    eyebrow: 'PRAYER',
    title: 'When obedience feels difficult',
    body:
        'God, give me the courage to follow where You lead. Help me trust Your wisdom when obedience is uncomfortable.',
    reference: 'A prayer inspired by Jonah 1',
    passage:
        'Pause for a moment. Name one area where you know the faithful next step, then ask God for courage to take it.',
    gradient: [
      Color(0xFF2B2031),
      Color(0xFF53425E),
      Color(0xFF8D756C),
    ],
    callToAction: 'Take a prayer break',
  ),
  ScriptureExperience(
    type: ExperienceType.reflection,
    eyebrow: 'REFLECTION',
    title: 'What are you running from?',
    body:
        'Jonah’s first response was escape. Where might fear, comfort, or pride be pulling you away from obedience?',
    reference: 'Reflect on Jonah 1:3',
    passage:
        'Write down the first honest answer that comes to mind. You do not need to solve everything today—just bring it into the light.',
    gradient: [
      Color(0xFF17211C),
      Color(0xFF31453B),
      Color(0xFF7B806A),
    ],
    callToAction: 'Reflect for one minute',
  ),
];

class ScriptureFeedScreen extends StatefulWidget {
  const ScriptureFeedScreen({super.key});

  @override
  State<ScriptureFeedScreen> createState() => _ScriptureFeedScreenState();
}

class _ScriptureFeedScreenState extends State<ScriptureFeedScreen> {
  final Set<int> _saved = <int>{};
  int _currentIndex = 0;

  void _toggleSaved(int index) {
    setState(() {
      if (_saved.contains(index)) {
        _saved.remove(index);
      } else {
        _saved.add(index);
      }
    });
  }

  void _showPassage(ScriptureExperience experience) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF7F0E4),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Text(
                  experience.reference,
                  style: const TextStyle(
                    color: Color(0xFF8A6D35),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  experience.title,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontSize: 30,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  experience.passage,
                  style: const TextStyle(
                    color: Color(0xFF344054),
                    fontSize: 18,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'AI-generated visuals are artistic interpretations. Scripture remains the source of truth.',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showShareMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing will be connected after the core beta is stable.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: experiences.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final experience = experiences[index];
          return ExperienceCard(
            experience: experience,
            isSaved: _saved.contains(index),
            pageNumber: index + 1,
            pageCount: experiences.length,
            onSave: () => _toggleSaved(index),
            onShare: _showShareMessage,
            onRead: () => _showPassage(experience),
          );
        },
      ),
      bottomNavigationBar: FeedNavigation(
        activeIndex: _currentIndex,
        savedCount: _saved.length,
      ),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({
    super.key,
    required this.experience,
    required this.isSaved,
    required this.pageNumber,
    required this.pageCount,
    required this.onSave,
    required this.onShare,
    required this.onRead,
  });

  final ScriptureExperience experience;
  final bool isSaved;
  final int pageNumber;
  final int pageCount;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onRead;

  IconData get _typeIcon {
    switch (experience.type) {
      case ExperienceType.verse:
        return Icons.menu_book_rounded;
      case ExperienceType.story:
        return Icons.movie_filter_rounded;
      case ExperienceType.prayer:
        return Icons.favorite_rounded;
      case ExperienceType.reflection:
        return Icons.lightbulb_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: experience.gradient,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const Positioned.fill(child: AtmosphericOverlay()),
            Positioned(
              left: 22,
              right: 82,
              bottom: 94,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_typeIcon, size: 16, color: const Color(0xFFE3C989)),
                      const SizedBox(width: 8),
                      Text(
                        experience.eyebrow,
                        style: const TextStyle(
                          color: Color(0xFFE3C989),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    experience.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      height: 1.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    experience.body,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    experience.reference,
                    style: const TextStyle(
                      color: Color(0xFFF7F0E4),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: onRead,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFF7F0E4),
                      foregroundColor: const Color(0xFF101828),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(experience.callToAction),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 15,
              bottom: 116,
              child: Column(
                children: [
                  ActionButton(
                    icon: isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    label: isSaved ? 'Saved' : 'Save',
                    onPressed: onSave,
                  ),
                  const SizedBox(height: 18),
                  ActionButton(
                    icon: Icons.ios_share_rounded,
                    label: 'Share',
                    onPressed: onShare,
                  ),
                  const SizedBox(height: 18),
                  ActionButton(
                    icon: Icons.menu_book_rounded,
                    label: 'Read',
                    onPressed: onRead,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 18,
              left: 22,
              right: 22,
              child: Row(
                children: [
                  const Text(
                    'PROJECT NEHEMIAH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$pageNumber / $pageCount',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AtmosphericOverlay extends StatelessWidget {
  const AtmosphericOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: AtmosphericPainter(),
      ),
    );
  }
}

class AtmosphericPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x55F7F0E4), Color(0x00F7F0E4)],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.7, size.height * 0.2),
          radius: size.width * 0.8,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.2),
      size.width * 0.8,
      glowPaint,
    );

    final shadePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Color(0xCC05070A)],
        stops: [0.35, 1.0],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, shadePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black38,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class FeedNavigation extends StatelessWidget {
  const FeedNavigation({
    super.key,
    required this.activeIndex,
    required this.savedCount,
  });

  final int activeIndex;
  final int savedCount;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      backgroundColor: const Color(0xFF0A111B),
      indicatorColor: const Color(0x33C7A45D),
      selectedIndex: 0,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: savedCount > 0,
            label: Text('$savedCount'),
            child: const Icon(Icons.bookmark_border_rounded),
          ),
          selectedIcon: const Icon(Icons.bookmark_rounded),
          label: 'Saved',
        ),
        const NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore_rounded),
          label: 'Explore',
        ),
      ],
    );
  }
}
