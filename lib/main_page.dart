import 'package:flutter/material.dart';
import 'package:flutter_animations_app/messaging.dart';



class MainPage extends StatefulWidget {
  final String title;
  MainPage(this.title);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Messaging(widget.title);
  }
}
