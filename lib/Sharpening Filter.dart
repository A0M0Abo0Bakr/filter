import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';

void main() {
  // تحديد مسار الصورة الداخلية والمحفوظة
  String inputImagePath = 'input_image.jpg';
  String outputImagePath = 'sharpened_output.jpg';

  // قراءة الصورة
  File inputFile = File(inputImagePath);
  List<int> imageBytes = inputFile.readAsBytesSync();
  Image image = decodeImage(Uint8List.fromList(imageBytes));

  // تعريف نواة لفلتر التحسين
  var kernel = [
    [-1, -1, -1],
    [-1,  9, -1],
    [-1, -1, -1]
  ];

  // تطبيق فلتر التحسين باستخدام النواة
  Image sharpenedImage = convolve(image, kernel);

  // حفظ الصورة المحسنة
  File(outputImagePath).writeAsBytesSync(encodeJpg(sharpenedImage));
}

Image convolve(Image image, List<List<int>> kernel) {
  int rows = image.height;
  int cols = image.width;

  for (int y = 1; y < rows - 1; y++) {
    for (int x = 1; x < cols - 1; x++) {
      int sum = 0;

      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          int pixel = image.getPixel(x + i, y + j);
          int value = getRed(pixel);
          sum += kernel[j + 1][i + 1] * value;
        }
      }

      sum = sum.clamp(0, 255);
      image.setPixel(x, y, getColor(sum, sum, sum));
    }
  }

  return image;
}