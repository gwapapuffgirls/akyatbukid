import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  String id;
  String authorId;
  String text;
  String image;
  Timestamp timestamp;
  int likes;
  int comments;

  StatusModel(
      {this.id,
      this.authorId,
      this.text,
      this.image,
      this.timestamp,
      this.likes,
      this.comments});

  factory StatusModel.fromDoc(DocumentSnapshot doc) {
    return StatusModel(
      id: doc.id,
      authorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
      comments: doc['comments'],
    );
  }
}