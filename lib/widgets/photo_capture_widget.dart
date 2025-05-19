import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoCaptureWidget extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  PhotoCaptureWidget({super.key});

  Future<void> _takePhoto(BuildContext context) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo taken: ${photo.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Platform.isAndroid || Platform.isIOS;
    if (!isMobile) {
      return const Text('Camera not supported on this platform.');
    }

    return ElevatedButton.icon(
      icon: const Icon(Icons.camera_alt),
      label: const Text('Take Photo'),
      onPressed: () => _takePhoto(context),
    );
  }
}
