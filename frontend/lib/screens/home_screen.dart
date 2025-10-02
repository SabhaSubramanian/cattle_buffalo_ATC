import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  final picker = ImagePicker();

  Future getImage(bool fromCamera) async {
    final pickedFile = await picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      if (pickedFile != null) _image = File(pickedFile.path);
    });
  }

  void processImage() async {
    if (_image == null) return;
    final result = await ApiService.processCattle(_image!);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smart ATC")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image == null ? Text("No Image Selected") : Image.file(_image!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () => getImage(true), child: Text("Camera")),
              ElevatedButton(onPressed: () => getImage(false), child: Text("Upload")),
            ],
          ),
          ElevatedButton(onPressed: processImage, child: Text("Process")),
        ],
      ),
    );
  }
}
