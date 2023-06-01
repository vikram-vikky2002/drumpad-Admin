import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drum_pad_admin/pages/addSong.dart';
import 'package:drum_pad_admin/pages/allSongsPage.dart';
import 'package:drum_pad_admin/pages/loginScreen.dart';
import 'package:drum_pad_admin/pages/membershipPage.dart';
import 'package:drum_pad_admin/widgets/homePageTiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.currentUser});

  final String title;
  final User? currentUser;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String timeText = '';
  String dateText = '';
  String name = 'Loading...';

  String formatCurrentLiveTime(DateTime time) {
    return DateFormat('hh:mm:ss a').format(time);
  }

  String formatCurrentLiveDate(DateTime date) {
    return DateFormat('dd MMMM, yyyy').format(date);
  }

  getCurrentLiveTime() {
    final DateTime timeNow = DateTime.now();
    final String liveTime = formatCurrentLiveTime(timeNow);
    final String liveDate = formatCurrentLiveDate(timeNow);

    if (mounted) {
      setState(() {
        timeText = liveTime;
        dateText = liveDate;
      });
    }
  }

  getname() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(widget.currentUser!.uid)
        .get()
        .then(
      (value) {
        name = value['name'];
      },
    );
  }

  _signOut() {
    FirebaseAuth.instance.signOut();
    SnackBar snackBar = const SnackBar(
      content: Text(
        'Logout Successfull...',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.yellowAccent,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (builder) => const LoginPage(),
      ),
    );
  }

  @override
  void initState() {
    dateText = formatCurrentLiveDate(DateTime.now());
    timeText = formatCurrentLiveTime(DateTime.now());
    getname();
    Timer.periodic(
        const Duration(seconds: 1), (Timer t) => getCurrentLiveTime());
    super.initState();
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
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 3,
          ),
        ),
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome, $name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13),
                            child: Icon(
                              Icons.access_time_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$timeText \n$dateText',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () => _signOut(),
                      child: Container(
                        width: 130,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.cyan,
                              Colors.cyanAccent,
                              Colors.yellow,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 13, left: 13, right: 13, bottom: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => AllSongsPage(user: name)));
                    },
                    child: HomePageTile(
                      title: 'ALL SONGS',
                      image: 'Assets/guitar.png',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 13, left: 13, right: 13, bottom: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => AddSong(user: name)));
                    },
                    child: HomePageTile(
                      title: 'ADD SONGS',
                      image: 'Assets/addSongs.png',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 13, left: 13, right: 13, bottom: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const MembershipPage()));
                    },
                    child: HomePageTile(
                      title: 'MEMBERSHIP PLANS',
                      image: 'Assets/exclusive.png',
                    ),
                  ),
                ),
                // HomePageTile(
                //     title: 'TRENDING SONGS', image: 'Assets/guitar.png'),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '--- Developed by AppsAiT ---',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
