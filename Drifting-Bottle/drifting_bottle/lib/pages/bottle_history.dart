import 'package:flutter/material.dart';

class YourBottlesScreen extends StatelessWidget {
  const YourBottlesScreen({super.key});

  // Sample bottle data
  static const List<Map<String, dynamic>> _bottles = [
    {
      'message': 'Cant wait to die',
      'likes': 20,
      'replies': 15,
      'date': 'Today',
    },
    {
      'message': 'Someone kill trump',
      'likes': 20,
      'replies': 15,
      'date': 'Yesterday',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D3B5E),
                  Color(0xFF0A3352),
                  Color(0xFF0C3B50),
                ],
              ),
            ),
          ),

          // Bottom wave layer 1 — back
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.40, waveOffset: 0.0),
              child: Container(
                height: 260,
                color: const Color(0xFF1A5C4E),
              ),
            ),
          ),

          // Bottom wave layer 2 — middle
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.28, waveOffset: 0.3),
              child: Container(
                height: 220,
                color: const Color(0xFF155244),
              ),
            ),
          ),

          // Bottom wave layer 3 — front
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.18, waveOffset: 0.6),
              child: Container(
                height: 180,
                color: const Color(0xFF0E3D32),
              ),
            ),
          ),

          // Bottle icon
          Positioned(
            bottom: 55,
            left: 0,
            right: 60,
            child: Center(
              child: Transform.rotate(
                angle: -0.25,
                child: const Icon(
                  Icons.wine_bar,
                  color: Color(0xFF7DC9D8),
                  size: 54,
                ),
              ),
            ),
          ),

          // Main scrollable content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 26),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),

                // "Your Bottles" title
                const Padding(
                  padding: EdgeInsets.only(left: 24.0, bottom: 16.0),
                  child: Text(
                    'Your Bottles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                // Bottle cards list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _bottles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final bottle = _bottles[index];
                      return _BottleCard(
                        message: bottle['message'] as String,
                        likes: bottle['likes'] as int,
                        replies: bottle['replies'] as int,
                        date: bottle['date'] as String,
                      );
                    },
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

// ─── Bottle card widget ───────────────────────────────────────────────────────

class _BottleCard extends StatelessWidget {
  final String message;
  final int likes;
  final int replies;
  final String date;

  const _BottleCard({
    required this.message,
    required this.likes,
    required this.replies,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parchment message card
        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EDD6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // Stats row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 20),
              const SizedBox(width: 5),
              Text(
                '$likes',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.wine_bar,
                  color: Color(0xFFD4A96A), size: 20),
              const SizedBox(width: 5),
              Text(
                '$replies',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),
      ],
    );
  }
}

// ─── Wave clipper ─────────────────────────────────────────────────────────────

class _WaveClipper extends CustomClipper<Path> {
  final double heightFactor;
  final double waveOffset;

  const _WaveClipper({required this.heightFactor, required this.waveOffset});

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveTop = size.height * heightFactor;

    path.moveTo(0, waveTop);
    path.cubicTo(
      size.width * (0.25 + waveOffset * 0.1), waveTop - 40,
      size.width * (0.55 + waveOffset * 0.05), waveTop + 30,
      size.width, waveTop - 10,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) =>
      old.heightFactor != heightFactor || old.waveOffset != waveOffset;
}