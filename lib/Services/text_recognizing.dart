
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:imtihaan/Services/preferences_helper.dart';

class ImageTextRecognition {
  static Future<void> processImageForText(File image, Function(String) onTextExtracted) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      // Extract text block by block (better accuracy)
      String extractedText = "";
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          extractedText += "${line.text}\n";
        }
      }

      // Update state in UI
      onTextExtracted(extractedText);

      // Save to history if not empty
      if (extractedText.trim().isNotEmpty) {
        await PreferencesHelper.saveToHistory(extractedText.trim(), "Notes");
      }
    } catch (e) {
      debugPrint("Error recognizing text: $e");
    } finally {
      textRecognizer.close(); // Always release resources
    }
  }
}
