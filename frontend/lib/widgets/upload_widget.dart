import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadWidget extends StatelessWidget {
  final XFile? image;
  final VoidCallback onUploadPressed;

  const UploadWidget({
    super.key,
    required this.image,
    required this.onUploadPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget displayImage() {
      if (image == null) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF3F4F6),
            border: Border.all(
              color: const Color(0xFFD0D5DD),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.image_outlined,
            size: 48,
            color: Color(0xFF6B7280),
          ),
        );
      }

      if (kIsWeb) {
        return FutureBuilder<Uint8List>(
          future: image!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  snapshot.data!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(image!.path),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return Column(
      children: [
        displayImage(),
        const SizedBox(height: 12),

        // 🔵 CLEAN OUTLINED UPLOAD BUTTON
        // PURPLE OUTLINE UPLOAD BUTTON (centered)
Center(
child :SizedBox(
  height: 46,
  child: OutlinedButton(
    onPressed: onUploadPressed,
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: Color(0xFF595667), // SAME PURPLE AS SELECT DISORDER
        width: 1.4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // SAME RADIUS
      ),
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF595667),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.upload_file, size: 20, color: Color(0xFF595667)),
        SizedBox(width: 8),
        Text(
          "Upload MRI Image",
          style: TextStyle(
            fontFamily: "Roboto",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
            color: Color(0xFF595667),
          ),
        ),
      ],
    ),
  ),
),
),
      ],
    );
  }
}
