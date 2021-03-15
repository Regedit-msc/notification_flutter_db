import 'package:flutter/material.dart';



class NotificationDetails extends StatefulWidget {
  NotificationDetails({
    @required this.title,
    @required this.body,
});
final String title;
  final String body;
  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('NOTIFICATION DETAILS'),
        ),
        body: Column(
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(widget.title),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 20.0,
              ),
            ),
            Divider(),
            Container(
              child: Text(widget.body),
            ),
          ],
        ),
      ),
    );
  }
}
