import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


const String kBaseUrl = 'http://10.0.2.2:8080';

class ThrowScreen extends StatefulWidget {
  const ThrowScreen({super.key});

  @override
  State<ThrowScreen> createState() => _ThrowScreenState();
}

class _ThrowScreenState extends State<ThrowScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // ─── Send message API call ─────────────────────────────────────────────────
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();

    if (text.isEmpty) {
      setState(() { _errorMessage = 'Please write a message first.'; });
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      // 1. Read stored userId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final int? senderId = prefs.getInt('userId');

      if (senderId == null) {
        setState(() {
          _errorMessage = 'User not logged in.';
          _isLoading = false;
        });
        return;
      }

      // 2. Build URL with query parameters (matches Long senderId, String text)
      final url = Uri.parse('$kBaseUrl/api/throw/sendMessage').replace(
        queryParameters: {
          'senderId': senderId.toString(),
          'text': text,
        },
      );

      // 3. POST request
      final response = await http.post(url);

      if (response.statusCode == 202) {
        // Success — clear field and go back
        _messageController.clear();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Message thrown into the ocean! 🌊'),
              backgroundColor: Color(0xFF5E8A82),
            ),
          );
          Navigator.maybePop(context);
        }
      } else {
        setState(() { _errorMessage = 'Failed to send. Try again.'; });
      }
    } catch (e) {
      setState(() { _errorMessage = 'Network error. Check your connection.'; });
    } finally {
      setState(() { _isLoading = false; });
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

          // Bottom wave layer 1 (back)
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.38, waveOffset: 0.0),
              child: Container(height: 260, color: const Color(0xFF1A5C4E)),
            ),
          ),

          // Bottom wave layer 2 (middle)
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.30, waveOffset: 0.3),
              child: Container(height: 220, color: const Color(0xFF155244)),
            ),
          ),

          // Bottom wave layer 3 (front)
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: _WaveClipper(heightFactor: 0.22, waveOffset: 0.6),
              child: Container(height: 180, color: const Color(0xFF0E3D32)),
            ),
          ),

          // Bottle icon
          Positioned(
            bottom: 70, left: 0, right: 60,
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
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 26),
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
                    child: TextField(
                      controller: _messageController, // ← wired
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: 'Write your message here...',
                        hintStyle: TextStyle(
                          color: Color(0xFFAA9D7E),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF2C2C2C),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      cursorColor: const Color(0xFF5E8A82),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFFF6B6B),
                        fontSize: 13,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Throw button
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendMessage, // ← calls _sendMessage
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E8A82),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
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

/// Custom wave clipper
class _WaveClipper extends CustomClipper<Path> {
  final double heightFactor;
  final double waveOffset;

  const _WaveClipper({required this.heightFactor, required this.waveOffset});

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveHeight = size.height * heightFactor;
    path.moveTo(0, waveHeight);
    path.cubicTo(
      size.width * (0.25 + waveOffset * 0.1), waveHeight - 40,
      size.width * (0.55 + waveOffset * 0.05), waveHeight + 30,
      size.width, waveHeight - 10,
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