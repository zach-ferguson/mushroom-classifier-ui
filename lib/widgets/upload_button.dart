import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class UploadButton extends StatefulWidget {
  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  XFile? _uploadedImage;
  String? apiResponse;
  

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        _uploadedImage = image;
      });
      await uploadImageToApi(bytes);
    }
  }

  Future<void> uploadImageToApi(Uint8List imageBytes) async {
    var uri = Uri.parse('https://zferg1-mushroom-classifier-api.hf.space/predict/');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'image.png',
        contentType: MediaType('image', 'png')
      ),
    );

    var res = await request.send();
    var body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      setState(() {
        apiResponse = body;
      });
    } else {
      setState(() {
        apiResponse = 'Error: ${res.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.upload_file),
          label: const Text('Upload Image File'),
          onPressed: pickAndUploadImage,
        ),
        if (_uploadedImage != null) Text("File name: ${_uploadedImage!.name}"),
        if (apiResponse != null)
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.grey[200],
          child: Text('$apiResponse')
        )
      ]
    );
  }
}