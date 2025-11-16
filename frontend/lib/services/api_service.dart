import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class ApiService {
  final String baseUrl = "http://10.12.75.155:5000";

  // =========================================================
  // UPLOAD MRI
  // =========================================================
  Future<Map<String, dynamic>> uploadMRI({
    required String disease,
    required XFile image,
    required String name,
    required String age,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/predict");
      final request = http.MultipartRequest("POST", uri);

      request.fields['disease'] = disease;
      request.fields['name'] = name;
      request.fields['age'] = age;

      // ⬆ IMAGE UPLOAD HANDLING
      if (kIsWeb) {
        Uint8List bytes = await image.readAsBytes();
        final mime = lookupMimeType(image.name)?.split('/') ?? ['image', 'jpeg'];
        request.files.add(http.MultipartFile.fromBytes(
          'mri_image',
          bytes,
          filename: image.name,
          contentType: MediaType(mime[0], mime[1]),
        ));
      } else {
        final mime = lookupMimeType(image.path)?.split('/') ?? ['image', 'jpeg'];
        request.files.add(await http.MultipartFile.fromPath(
          'mri_image',
          image.path,
          contentType: MediaType(mime[0], mime[1]),
        ));
      }

      // SEND REQUEST
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      print("Backend raw response → $respStr");

      if (response.statusCode == 200) {
        final data = jsonDecode(respStr);

        return {
          "success": true,
          "disease": data["disease"],
          "confidence": data["confidence"],
          "explanation": data["ai_explanation"],
          "pdf_url": data["pdf_url"], // used in downloadPDF
        };
      }

      return {"success": false, "message": respStr};

    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  // =========================================================
  // DOWNLOAD PDF (FINAL FIXED VERSION)
  // =========================================================

Future<bool> downloadPDF(String pdfUrl) async {
  try {
    final fullUrl = Uri.parse(baseUrl).resolve(pdfUrl).toString();
    print("Downloading from → $fullUrl");

    final response = await http.get(Uri.parse(fullUrl));
    if (response.statusCode != 200) {
      print("PDF download failed → ${response.statusCode}");
      return false;
    }

    // -------------------------------
    // 🌐 WEB FIX → Download using browser API
    // -------------------------------
    if (kIsWeb) {
      final bytes = response.bodyBytes;
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..download = "NeuroAI_Report.pdf"
        ..click();

      html.Url.revokeObjectUrl(url);
      print("PDF downloaded in browser");
      return true;
    }

    // -------------------------------
    // 📱 ANDROID / iOS
    // -------------------------------
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/NeuroAI_Report.pdf";
    final file = io.File(filePath);

    await file.writeAsBytes(response.bodyBytes);
    print("Saved PDF at: $filePath");

    OpenFilex.open(filePath);

    return true;

  } catch (e) {
    print("DownloadPDF ERROR → $e");
    return false;
  }
}
}