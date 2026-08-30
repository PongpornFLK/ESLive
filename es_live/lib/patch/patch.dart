import 'package:flutter/material.dart';

class Patch extends StatefulWidget {
  const Patch({super.key});

  @override
  State<Patch> createState() => _PatchState();
}

class _PatchState extends State<Patch> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(child: Text("Patch")));
  }
}
