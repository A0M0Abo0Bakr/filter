import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:ui' show Image;
import 'dart:io';

void main() {
  // Replace 'path/to/your/image.jpg' with the actual path to your image file
  String imagePath = 'path/to/your/image.jpg';

  // Load the image
  ui.Image image = decodeImage(imagePath);

  // Apply blur filter
  ui.Image blurredImage = applyBlur(image, 5.0); // You can adjust the blur radius

  // Save or display the blurred image as needed
  saveImage(blurredImage, 'path/to/save/blurred_image.jpg');
}

ui.Image decodeImage(String path) {
  ByteData data = ByteData.sublistView(new File(path).readAsBytesSync());

  return ui.decodeImageFromList(Uint8List.view(data.buffer));
}

ui.Image applyBlur(ui.Image image, double sigma) {
  final ui.Recorder recorder = ui.Recorder();
  final ui.Paint paint = ui.Paint()
    ..colorFilter = ui.ColorFilter.mode(
      const ui.Color(0xFFFFFFFF),
      ui.TransferMode.clear,
    )
    ..imageFilter = ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);

  final ui.Rect rect = ui.Rect.fromPoints(
    ui.Offset(0.0, 0.0),
    ui.Offset(image.width.toDouble(), image.height.toDouble()),
  );
  recorder
    ..clipRect(rect)
    ..drawImage(image, ui.Offset.zero, paint);

  final ui.Picture picture = recorder.endRecording();
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(pictureRecorder);
  canvas.drawImage(picture, ui.Offset.zero, paint);

  return pictureRecorder.endRecording().toImage(image.width, image.height);
}

void saveImage(ui.Image image, String path) {
  final ByteData data =
      ByteData.sublistView(Uint8List(image.width * image.height * 4));
  final buffer = data.buffer.asUint8List();
  final cullRect = ui.Rect.fromPoints(
    const ui.Offset(0.0, 0.0),
    ui.Offset(image.width.toDouble(), image.height.toDouble()),
  );
  final paint = ui.Paint();
  final recorder = ui.Recorder();
  recorder
    ..clipRect(cullRect)
    ..drawImage(image, ui.Offset.zero, paint);

  final ui.Picture picture = recorder.endRecording();
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(pictureRecorder);
  canvas.drawImage(picture, ui.Offset.zero, paint);

  final ui.Image img = pictureRecorder.endRecording().toImage(image.width, image.height);
  img.toByteData(format: ui.ImageByteFormat.png).then((ByteData byteData) {
    buffer.setAll(0, byteData.buffer.asUint8List());
    File(path).writeAsBytesSync(Uint8List.sublistView(buffer));
  });
}
