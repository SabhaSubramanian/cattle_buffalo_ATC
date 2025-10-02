import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const baseUrl = "http://10.0.2.2:8000"; // use localhost for Android emulator

  static Future<Map<String, dynamic>> processCattle(File image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/classify'));
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    var res = await request.send();
    var resBody = await http.Response.fromStream(res);
    final breed = json.decode(resBody.body)['breed'];

    var segRequest = http.MultipartRequest('POST', Uri.parse('$baseUrl/segment'));
    segRequest.files.add(await http.MultipartFile.fromPath('file', image.path));
    var segRes = await segRequest.send();
    final segmentationUrl = "$baseUrl/segment"; // simplify for now

    final keypointUrl = "$baseUrl/keypoints";

    return {
      "breed": breed,
      "segmentation": segmentationUrl,
      "keypoints": keypointUrl
    };
  }
}
