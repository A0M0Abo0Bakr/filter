import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Black and White Image Filter'),
        ),
        body: Center(
          child: ImageFilterWidget(),
        ),
      ),
    );
  }
}

class ImageFilterWidget extends StatefulWidget {
  @override
  _ImageFilterWidgetState createState() => _ImageFilterWidgetState();
}

class _ImageFilterWidgetState extends State<ImageFilterWidget> {
  img.Image? _filteredImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    // Replace 'assets/sample.jpg' with the path to your image
    ByteData data = await rootBundle.load('assets/sample.jpg');
    List<int> bytes = data.buffer.asUint8List();
    img.Image originalImage = img.decodeImage(Uint8List.fromList(bytes))!;

    // Apply black and white filter
    _filteredImage = img.grayscale(originalImage);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _filteredImage == null
        ? CircularProgressIndicator()
        : Image.memory(Uint8List.fromList(img.encodePng(_filteredImage!)));
  }
}
