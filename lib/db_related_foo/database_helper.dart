import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_animations_app/models/noticication.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import "package:path_provider/path_provider.dart";


class DatabaseHelper extends ChangeNotifier{
 static const _databaseName = "notificationss.db";
 static const _databaseVersion = 1;

 DatabaseHelper._();
 // convert to singleton class
 static final DatabaseHelper instance = DatabaseHelper._();

 Database _database;
 get database async{
   if(_database != null) return _database;
   _database = await initDatabase();
   return _database;
 }

 // initialise db
 initDatabase() async{
   // get applications directory
   Directory dataDirectory =  await getApplicationDocumentsDirectory();
   // app directory with the database name
   String dbPath = join(dataDirectory.path , _databaseName);
   // open the database
    return await openDatabase(dbPath , version: _databaseVersion , onCreate: _onCreateDB);

 }
_onCreateDB(Database db , int version  )async{
   await db.execute('''
    CREATE TABLE ${NotificationModel.tblNotification}(
    ${NotificationModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
     ${NotificationModel.colTitle} TEXT NOT NULL,
     ${NotificationModel.colBody}  TEXT NOT NULL
    )
   '''
   );
}

 insertNotification(NotificationModel notification) async{
   Database db = await database;
    await db.insert(NotificationModel.tblNotification, notification.toMap());
   notifyListeners();
}


 delete() async{
  Database db = await database;
   await db.delete(NotificationModel.tblNotification);
   notifyListeners();
}


 Future<List<NotificationModel>> fetchNotifications() async {
   Database db = await database;
   List<Map> notifications = await db.query(NotificationModel.tblNotification);
   return notifications.length == 0? null: notifications.map((i) => NotificationModel.fromMap(i)).toList();
 }

}





