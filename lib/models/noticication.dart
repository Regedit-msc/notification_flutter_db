
class NotificationModel {
  static const tblNotification = 'notifications';
  static const colId = 'id';
  static const colTitle = 'title';
  static const colBody = 'body';
  NotificationModel({this.id ,this.title , this.body});


  NotificationModel.fromMap(Map<String,dynamic> map) {
    id = map[colId];
    title = map[colTitle];
    body = map[colBody];
  }


  int id;
  String title;
  String body;

  Map<String , dynamic> toMap(){
    var map = <String, dynamic> {colTitle:title , colBody:body};
    if (id != null)map[colId] = id;
    return map;
  }


}