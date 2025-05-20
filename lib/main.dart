import 'package:flutter/material.dart';
import 'package:mushroom_classifier_ui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mushroom Classifier',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        )
          .copyWith(
            surface: Color.fromRGBO(247,209,151,1),
            primary: Color.fromRGBO(76, 46, 22, 1),
            secondary: Color.fromRGBO(189, 115, 80, 1),
          ),
      ),
      home: const MyHomePage(title: 'Mushroom Classifier'),
    );
  }
}
