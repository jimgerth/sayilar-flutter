import 'package:flutter/material.dart';

import 'package:sayilar/extensions/written_out.dart';

void main() {
  runApp(const Sayilar());
}

/// The root widget for the Sayılar app.
class Sayilar extends StatefulWidget {
  /// Create a new [Sayilar] widget.
  const Sayilar({super.key});

  @override
  State<Sayilar> createState() => SayilarState();
}

/// The [State] of a [Sayilar] widget.
class SayilarState extends State<Sayilar> {
  /// A text to be shown to the user.
  String output = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sayılar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sayılar'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(output),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (input) => setState(
                    // When the user types in a valid number, show the written
                    // out name for that number in turkish to the user.
                    () => output = int.tryParse(input)?.writtenOut ?? '',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
