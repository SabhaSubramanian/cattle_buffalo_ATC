import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  ResultScreen({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Result")),
      body: Column(
        children: [
          Text("Breed: ${result['breed']}"),
          Image.network(result['segmentation']),
          Image.network(result['keypoints']),
        ],
      ),
    );
  }
}
