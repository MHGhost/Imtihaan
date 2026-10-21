
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Services/text_recognizing.dart';

class HandwritingToNotesScreen extends StatefulWidget {
  const HandwritingToNotesScreen({super.key});

  @override
  State<HandwritingToNotesScreen> createState() => _HandwritingToNotesScreenState();
}

class _HandwritingToNotesScreenState extends State<HandwritingToNotesScreen> {

  File? _image; // To hold the uploaded image
  String _extractedText = ""; // To hold the converted notes
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage() async {

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _processImageForText(File(pickedFile.path));
    }
  }

  // Function to process the image for text recognition
  Future<void> _processImageForText(File image) async {
    await ImageTextRecognition.processImageForText(image, (extractedText) {
      setState(() {
        _extractedText = "Recognized Text:\n\n$extractedText";
        print(extractedText);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Hand Writing to Notes",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Handwriting to Notes Title Card
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16,right: 16),
            child: Row(
              children: [
                Card(
                  color: Colors.amberAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.edit, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Hand Writing to Notes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Upload Images Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.camera_alt_outlined, size: 30, color: Colors.black),
              SizedBox(width: 8),
              Text(
                "Upload images",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),// Add some space
          const SizedBox(height: 20),
          // Dotted Border for Upload Images
          InkWell(
            onTap: _pickImage, // OnClick functionality
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              dashPattern: const [6, 3],
              color: Colors.grey,
              child: Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: _image == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, size: 50, color: Colors.black),
                  ],
                )
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Display Converted Text
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[100],
                child: Text(
                  _extractedText.isEmpty
                      ? "Converted text will appear here..."
                      : _extractedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
