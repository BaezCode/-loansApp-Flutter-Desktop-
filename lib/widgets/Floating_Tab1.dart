// ignore: file_names
import 'package:flutter/material.dart';

class FloatingTab1 extends StatelessWidget {
  const FloatingTab1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pushNamed(context, "nuevoCli"));
  }
}
