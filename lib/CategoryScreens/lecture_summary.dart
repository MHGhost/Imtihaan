import 'dart:io';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:imtihaan/Services/ai_helper.dart';
import 'package:imtihaan/Services/preferences_helper.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'document_summary.dart';

class LectureSummaryUploadScreen extends StatefulWidget {
  const LectureSummaryUploadScreen({super.key});

  @override
  State<LectureSummaryUploadScreen> createState() =>
      _LectureSummaryUploadScreenState();
}

class _LectureSummaryUploadScreenState
    extends State<LectureSummaryUploadScreen> {
  String? uploadedFileText; // Simulate file content
  String? fileName;
  bool isLoading = false;

  // Function to pick a file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // Allow PDF and DOCX
    );

    if (result != null) {
      String? filePath =
          result.files.single.path; // File path of the selected file
      fileName = result.files.single.name;

      if (filePath != null) {
        if (fileName!.endsWith('.docx')) {
          try {
            // Extract text using docx_to_text
            final file = File(filePath);
            final bytes = await file.readAsBytes();
            final text = docxToText(bytes);

            setState(() {
              fileName = result.files.single.name;
              uploadedFileText = text;
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error reading DOCX file: $e')),
            );
          }
        } else if (fileName!.endsWith('.pdf')) {
          try {
            // Extract text using Syncfusion PDF
            final file = File(filePath);
            final bytes = await file.readAsBytes();
            final document = PdfDocument(inputBytes: bytes);
            final text = PdfTextExtractor(document).extractText();

            setState(() {
              fileName = result.files.single.name;
              uploadedFileText = text;
            });

            document.dispose();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error reading PDF file: $e')),
            );
          }
        } else {
          // Handle other file types like PDF
          try {
            uploadedFileText = await File(filePath).readAsString();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error reading file: $e')),
            );
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  // Function to generate summary
  Future<void> generateSummary() async {
    if (uploadedFileText != null) {
      setState(() {
        isLoading = true;
      });

      try {
        final result = await OpenAIHelper.generateSummary(uploadedFileText!);
        // Save the generated summary and timestamp in SharedPreferences
        await PreferencesHelper.saveToHistory(result, "Summary");

        // Navigate to DocumentSummaryResultScreen to display the summary
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentSummaryResultScreen(
                fileName: fileName ?? "Uploaded Document",
                summary: result,
              ),
            ),
          );
        }
      } catch (e) {
        // Handle any errors (e.g., show a Snackbar)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating summary: $e')),
        );
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
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
          "Lecture Summary",
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
              children: [
                Card(
                  color: Colors.amberAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.videocam_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Lecture Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Upload Label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.linked_camera_outlined,
                    size: 30, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  "Upload Document",
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
                    : generateSummary,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.blue, // Set button color to blue
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Generate Summary"))
          ],
        ),
      ),
    );
  }
}
