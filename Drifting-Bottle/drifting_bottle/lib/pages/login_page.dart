import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─── Global constant ───────────────────────────────────────────────────────────
const String kBaseUrl = 'http://10.0.2.2:8080'; // Android emulator
// const String kBaseUrl = 'http://localhost:8080';   // iOS simulator
// const String kBaseUrl = 'http://192.168.x.x:8080'; // Physical device (use your machine's local IP)

// ─── Convert StatelessWidget → StatefulWidget ──────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Login API call ────────────────────────────────────────────────────────
  Future<void> _login() async {
    setState(() { _isLoading = true; _errorMessage = null; });

    final url = Uri.parse('$kBaseUrl/api/login/authenticate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _usernameController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the returned user JSON
        final Map<String, dynamic> userData = jsonDecode(response.body);

        // ─── Save to SharedPreferences (like localStorage) ───
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', userData['username'] ?? '');
        await prefs.setString('email', userData['email'] ?? '');  // add fields your User has
        await prefs.setInt('userId', userData['id'] ?? 0);
        await prefs.setBool('isLoggedIn', true);

        if (mounted) Navigator.of(context).pushNamed('/Capture');

      } else {
        setState(() { _errorMessage = 'Invalid credentials. Please try again.'; });
      }
    } catch (e) {
      print('ERROR: $e');  // ← add this
      setState(() { _errorMessage = 'Network error: $e'; }); // show full error on screen
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
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

          // Moon (top-right corner)
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFFF5E6A3),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Moon crater 1
          Positioned(
            top: 30,
            right: 80,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFE8C84A),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Moon crater 2
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFE8C84A),
                shape: BoxShape.circle,
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

          // Bottle icon
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 200),

                  // UserName label
                  const Text(
                    'UserName',
                    style: TextStyle(
                      color: Color(0xFFCCDDE8),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // UserName field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECF0F1),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: TextField(
                      controller: _usernameController, // ← wired
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Password label
                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Color(0xFFCCDDE8),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Password field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECF0F1),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: TextField(
                      controller: _passwordController, // ← wired
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Error message
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 13,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Login button
                  SizedBox(
                    width: 130,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login, // ← calls _login
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
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
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

    final cp1x = size.width * (0.25 + waveOffset * 0.1);
    final cp1y = waveHeight - 40;
    final cp2x = size.width * (0.55 + waveOffset * 0.05);
    final cp2y = waveHeight + 30;

    path.cubicTo(
      cp1x, cp1y,
      cp2x, cp2y,
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