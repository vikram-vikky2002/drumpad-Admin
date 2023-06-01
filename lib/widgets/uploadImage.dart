import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadWidget extends StatefulWidget {
  const ImageUploadWidget({super.key});

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _imageFile;
  String? _uploadedImageUrl;

  Future<void> _uploadImage() async {
    try {
      print('==============================================================');
      final storage = FirebaseStorage.instance;
      final imageRef = storage
          .ref('ProductImage')
          .child('images/${DateTime.now().toString()}');
      final uploadTask = imageRef.putFile(_imageFile!);
      print('==============================================================');
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = imageUrl;
      });
    } on FirebaseException catch (e) {
      print('-----------------------------------------------------------');
      print(e.message);
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Widget to choose an image file
        ElevatedButton(
          onPressed: () {
            _selectImage();
          },
          child: const Text('Choose Image'),
        ),

        // Widget to upload the selected image
        ElevatedButton(
          onPressed: _imageFile == null ? null : _uploadImage,
          child: const Text('Upload Image'),
        ),

        // Widget to display the uploaded image URL
        _uploadedImageUrl != null
            ? Image.network(_uploadedImageUrl!)
            : const SizedBox(),
      ],
    );
  }
}
