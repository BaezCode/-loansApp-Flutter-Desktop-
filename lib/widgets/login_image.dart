import 'package:flutter/material.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/logo.jpg'), fit: BoxFit.cover)),
      child: Container(
        // ignore: sort_child_properties_last
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
          ),
        ),
        constraints: const BoxConstraints(maxWidth: 400),
      ),
    ));
  }
}
