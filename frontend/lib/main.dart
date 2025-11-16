import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets/custom_button.dart';
import 'widgets/disorder_dropdown.dart';
import 'widgets/upload_widget.dart';
import 'widgets/result_card.dart';
import 'services/api_service.dart';
import 'util/constant.dart';
import 'landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String selectedDisorder = "";
  XFile? image;

  bool loading = false;

  final picker = ImagePicker();
  final apiService = ApiService();

  // result from backend
  Map<String, dynamic>? resultData;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // ================= PICK IMAGE =================
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => image = pickedFile);
    }
  }

  // ================= CHECK DISORDER =================
  Future<void> checkDisorder() async {
    if (selectedDisorder.isEmpty || image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select disorder and upload MRI")),
      );
      return;
    }

    if (nameController.text.isEmpty || ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter name and age")),
      );
      return;
    }

    setState(() {
      loading = true;
      resultData = null;
    });

    final res = await apiService.uploadMRI(
      disease: selectedDisorder,
      image: image!,
      name: nameController.text,
      age: ageController.text,
    );

    setState(() {
      loading = false;
      resultData = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background painter
          CustomPaint(size: MediaQuery.of(context).size, painter: SplitPainterFixed()),

          // Floating particles
          const Positioned.fill(child: AnimatedParticles()),

          // Main Form
          Center(
            child: Container(
              width: 540,
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDEE3F2), width: 1.1),
                boxShadow: [
                  BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.05), offset: const Offset(0, 10)),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text("Patient Information",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 24),

                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Patient Name",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: ageController,
                      decoration: InputDecoration(
                        labelText: "Age",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 22),

                    DisorderDropdown(
                      selectedDisorder: selectedDisorder,
                      onChanged: (value) => setState(() => selectedDisorder = value ?? ""),
                    ),

                    const SizedBox(height: 18),

                    UploadWidget(image: image, onUploadPressed: pickImage),

                    const SizedBox(height: 22),

                    loading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: "Check Disorder",
                            onPressed: checkDisorder,
                            width: double.infinity,
                          ),

                    const SizedBox(height: 22),

                    // Final — show result
                    if (resultData != null) buildResultCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// ========== BUILD RESULT CARD ==========
Widget buildResultCard() {
  if (resultData!["success"] == false) {
    return ResultCard(
      disease: "Error",
      confidence: 0,
      explanation: resultData!["message"],
      pdfUrl: "",
      onDownloadPDF: () {},
      isError: true,
    );
  }

  return ResultCard(
    disease: resultData!["disease"],
    confidence: resultData!["confidence"].toDouble(),
    explanation: resultData!["explanation"],
    pdfUrl: resultData!["pdf_url"],

    onDownloadPDF: () async {
      bool ok = await apiService.downloadPDF(resultData!["pdf_url"]);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to download PDF")),
        );
      }
    },
  );
}

}

// Background painter
class SplitPainterFixed extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF0F9196),
          Color(0xFF10207E),
          Color(0xFF5A33C4),
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Floating particle background
class AnimatedParticles extends StatefulWidget {
  const AnimatedParticles({super.key});

  @override
  State<AnimatedParticles> createState() => _AnimatedParticlesState();
}

class _AnimatedParticlesState extends State<AnimatedParticles> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final particles = List.generate(
    20,
    (i) => Offset(math.Random().nextDouble(), math.Random().nextDouble()),
  );

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => CustomPaint(
        painter: ParticlePainter(particles: particles, time: controller.value),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Offset> particles;
  final double time;

  ParticlePainter({required this.particles, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);
    for (final p in particles) {
      final dx = p.dx * size.width + math.sin(time * 6) * 10;
      final dy = p.dy * size.height + math.cos(time * 6) * 10;
      canvas.drawCircle(Offset(dx, dy), 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
