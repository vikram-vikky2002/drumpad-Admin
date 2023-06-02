// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, avoid_web_libraries_in_flutter, must_be_immutable, file_names, avoid_init_to_null

import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drum_pad_admin/widgets/radioButtons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/percent_indicator.dart';

class EditSong extends StatefulWidget {
  EditSong({
    super.key,
    required this.id,
    required this.Title,
    required this.Subtitle,
    required this.Imageurl,
    required this.trending,
    required this.genre,
    required this.songUrl,
    required this.user,
  });

  final String Title;
  final String Subtitle;
  String Imageurl;
  final String id;
  final String trending;
  final String genre;
  String songUrl;
  final String user;

  @override
  State<EditSong> createState() => _EditSongState();
}

class _EditSongState extends State<EditSong> {
  late final TextEditingController _songTitleController,
      _songSubTitleController;
  var NewImageUrl = null, NewSongUrl = null;
  String? newTrending, newGenre;
  double imageuploadProgress = 0, audioUploadProgress = 0;
  bool imageUploading = false, audioUploading = false;
  List<String> trendOptions = ['None', 'Yes', 'No'],
      genreOptions = ['None', 'Hip Hop', 'House', 'Rock', 'Trap'];

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
          var ref = fs.ref().child('DemoSong/${widget.id}');
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
            NewSongUrl = downloadUrl;
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
            var ref = fs.ref().child('DemoImages/${widget.id}');
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
              NewImageUrl = downloadUrl;
              imageUploading = false;
            });
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _songTitleController = TextEditingController();
    _songSubTitleController = TextEditingController();
  }

  updateData() {
    if (_songTitleController.text != '') {
      FirebaseFirestore.instance.collection('DemoSongs').doc(widget.id).update({
        'title': _songTitleController.text,
        'lastEditedBy': widget.user,
      }).then((value) {
        SnackBar snackBar = SnackBar(
          content: Text(
            'song Updated : ${widget.id}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 212, 38),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError(
        (error) {
          SnackBar snackBar = SnackBar(
            content: Text(
              'Error : $error',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 173, 5, 5),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    }
    if (_songSubTitleController.text != '') {
      FirebaseFirestore.instance.collection('DemoSongs').doc(widget.id).update({
        'subTitle': _songSubTitleController.text,
        'lastEditedBy': widget.user,
      }).then((value) {
        SnackBar snackBar = SnackBar(
          content: Text(
            'song Updated : ${widget.id}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 212, 38),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError(
        (error) {
          SnackBar snackBar = SnackBar(
            content: Text(
              'Error : $error',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 173, 5, 5),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    }
    if (NewImageUrl != null) {
      FirebaseFirestore.instance.collection('DemoSongs').doc(widget.id).update({
        'imgUrl': NewImageUrl,
        'lastEditedBy': widget.user,
      }).then((value) {
        SnackBar snackBar = SnackBar(
          content: Text(
            'song : ${widget.id}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 212, 38),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError(
        (error) {
          SnackBar snackBar = SnackBar(
            content: Text(
              'Error : $error',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 173, 5, 5),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    }
    if (NewSongUrl != null) {
      FirebaseFirestore.instance.collection('DemoSongs').doc(widget.id).update({
        'songUrl': NewSongUrl,
        'lastEditedBy': widget.user,
      }).then((value) {
        SnackBar snackBar = SnackBar(
          content: Text(
            'song : ${widget.id}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 212, 38),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError(
        (error) {
          SnackBar snackBar = SnackBar(
            content: Text(
              'Error : $error',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 173, 5, 5),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    }
    if (newGenre != null) {
      FirebaseFirestore.instance.collection('DemoSongs').doc(widget.id).update({
        'genre': newGenre,
        'lastEditedBy': widget.user,
      }).then((value) {
        SnackBar snackBar = SnackBar(
          content: Text(
            'song Updated : ${widget.id}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 212, 38),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError(
        (error) {
          SnackBar snackBar = SnackBar(
            content: Text(
              'Error : $error',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 173, 5, 5),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    }
    if (newTrending != null) {
      FirebaseFirestore.instance.collection('DemoSongs').doc(widget.id).update({
        'trending': newTrending,
        'lastEditedBy': widget.user,
      }).then((value) {
        SnackBar snackBar = SnackBar(
          content: Text(
            'song Updated : ${widget.id}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 212, 38),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError(
        (error) {
          SnackBar snackBar = SnackBar(
            content: Text(
              'Error : $error',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 173, 5, 5),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    }
    SnackBar snackBar = SnackBar(
      content: Text(
        'song Updated : ${widget.id}',
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 212, 38),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          'Edit Song => Song Id : ${widget.id}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 3,
          ),
        ),
      ),
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: Colors.cyanAccent,
                    ),
                    child: NewImageUrl == null
                        ? Image.network(
                            widget.Imageurl,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            NewImageUrl!,
                            fit: BoxFit.fill,
                          ),
                  ),
                  const SizedBox(width: 40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Title : ${widget.Title}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Text(
                              'Sub Title : ${widget.Subtitle}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Trending : ${widget.trending}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Text(
                              'Genre : ${widget.genre}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (widget.songUrl != "")
                              const Text(
                                'Song : Available',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )
                            else
                              const Text(
                                'Song : Not Available',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
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
                            style: const TextStyle(
                              color: Colors.white,
                            ),
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
                      Flexible(child: RadioButtons(options: trendOptions)),
                      Flexible(child: RadioButtons(options: genreOptions)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Padding(
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
                                value: newTrending,
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
                                    newTrending = newValue!;
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
                        Padding(
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
                                value: newGenre,
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
                                    newGenre = newValue!;
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
                              onTap: () {
                                _pickImage();
                              },
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
                              onTap: () {
                                _pickAudio();
                              },
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
                ],
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
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
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
                        onTap: () {
                          updateData();
                        },
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
                              'Update',
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
