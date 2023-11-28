import 'dart:io';
import 'package:flutter/material.dart';

class DisplayImageWidget extends StatelessWidget {
  final File imageFile;

  const DisplayImageWidget({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected image '),
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
