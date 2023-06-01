// ignore_for_file: avoid_web_libraries_in_flutter, file_names

import 'dart:html';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSong extends StatefulWidget {
  const AddSong({super.key, required this.user});
  final String user;

  @override
  State<AddSong> createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  final _formkey = GlobalKey<FormState>();
  late final TextEditingController _songTitleController,
      _songSubTitleController;
  String? imgUrl, genre, trending, songUrl;
  late String docID;
  late Map<String, dynamic> songData;

  @override
  void initState() {
    _songTitleController = TextEditingController();
    _songSubTitleController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _songTitleController.dispose();
      _songSubTitleController.dispose();
    }

    super.dispose();
  }

  validator() {
    if (_songTitleController.text != '' &&
        _songSubTitleController.text != '' &&
        genre != null &&
        trending != null &&
        imgUrl != null) {
      return true;
    } else {
      return false;
    }
  }

  void _pickAudio() async {
    docID = DateTime.now().toString();
    var input = FileUploadInputElement()..accept = 'audio/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child('DemoSongs/$docID').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        Fluttertoast.showToast(
          msg: 'Song Uploaded Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        setState(() {
          songUrl = downloadUrl;
        });
      });
    });
  }

  void _pickImage() async {
    docID = DateTime.now().toString();
    var input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child('DemoImages/$docID').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        Fluttertoast.showToast(
          msg: 'Image Uploaded Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        setState(() {
          imgUrl = downloadUrl;
        });
      });
    });
  }

  uploadForm() async {
    if (validator()) {
      songData = {
        'title': _songTitleController.text,
        'subTitle': _songSubTitleController.text,
        'imgUrl': imgUrl,
        'genre': genre,
        'songUrl': songUrl,
        'trending': trending,
        'lastEditedBy': widget.user,
      };

      try {
        final collectionRef =
            FirebaseFirestore.instance.collection('DemoSongs');
        await collectionRef.doc(docID).set(songData);
        Fluttertoast.showToast(
          msg: 'Song Added Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        _clearForm();
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error uploading Song Data to Firestore: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Please fill all the fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.redAccent,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  void _clearForm() {
    _songSubTitleController.clear();
    _songTitleController.clear();
    setState(() {
      imgUrl = null;
      genre = null;
      trending = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.cyan,
                Colors.cyanAccent,
                Colors.yellow,
              ],
            ),
          ),
        ),
        title: const Text(
          'ADD SONG',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _songTitleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter song title';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 38, 37, 49),
                          border: OutlineInputBorder(),
                          labelText: 'Song Title',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Flexible(
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _songSubTitleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter song sub title';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 38, 37, 49),
                          border: OutlineInputBorder(),
                          labelText: 'Song Sub Title',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 38, 37, 49),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width,
                          child: Expanded(
                            child: DropdownButton(
                              borderRadius: BorderRadius.circular(10),
                              value: trending,
                              dropdownColor: Colors.grey,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              hint: const Text(
                                'Trending or Not',
                                style: TextStyle(color: Colors.white),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  trending = newValue!;
                                });
                              },
                              items: <String>[
                                'Yes',
                                'No',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 38, 37, 49),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width,
                          child: Expanded(
                            child: DropdownButton(
                              borderRadius: BorderRadius.circular(10),
                              value: genre,
                              dropdownColor: Colors.grey,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              hint: const Text(
                                'Select Genre',
                                style: TextStyle(color: Colors.white),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  genre = newValue!;
                                });
                              },
                              items: <String>[
                                'Hip Hop',
                                'House',
                                'Rock',
                                'Trap',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: InkWell(
                          onTap: () => _pickImage(),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(255, 38, 37, 49),
                            ),
                            child: const Center(
                                child: Text(
                              'Upload Image',
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: InkWell(
                          onTap: () => _pickAudio(),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(255, 38, 37, 49),
                            ),
                            child: const Center(
                                child: Text(
                              'Upload Song',
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 38, 37, 49),
                        ),
                        child: Center(
                          child: Container(
                            child: imgUrl == null
                                ? Image.asset(
                                    'Assets/defaultImage.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    imgUrl!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: InkWell(
                        onTap: () {
                          _clearForm();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: InkWell(
                        onTap: () => uploadForm(),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
