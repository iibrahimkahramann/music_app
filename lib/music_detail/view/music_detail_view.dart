import 'package:flutter/material.dart';

class MusicDetailView extends StatefulWidget {
  const MusicDetailView({super.key});

  @override
  State<MusicDetailView> createState() => _MusicDetailViewState();
}

class _MusicDetailViewState extends State<MusicDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('music detail'),
    );
  }
}
