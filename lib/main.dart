import 'package:drum_pad_admin/pages/addSong.dart';
import 'package:drum_pad_admin/pages/allSongsPage.dart';
import 'package:drum_pad_admin/pages/loginScreen.dart';
import 'package:drum_pad_admin/pages/membershipPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/homePage.dart';
import 'pages/newSampleUpload.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB533aXNj7XfE8T6mMqnvyCVhHPV85pxMs",
      authDomain: "drumpad-appsait.firebaseapp.com",
      projectId: "drumpad-appsait",
      storageBucket: "drumpad-appsait.appspot.com",
      messagingSenderId: "513880157388",
      appId: "1:513880157388:web:264a75b313df648f516669",
      measurementId: "G-BTTR1LKCEZ",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drum Pad Machine Admin',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      // home: const LoginPage(),
      // home: const MyHomePage(title: 'DRUM PAD ADMIN'),
      // home: const UploadImage(),
      // home: const AllSongsPage(user: 'null'),
      // home: const MembershipPage(),
    );
  }
}
