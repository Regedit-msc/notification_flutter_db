import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animations_app/db_related_foo/database_helper.dart';
import 'package:flutter_animations_app/notification_details.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({this.notifications});
  final notifications;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {


  @override
  void initState() {
    super.initState();
  }
  _refreshNotifications() async{
    print('ran refresh');
   return await Provider.of<DatabaseHelper>(context, listen: false).fetchNotifications();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          leading: IconButton(
            icon: Icon(Icons.delete),
        onPressed: () async{
          await Provider.of<DatabaseHelper>(context, listen: false).delete();

        },
      ),
        ),
        body: Consumer<DatabaseHelper>(
          builder: (context, notifier, child) => FutureBuilder(
            future: _refreshNotifications(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  padding: EdgeInsets.all(20.0),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NotificationDetails(title: snapshot.data[index].title, body: snapshot.data[index].body)));
                          },
                          leading: Icon(
                            Icons.notifications,
                            color: Colors.black45,
                          ),
                          title: Text(
                            snapshot.data[index].title,
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          height: 5.0,
                        )
                      ],
                    );
                  },
                  itemCount:snapshot.data.length,
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text('You have no new notifications yet.',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                    ),
                  ],
                );
              }
            }
          ),
        ),
      ),
    );
  }
}
