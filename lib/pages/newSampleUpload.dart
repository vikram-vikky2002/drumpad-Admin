import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String? imgUrl;

  upload() {
    var input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child('DemoImages/newFile').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imgUrl = downloadUrl;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Image',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            imgUrl == null
                ? const Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: double.infinity,
                  )
                : Image.network(imgUrl!),
            ElevatedButton(
              onPressed: () => upload(),
              child: const Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              'Image URL : $imgUrl',
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
