import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadButton extends StatefulWidget {
  final Future<void> Function(Uint8List) onUpload;

  const UploadButton({super.key, required this.onUpload});
  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  XFile? _uploadedImage;
  Future<void> _handleUpload(Uint8List bytes) async {
    widget.onUpload(bytes);
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        _uploadedImage = image;
      });

      await _handleUpload(bytes);
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary
          ),
        ),
        if (_uploadedImage != null)
          Text("File name: ${_uploadedImage!.name}"),
      ]
    );
  }
}