import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_animations_app/db_related_foo/database_helper.dart';
import 'package:flutter_animations_app/models/message_model.dart';
import 'package:flutter_animations_app/models/noticication.dart';
import 'package:flutter_animations_app/notifications_screen.dart';
import 'package:provider/provider.dart';

class Messaging extends StatefulWidget {
  final String title;
  Messaging(this.title);
  @override
  _MessagingState createState() => _MessagingState();
}

@override
class _MessagingState extends State<Messaging> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    Provider.of<DatabaseHelper>(context, listen: false).initDatabase();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        await Provider.of<DatabaseHelper>(context, listen: false)
            .insertNotification(NotificationModel(
                title: notification['title'], body: notification['body']));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final notification = message['data'];
        await Provider.of<DatabaseHelper>(context, listen: false)
            .insertNotification(NotificationModel(
                title: notification['title'], body: notification['body']));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];
        await Provider.of<DatabaseHelper>(context, listen: false)
            .insertNotification(NotificationModel(
                title: notification['title'], body: notification['body']));
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  _refreshNotifications() async {
    print('ran refresh');
    return await Provider.of<DatabaseHelper>(context, listen: false)
        .fetchNotifications();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: Container(
            child: Column(
              children: [
                Consumer<DatabaseHelper>(
                  builder: (context, notifier, child) => FutureBuilder(
                    future: _refreshNotifications(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.blue,
                            width: 200.0,
                            height: 40.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => NotificationScreen(
                                          notifications: _notifications)));
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: 0.0,
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Icon(Icons.circle_notifications,
                                        color: Colors.white,
                                        )),
                                    Positioned(
                                      top: 2.0,
                                      bottom: 5.0,
                                      left: 120.0,
                                      right: 0.0,
                                      child: Container(
                                        height: 2.0,
                                        width: 1.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.red),
                                        child: Center(child: Text('${snapshot.data.length}')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NotificationScreen(
                                      notifications: _notifications)));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.notifications,
                                color: Colors.white
                                  ,
                                ),
                                Text('Click to see all notifications',
                                style: TextStyle(
                                    color: Colors.white
                                ),

                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}
