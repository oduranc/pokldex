import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String data;
  final Color color;
  const Label({Key? key, required this.data, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Center(child: Text(data)),
        ),
      ),
    );
  }
}
