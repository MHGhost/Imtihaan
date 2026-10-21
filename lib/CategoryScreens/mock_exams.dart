import 'dart:convert';
import 'dart:io';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../Services/ai_helper.dart';
import 'mcq_screen.dart';

class MockExamSimulatorScreen extends StatefulWidget {
  const MockExamSimulatorScreen({super.key});

  @override
  State<MockExamSimulatorScreen> createState() =>
      _MockExamSimulatorScreenState();
}

class _MockExamSimulatorScreenState extends State<MockExamSimulatorScreen> {

  String? uploadedFileText;
  String? fileName;
  bool isLoading = false;

  // Function to pick a file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    if(result != null) {
      String? filePath = result.files.single.path;
      String? selectedFileName = result.files.single.name;

      if(filePath != null) {
        setState(() {
          isLoading = true;
        });
        try {
          String text;
          if (selectedFileName.endsWith('.docx')) {

            final file = File(filePath);
            final bytes = await file.readAsBytes();
            text = docxToText(bytes);

          } else if (selectedFileName.endsWith('.pdf')) {

            final file = File(filePath);
            final bytes = await file.readAsBytes();
            final document = PdfDocument(inputBytes: bytes);
            text = PdfTextExtractor(document).extractText();
            document.dispose();

          } else {
            throw Exception('Unsupported file type');
          }

          setState(() {
            fileName = selectedFileName;
            uploadedFileText = text;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error reading file: $e')),
          );
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Future<void> generateMCQs() async {
    if (uploadedFileText != null) {
      setState(() {
        isLoading = true;
      });

      try {
        final mcqs = await OpenAIHelper.generateMCQs(uploadedFileText!);

        final parsedMCQs = OpenAIHelper.parseMCQsFromAIOutput(jsonEncode(mcqs));

        // Navigate to MCQ quiz screen with generated MCQs
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MCQQuizScreen(
              fileName: fileName ?? "Uploaded Document",
              mcqs: parsedMCQs,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating MCQs: $e')),
        );
        print("Error: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Mock Exam",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title and Subtitle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.insert_drive_file_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Mock-Exam Simulator",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            // Upload Label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.linked_camera_outlined,
                    size: 30, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  "Upload document",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            // Dotted Border for Upload
            GestureDetector(
              onTap: pickFile,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                dashPattern: [6, 3],
                color: Colors.grey,
                strokeWidth: 2,
                child: Container(
                  width: 200,
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue[50],
                  ),
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Show file name if uploaded
            if (fileName != null)
              Text(
                "Selected File: $fileName",
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            const SizedBox(height: 20),
            // Generate Summary Button
            ElevatedButton(
                onPressed: uploadedFileText == null || isLoading
                    ? null
                    : generateMCQs,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.blue, // Set button color to blue
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Generate MCQs"))
          ],
        ),
      ),
    );
  }
}
