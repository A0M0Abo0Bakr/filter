import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/sample.jpg');
    final List<int> bytes = data.buffer.asUint8List();
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    final img.Image smoothedImage = img.gaussianBlur(image, 10); // تطبيق smoothing filter

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromPixels(
      smoothedImage.getBytes(),
      smoothedImage.width,
      smoothedImage.height,
      ui.PixelFormat.rgba8888,
      (ui.Image img) {
        setState(() {
          _image = img;
        });
        completer.complete(img);
      },
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smoothing Filter Example'),
      ),
      body: Center(
        child: _image == null
            ? CircularProgressIndicator()
            : Image(image: ImageInfo(image: _image!, scale: 1.0)),
      ),
    );
  }
}
