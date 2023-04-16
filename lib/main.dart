import 'package:flutter/material.dart';

void main() {
  runApp(const Sayilar());
}

/// The root widget for the Sayılar app.
class Sayilar extends StatelessWidget {
  /// Create a new [Sayilar] widget.
  const Sayilar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sayılar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sayılar'),
        ),
        body: Container(),
      ),
    );
  }
}
