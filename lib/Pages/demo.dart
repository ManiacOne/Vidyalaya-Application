import 'package:flutter/material.dart';

class demowidget extends StatelessWidget {
  final Function press;
  const demowidget({
    required this.press});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed:()=> press,
     child: Text('Demo Press',style: TextStyle(color: Colors.white),));
  }
}