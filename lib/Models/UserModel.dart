import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  String email;
  String fname;
  String lname;
  String address;
  String contact;
  String birthday;
  String usertype;
  String profilePicture;
  String bio;

  UserModel({
    this.uid,
    this.email,
    this.fname,
    this.lname,
    this.address,
    this.contact,
    this.birthday,
    this.usertype,
    this.profilePicture,
    this.bio,
  });

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      uid: doc.id,
      email: doc.data()['email'],
      fname: doc.data()['fname'],
      lname: doc.data()['lname'],
      address: doc.data()['address'], 
      contact: doc.data()['contact'],
      birthday: doc.data()['birthday'],
      usertype: doc.data()['usertype'],
      profilePicture: doc.data()['profilePicture'],
      bio: doc.data()['bio'],
    );
  }
}
