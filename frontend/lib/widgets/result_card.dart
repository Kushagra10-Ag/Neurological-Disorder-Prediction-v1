import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String disease;
  final double confidence;
  final String explanation;
  final String pdfUrl; // <--- REQUIRED
  final bool isError;
  final VoidCallback onDownloadPDF;

  const ResultCard({
    super.key,
    required this.disease,
    required this.confidence,
    required this.explanation,
    required this.pdfUrl,        // <--- REQUIRED
    required this.onDownloadPDF,
    this.isError = false,
  });

  String _capitalize(String text) {
    if (text.isEmpty) return "Unknown";
    return text[0].toUpperCase() + text.substring(1);
  }

  String getSeverity(double confidence) {
    if (confidence < 40) return "Low";
    if (confidence < 70) return "Medium";
    return "High";
  }

  Color getSeverityColor(String level) {
    switch (level) {
      case "Low": return Colors.orange;
      case "Medium": return Colors.blueAccent;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color headerColor;
    IconData headerIcon;

    if (isError) {
      headerColor = Colors.redAccent;
      headerIcon = Icons.error_outline;
    } else if (confidence < 40) {
      headerColor = const Color(0xFF2ECC71);
      headerIcon = Icons.verified_outlined;
    } else {
      headerColor = const Color(0xFF7A5AF8);
      headerIcon = Icons.medical_services_outlined;
    }

    final severity = getSeverity(confidence);
    final severityColor = getSeverityColor(severity);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [headerColor, headerColor.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Icon(headerIcon, color: Colors.white, size: 34),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    isError ? "Analysis Failed" : _capitalize(disease),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (!isError) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Confidence: ${confidence.toStringAsFixed(2)}%",
                style: TextStyle(
                  color: headerColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: confidence / 100,
                  minHeight: 12,
                  backgroundColor: Colors.grey.shade300,
                  color: headerColor,
                ),
              ),
            ),

            const SizedBox(height: 16),


          ],

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              explanation,
              style: const TextStyle(fontSize: 15, height: 1.45),
            ),
          ),

          const SizedBox(height: 20),

          if (!isError)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: onDownloadPDF,
                style: ElevatedButton.styleFrom(
                  backgroundColor: headerColor,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text(
                  "Download PDF Report",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
