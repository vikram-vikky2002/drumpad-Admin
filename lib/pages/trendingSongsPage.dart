import 'package:flutter/material.dart';

class TrendingSongsPage extends StatefulWidget {
  const TrendingSongsPage({super.key});

  @override
  State<TrendingSongsPage> createState() => _TrendingSongsPageState();
}

class _TrendingSongsPageState extends State<TrendingSongsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('TRENDING SONGS'),
      ),
      body: const Center(
        child: Text(
          'TRENDING SONGS LIST',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
