import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mushroom_classifier_ui/widgets/photo_capture_widget.dart';
import 'package:mushroom_classifier_ui/widgets/upload_button.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _shroomBotPath = 'assets/images/shroom_bot.webp';
  String? _displayMessage;

  Future<void> _uploadImageToApi(Uint8List imageBytes) async {
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
    var body = jsonDecode(await res.stream.bytesToString());

    if (res.statusCode == 200) {
      double confidence = body['confidence'] * 100;
      String classification = body['prediction'].toString().contains('edible')
        ? 'edible'
        : 'poisonous';

      setState(() {
        _displayMessage = 
          "I am ${confidence.toStringAsFixed(2)}% sure this is a $classification fungus${classification == 'edible' ? '!' : '.'}";
        if (confidence > 75) {
          _shroomBotPath = classification.contains('edible')
            ? 'assets/images/shroom_bot_hungry.webp'
            : 'assets/images/shroom_bot_ill.webp';
        } else {
          _shroomBotPath = 'assets/images/shroom_bot_shrug.webp';
        }
      });
    } else {
      setState(() {
        _displayMessage = 'Oh no! Something went wrong! ${res.statusCode}';
        _shroomBotPath = 'assets/images/shroom_bot_error.webp';
      });
    }
  }

  void _reset() {
    setState(() {
      _displayMessage = null;
      _shroomBotPath = 'assets/images/shroom_bot.webp';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = !kIsWeb;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _shroomBotPath,
              width: 150
            ),

            if (_displayMessage == null)
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text("Hello there!"),
                  ),
                  Text("Upload a file or take a picture (still in development) of a fungus and I will try to predict whether it is poisonous or edible!"),
                ],
              ),

            Text(
              "Please verify for yourself whether the fungus is poisonous or not.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("This app is experimental and likely innacurate."),
          
            if (isMobile)
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: PhotoCaptureWidget(),
              ),

            if (!isMobile && _displayMessage == null) 
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: 
                  UploadButton(onUpload: _uploadImageToApi)
              ),

            if (_displayMessage != null)
              Column(children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('$_displayMessage')
                ),
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary
                  ),
                  child: Text(
                    'Try again?',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
