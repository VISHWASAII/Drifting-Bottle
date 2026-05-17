import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


const String kBaseUrl = 'http://10.0.2.2:8080';

class DriftedMessageScreen extends StatefulWidget {
  const DriftedMessageScreen({super.key});

  @override
  State<DriftedMessageScreen> createState() => _DriftedMessageScreenState();
}

class _DriftedMessageScreenState extends State<DriftedMessageScreen> {
  String _message = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMessage();
  }

  // ─── Fetch message using stored userId ──────────────────────────────────────
  Future<void> _fetchMessage() async {
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      // 1. Read userId saved during login
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('userId');

      if (userId == null) {
        setState(() {
          _errorMessage = 'User not logged in.';
          _isLoading = false;
        });
        return;
      }

      // 2. Call the API with receiverId
      final url = Uri.parse('$kBaseUrl/api/bottle/receiver/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _message = response.body; // plain string returned by server
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No message found.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error. Check your connection.';
        _isLoading = false;
      });
    }
  }

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
            bottom: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.42, waveOffset: 0.0),
              child: CustomPaint(
                painter: _ContourWavePainter(
                  baseColor: const Color(0xFF1A5C4E),
                  lineColor: const Color(0xFF1E6B5A),
                ),
                child: const SizedBox(height: 280, width: double.infinity),
              ),
            ),
          ),

          // Bottom wave layer 2 — middle
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.30, waveOffset: 0.3),
              child: CustomPaint(
                painter: _ContourWavePainter(
                  baseColor: const Color(0xFF155244),
                  lineColor: const Color(0xFF196050),
                ),
                child: const SizedBox(height: 240, width: double.infinity),
              ),
            ),
          ),

          // Bottom wave layer 3 — front
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.20, waveOffset: 0.6),
              child: CustomPaint(
                painter: _ContourWavePainter(
                  baseColor: const Color(0xFF0E3D32),
                  lineColor: const Color(0xFF124A3D),
                ),
                child: const SizedBox(height: 200, width: double.infinity),
              ),
            ),
          ),

          // Bottle icon
          Positioned(
            bottom: 65, left: 0, right: 50,
            child: Center(
              child: Transform.rotate(
                angle: -0.25,
                child: const Icon(
                  Icons.wine_bar,
                  color: Color(0xFF7DC9D8),
                  size: 56,
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Top buttons
                  Row(
                    children: [
                      _TopButton(label: 'Write', onTap: () {
                        Navigator.of(context).pushNamed('/Throw');
                      }),
                      const SizedBox(width: 14),
                      _TopButton(label: 'Bottles', onTap: () {
                        Navigator.of(context).pushNamed('/History');
                      }),
                    ],
                  ),

                  const SizedBox(height: 60),

                  const Text(
                    'A message drifted to you !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ─── Message card ──────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EDD6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: _isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF5E8A82),
                      ),
                    )
                        : _errorMessage != null
                        ? Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    )
                        : Text(
                      _message, // ← dynamic message from API
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Like | Bottle count | Connect
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.white, size: 22),
                      const SizedBox(width: 6),
                      const Text('20',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      const SizedBox(width: 18),
                      const Icon(Icons.wine_bar,
                          color: Color(0xFFD4A96A), size: 22),
                      const SizedBox(width: 6),
                      const Text('15',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      const Spacer(),
                      SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFCC00),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: const Text(
                            'Connect',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Throw again — also re-fetches a new message
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _fetchMessage, // ← re-fetches on tap
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E8A82),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Throw again',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable top pill button ─────────────────────────────────────────────────

class _TopButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TopButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF5E8A82),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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

// ─── Contour wave painter ─────────────────────────────────────────────────────

class _ContourWavePainter extends CustomPainter {
  final Color baseColor;
  final Color lineColor;

  const _ContourWavePainter({required this.baseColor, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = baseColor,
    );

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 14; i++) {
      final baseY = size.height * 0.08 + i * 14.0;
      final path = Path();
      bool started = false;

      for (double x = 0; x <= size.width; x += 3) {
        final y = baseY +
            5 * math.sin((x / size.width) * 3 * math.pi + i * 0.6) +
            3 * math.sin((x / size.width) * 6 * math.pi + i * 1.2);
        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(_ContourWavePainter old) =>
      old.baseColor != baseColor || old.lineColor != lineColor;
}