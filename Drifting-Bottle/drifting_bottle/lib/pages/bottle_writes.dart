import 'package:flutter/material.dart';

class ThrowScreen extends StatelessWidget {
  const ThrowScreen({super.key});

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

          // Bottom wave layer 1 (back)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.38, waveOffset: 0.0),
              child: Container(
                height: 260,
                color: const Color(0xFF1A5C4E),
              ),
            ),
          ),

          // Bottom wave layer 2 (middle)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.30, waveOffset: 0.3),
              child: Container(
                height: 220,
                color: const Color(0xFF155244),
              ),
            ),
          ),

          // Bottom wave layer 3 (front)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.22, waveOffset: 0.6),
              child: Container(
                height: 180,
                color: const Color(0xFF0E3D32),
              ),
            ),
          ),

          // Bottle icon floating on waves
          Positioned(
            bottom: 70,
            left: 0,
            right: 60,
            child: Center(
              child: Transform.rotate(
                angle: -0.3,
                child: const Icon(
                  Icons.wine_bar,
                  color: Color(0xFF7DC9D8),
                  size: 52,
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back arrow
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),

                const SizedBox(height: 30),

                // Message TextField (parchment card)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Container(
                    height: 320,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EDD6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const TextField(
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText:
                        'Write your message here...',
                        hintStyle: TextStyle(
                          color: Color(0xFFAA9D7E),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                      style: TextStyle(
                        color: Color(0xFF2C2C2C),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      cursorColor: Color(0xFF5E8A82),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Throw button
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E8A82),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Throw',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
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

/// Custom wave clipper for the bottom ocean layers
class _WaveClipper extends CustomClipper<Path> {
  final double heightFactor;
  final double waveOffset;

  const _WaveClipper({
    required this.heightFactor,
    required this.waveOffset,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveHeight = size.height * heightFactor;

    path.moveTo(0, waveHeight);

    path.cubicTo(
      size.width * (0.25 + waveOffset * 0.1),
      waveHeight - 40,
      size.width * (0.55 + waveOffset * 0.05),
      waveHeight + 30,
      size.width,
      waveHeight - 10,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) =>
      oldClipper.heightFactor != heightFactor ||
          oldClipper.waveOffset != waveOffset;
}

// Entry point for testing
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ThrowScreen(),
    ),
  );
}