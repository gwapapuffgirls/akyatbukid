import 'package:flutter/material.dart';
import 'package:akyatbukid/constant/constant.dart';
import 'package:akyatbukid/Models/NotificationModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Services/dataServices.dart';

class NotificationPage extends StatefulWidget {
  final String currentUserId;

  const NotificationPage({Key key, this.currentUserId}) : super(key: key);
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> _notification = [];

  setupNotification() async {
    List<NotificationModel> notification =
        await DatabaseServices.getNotification(widget.currentUserId);
    if (mounted) {
      setState(() {
        _notification = notification;
      });
    }
  }

  buildNotification(NotificationModel notification) {
    return FutureBuilder(
        future: usersRef.doc(notification.fromUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          } else {
            UserModel user = UserModel.fromDoc(snapshot.data);
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: user.profilePicture.isEmpty
                        ? AssetImage('assets/placeholder.png')
                        : NetworkImage(user.profilePicture),
                  ),
                  title: notification.follow == true
                      ? Text('${user.fname} + ${user.lname} follows you')
                      : Text('${user.fname}  + ${user.lname} liked your tweet'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    color: Colors.amber,
                    thickness: 1,
                  ),
                )
              ],
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    setupNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => setupNotification(),
          child: ListView.builder(
              itemCount: _notification.length,
              itemBuilder: (BuildContext context, int index) {
                NotificationModel notification = _notification[index];
                return buildNotification(notification);
              }),
        ));
  }
}
