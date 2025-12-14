import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class LandmarkScreen extends StatefulWidget {
  const LandmarkScreen({super.key});

  @override
  State<LandmarkScreen> createState() => _LandmarkScreenState();
}

class _LandmarkScreenState extends State<LandmarkScreen> {
  // ---------------------------------------------------------
  // ⚠️ TODO: REPLACE WITH YOUR GOOGLE CLOUD API KEY
  // ---------------------------------------------------------
  // Ensure this key has both "Cloud Vision API" and "Generative Language API" (Gemini) enabled.
  final String apiKey = "AIzaSyBucnqslO6xDrO12lywdbZ2sfkNdCi8qns";

  File? _image;
  String _title = "It looks like:";
  String _landmarkName = "Nothing scanned yet";
  String _landmarkDetail = ""; // New variable for the description
  String _confidence = "";
  bool _loading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _loading = true;
        _landmarkName = "Analyzing...";
        _landmarkDetail = ""; // Reset details
        _confidence = "";
      });
      _identifyLandmark(pickedFile.path);
    }
  }

  Future<void> _identifyLandmark(String imagePath) async {
    try {
      // 1. VISION API: Identify the image
      final bytes = await File(imagePath).readAsBytes();
      String base64Image = base64Encode(bytes);

      final url = Uri.parse(
        'https://vision.googleapis.com/v1/images:annotate?key=$apiKey',
      );
      final requestBody = jsonEncode({
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [
              {"type": "LANDMARK_DETECTION", "maxResults": 1},
            ],
          },
        ],
      });

      final response = await http.post(url, body: requestBody);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['responses'][0].containsKey('landmarkAnnotations')) {
          final annotation = data['responses'][0]['landmarkAnnotations'][0];
          String detectedName = annotation['description'];
          double score = annotation['score'];

          setState(() {
            _landmarkName = detectedName;
            _confidence = "(Confidence: ${(score * 100).toStringAsFixed(1)}%)";
            _landmarkDetail = "Fetching details from Gemini...";
          });

          // 2. GEMINI API: Get details about the landmark
          await _fetchLandmarkDetails(detectedName);

        } else {
          setState(() {
            _landmarkName = "No landmark detected";
            _confidence = "Try getting closer or checking lighting.";
            _loading = false;
          });
        }
      } else {
        setState(() {
          _landmarkName = "Vision API Error: ${response.statusCode}";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _landmarkName = "Connection Failed";
        _confidence = "Please check your internet.";
        _loading = false;
      });
    }
  }

  // New function to call Gemini
  Future<void> _fetchLandmarkDetails(String landmark) async {
    try {
      // Using Gemini 1.5 Flash for speed
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

      final requestBody = jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                "Write a short, fun, 2-sentence fact about the landmark '$landmark'. Keep it under 40 words."
              }
            ]
          }
        ]
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extracting text from Gemini response structure
        String text =
            data['candidates'][0]['content']['parts'][0]['text'] ?? "No details found.";

        setState(() {
          _landmarkDetail = text;
        });
      } else {
        setState(() {
          _landmarkDetail = "Gemini Error: ${response.body}";
        });
        debugPrint("Gemini Error: ${response.body}");
      }
    } catch (e) {
      setState(() {
        _landmarkDetail = "Error connecting to AI.";
      });
    } finally {
      setState(() {
        _loading = false; // Stop loading only after both APIs are done
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Travel Buddy Vision",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Camera Preview Area
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "No photo taken",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Result Sheet
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_loading)
                  const LinearProgressIndicator(color: Colors.blueAccent)
                else
                  Column(
                    children: [
                      Text(
                        "📍 $_title",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _landmarkName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (_confidence.isNotEmpty)
                        Text(
                          _confidence,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 15),
                      // Display Gemini Details here
                      if (_landmarkDetail.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _landmarkDetail,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[900],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),

                const SizedBox(height: 25),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_enhance, color: Colors.white),
                    label: const Text(
                      "Scan Landmark",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
