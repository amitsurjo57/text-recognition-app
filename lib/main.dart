import 'dart:io';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TextRecognitionScreen(),
    );
  }
}

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({super.key});

  @override
  State<TextRecognitionScreen> createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  File? imageFile;

  String text = "";

  Future<void> _onClickButton({required ImageSource imageSource}) async {
    XFile? image = await _imagePicker.pickImage(source: imageSource);

    if (image == null) return;

    Logger logger = Logger();

    imageFile = File(image.path);

    final InputImage inputImage = InputImage.fromFile(imageFile!);

    final TextRecognizer textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    text = recognizedText.text;
    logger.d("First Text: $text");

    setState(() {});

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Text Recognition App"),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _buttonSegment(),
              _image(),
              _myText(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Text _myText() => Text(text, style: TextStyle(fontSize: 20));

  Widget _buttonSegment() {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          _myButton(
            onTap: () => _onClickButton(imageSource: ImageSource.gallery),
            text: "Gallery",
          ),
          _myButton(
            onTap: () => _onClickButton(imageSource: ImageSource.camera),
            text: "Camera",
          ),
        ],
      ),
    );
  }

  Widget _myButton({required void Function() onTap, required String text}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        alignment: Alignment.center,
        elevation: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Pick image from\n$text",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _image() {
    return imageFile != null
        ? Image.file(imageFile!)
        : AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Colors.grey,
              alignment: Alignment.center,
              child: Text("No Image"),
            ),
          );
  }
}
