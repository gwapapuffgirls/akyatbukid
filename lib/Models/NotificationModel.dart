import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  String fromUserId;
  Timestamp timestamp;
  bool follow;

  NotificationModel({this.id, this.fromUserId, this.timestamp, this.follow});

  factory NotificationModel.fromDoc(DocumentSnapshot doc) {
    return NotificationModel(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      timestamp: doc['timestamp'],
      follow: doc['follow'],
    );
  }
}

