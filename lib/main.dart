import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'permission_service.dart';
import 'media_service_interface.dart';
import 'display_image_widget.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 70,
              left: 50,
              right: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: Center(
                  child: Text(
                    '       Welcome             to our application',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("Images/fci.jpg"),
                  ),
                  SizedBox(height: 0),
                  SizedBox(height: 0),
                  AvatarUploader(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarUploader extends StatefulWidget {
  @override
  _AvatarUploaderState createState() => _AvatarUploaderState();
}

class _AvatarUploaderState extends State<AvatarUploader> {
  final MediaServiceInterface _mediaService = PermissionServiceImpl();

  File? imageFile;
  bool _isLoadingGettingImage = false;

  Future<void> _pickImageSource() async {
    await _showCupertinoModalPopup();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File pickedImageFile = File(pickedFile.path);
        await _getImageFromFile(pickedImageFile);
      }
    } catch (e) {
      print("Error picking image from camera: $e");
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        File pickedFile = File(result.files.first.path!);
        await _getImageFromFile(pickedFile);
      }
    } catch (e) {
      print("Error picking image from gallery: $e");
    }
  }

  Future<void> _getImageFromFile(File file) async {
    setState(() => _isLoadingGettingImage = true);
    final _pickedImageFile = await _mediaService.compressFile(file);
    setState(() => _isLoadingGettingImage = false);

    if (_pickedImageFile != null) {
      setState(() => imageFile = _pickedImageFile);
    }
  }

  Future<void> _showCupertinoModalPopup() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            color: Colors.black,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildListTile('Camera', _pickImageFromCamera),
              SizedBox(height: 7.0),
              _buildListTile('Gallery', _pickImageFromGallery),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(String title, Function() onTapFunction) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        onTap: () async {
          Navigator.pop(context);
          await onTapFunction();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.black54, // لون الخلفية
          onPrimary: Colors.white, // لون النص
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0), // شكل الحواف
            side: BorderSide(color: Colors.red), // لون الحدود
          ),
        ),
        onPressed: () async {
          await _pickImageSource();
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            '<<Your Image>>',
            style: TextStyle(
              fontSize: 35.0,
            ),
          ),
        ),
      ),
    );
  }
}

class PermissionServiceImpl implements PermissionService, MediaServiceInterface {
  @override
  Future requestPhotosPermission() async {
    // Implement the logic for requesting photos permission
  }

  @override
  Future<bool> handlePhotosPermission(BuildContext context) async {
    // Implement the logic for handling photos permission
    return true; // Replace with the actual logic
  }

  @override
  Future requestCameraPermission() async {
    // Implement the logic for requesting camera permission
  }

  @override
  Future<bool> handleCameraPermission(BuildContext context) async {
    // Implement the logic
    return true; // Replace with the actual logic
  }

  @override
  Future<File?> compressFile(File file, {int quality = 30}) async {
    // Provide an empty implementation or the actual logic if needed
    return null;
  }

  @override
  Future<File?> uploadImage(BuildContext context, AppImageSource appImageSource, {bool shouldCompress = true}) async {
    // Provide an empty implementation or the actual logic if needed
    return null;
  }
}
