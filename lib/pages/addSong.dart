// ignore_for_file: avoid_web_libraries_in_flutter, file_names

import 'dart:html';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
  double imageuploadProgress = 0, audioUploadProgress = 0;
  bool imageUploading = false, audioUploading = false;
  int newTrending = 0, newGenre = 0, premium = 0;
  List<String> trendOptions = ['None', 'Yes', 'No'],
      genreOptions = ['None', 'Hip Hop', 'House', 'Rock', 'Trap'];

  @override
  void initState() {
    _songTitleController = TextEditingController();
    _songSubTitleController = TextEditingController();
    docID = DateTime.now().toString();
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
        newGenre != 0 &&
        newTrending != 0 &&
        imgUrl != null) {
      return true;
    } else {
      return false;
    }
  }

  void _pickAudio() async {
    setState(() {
      audioUploading = true;
    });
    var input = FileUploadInputElement()..accept = 'audio/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen(
        (event) async {
          var ref = fs.ref().child('DemoSong/$docID');
          var uploadTask = ref.putBlob(file);
          uploadTask.snapshotEvents.listen(
            (TaskSnapshot snapshot) {
              double progress =
                  snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
              setState(() {
                audioUploadProgress = progress;
              });
            },
          );
          await uploadTask;
          String downloadUrl = await ref.getDownloadURL();
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
            audioUploading = false;
          });
        },
      );
    });
  }

  void _pickImage() async {
    setState(() {
      imageUploading = true;
    });
    var input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen(
      (event) {
        final file = input.files!.first;
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen(
          (event) async {
            var ref = fs.ref().child('DemoImages/$docID');
            var uploadTask = ref.putBlob(file);
            uploadTask.snapshotEvents.listen(
              (TaskSnapshot snapshot) {
                double progress =
                    snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
                setState(() {
                  imageuploadProgress = progress;
                });
              },
            );
            await uploadTask;
            String downloadUrl = await ref.getDownloadURL();
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
              imageUploading = false;
            });
          },
        );
      },
    );
  }

  uploadForm() async {
    if (validator()) {
      songData = {
        'title': _songTitleController.text,
        'subTitle': _songSubTitleController.text,
        'imgUrl': imgUrl,
        'genre': genreOptions[newGenre],
        'songUrl': songUrl,
        'trending': trendOptions[newTrending],
        'premium': trendOptions[premium] == 'Yes' ? true : false,
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
      newGenre = 0;
      newTrending = 0;
      premium = 0;
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
              Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              child: Text(
                                'Trending : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 1; i < trendOptions.length; i++)
                          RadioListTile(
                            value: i,
                            groupValue: newTrending,
                            onChanged: (value) {
                              setState(() {
                                newTrending = value!;
                              });
                            },
                            title: Text(
                              trendOptions[i],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              child: Text(
                                'Premium : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 1; i < trendOptions.length; i++)
                          RadioListTile(
                            value: i,
                            groupValue: premium,
                            onChanged: (value) {
                              setState(() {
                                premium = value!;
                              });
                            },
                            title: Text(
                              trendOptions[i],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              child: Text(
                                'Genre : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 1; i < genreOptions.length; i++)
                          RadioListTile(
                            value: i,
                            groupValue: newGenre,
                            onChanged: (value) {
                              setState(() {
                                newGenre = value!;
                              });
                            },
                            title: Text(
                              genreOptions[i],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (imageUploading == true)
                    LinearPercentIndicator(
                      width: 250,
                      barRadius: const Radius.circular(10),
                      lineHeight: 14.0,
                      percent: imageuploadProgress,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blue,
                    )
                  else
                    LinearPercentIndicator(
                      width: 250,
                      barRadius: const Radius.circular(10),
                      lineHeight: 14.0,
                      percent: 1.0,
                      backgroundColor: const Color.fromARGB(0, 158, 158, 158),
                      progressColor: const Color.fromARGB(0, 33, 149, 243),
                    ),
                  const SizedBox(width: 20),
                  if (audioUploading == true)
                    LinearPercentIndicator(
                      width: 250,
                      barRadius: const Radius.circular(10),
                      lineHeight: 14.0,
                      percent: audioUploadProgress,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blue,
                    )
                  else
                    LinearPercentIndicator(
                      width: 250,
                      barRadius: const Radius.circular(10),
                      lineHeight: 14.0,
                      percent: 1.0,
                      backgroundColor: const Color.fromARGB(0, 158, 158, 158),
                      progressColor: const Color.fromARGB(0, 33, 149, 243),
                    ),
                ],
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
