import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'main.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /// Background
          CustomPaint(
            size: Size(screenWidth, screenHeight),
            painter: _SplitPainterLanding(),
          ),

          /// Floating dots
          const Positioned.fill(child: _LandingParticles()),

          /// Header logo
          Positioned(
            top: 28,
            left: 45,
            child: Text(
              "🧬 NeuroAI Detect",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C6DD0),
                letterSpacing: 0.8,
              ),
            ),
          ),

          /// MAIN CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT — Image collage
                  SizedBox(
                    width: screenWidth * 0.45,
                    child: Column(
                      children: [
                        const SizedBox(height: 120),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: StaticImage(
                            path: "assets/images/stethoscope.webp",
                            width: 330,
                            height: 180,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: StaticImage(
                            path: "assets/images/mri doctor.webp",
                            width: 330,
                            height: 180,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: StaticImage(
                            path: "assets/images/aunty.jpg",
                            width: 330,
                            height: 180,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 60),

                  /// RIGHT PANEL — Info Card
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 40),
                      padding: const EdgeInsets.fromLTRB(36, 40, 36, 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: const Color(0xFFDEE3F2),
                          width: 1.1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 4,
                            width: 85,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7A5AF8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),

                          const SizedBox(height: 22),

                          const Text(
                            "AI-powered Brain\nDisorder Prediction",
                            style: TextStyle(
                              fontSize: 33,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Our AI-powered system analyzes brain MRI scans using advanced deep "
                            "learning models to detect disorders such as Brain Tumor, Alzheimer’s Disease, "
                            "Stroke, and Multiple Sclerosis (MS).",
                            style: TextStyle(fontSize: 16, height: 1.55),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "Users can upload MRI scans and receive predictions with confidence "
                            "scores and downloadable reports.",
                            style: TextStyle(fontSize: 16, height: 1.55),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "Includes a Generative-AI assistant offering educational, non-medical "
                            "guidance based on results.",
                            style: TextStyle(fontSize: 16, height: 1.55),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "All images are processed securely in real-time to ensure privacy, "
                            "accuracy, and reliability.",
                            style: TextStyle(fontSize: 16, height: 1.55),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "Built using Python (Flask) and Flutter for a smooth and professional "
                            "healthcare learning experience.",
                            style: TextStyle(fontSize: 16, height: 1.55),
                          ),

                          const SizedBox(height: 32),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 190,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoadingScreen(),
                                    ),
                                  );

                                  await Future.delayed(
                                    const Duration(seconds: 2),
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomePage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1C6DD0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Check Disorder",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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

/// STATIC Image Widget (no floating)
class StaticImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;

  const StaticImage({
    super.key,
    required this.path,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// Loading Screen
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _controller,
              child: Icon(
                Icons.blur_circular,
                size: 70,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              "Preparing AI Workspace...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Background paint
class _SplitPainterLanding extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintWhite = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintWhite);

    final gradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: const [
        Color.fromARGB(255, 15, 145, 150),
        Color.fromARGB(255, 16, 32, 126),
        Color.fromARGB(193, 90, 51, 196),
      ],
    );

    final paint = Paint()..shader = gradient.createShader(Offset.zero & size);

    final path = Path()
      ..moveTo(size.width * 0.38, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.62)
      ..lineTo(size.width * 0.60, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

/// Floating dots
class _LandingParticles extends StatelessWidget {
  const _LandingParticles({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ParticlesPainter());
  }
}

class _ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random();
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.13)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 25; i++) {
      canvas.drawCircle(
        Offset(
          rnd.nextDouble() * size.width,
          rnd.nextDouble() * size.height,
        ),
        2.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
