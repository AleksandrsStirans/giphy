import 'package:flutter/material.dart';

class GifDetailScreen extends StatelessWidget {
  final String gifUrl;

  GifDetailScreen({Key? key, required this.gifUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gif Detail'),
      ),
      body: Center(
        child: Image.network(gifUrl),
      ),
    );
  }
}
