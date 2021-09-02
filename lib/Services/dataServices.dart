import 'package:akyatbukid/Models/NotificationModel.dart';
import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/constant/constant.dart';
// import 'package:twitter/Models/Activity.dart';
// import 'package:twitter/Models/Tweet.dart';
import 'package:akyatbukid/Models/UserModel.dart';

class DatabaseServices {
  static Future<int> followersNum(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;
  }

  static Future<int> followingNum(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection('Following').get();
    return followingSnapshot.docs.length;
  }

  static void updateUserData(UserModel user) {
    usersRef.doc(user.uid).update({
      'fname': user.fname,
      'lname': user.lname,
      'bio': user.bio,
      'profilePicture': user.profilePicture,
      
    });
  }

  static Future<QuerySnapshot> searchUsers(String fname, ) async {
    Future<QuerySnapshot> users = usersRef
        .where('fname', isGreaterThanOrEqualTo: fname)
        .where('fname', isLessThan: fname + 'z')
        // .where('lname', isGreaterThanOrEqualTo: lname)
        // .where('lname', isLessThan: lname + 'z')
        .get();

    return users;
  }

  static void followUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .set({});
    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .set({});

     addNotification(currentUserId, null, true, visitedUserId);
  }

  static void unFollowUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static void createStatus(StatusModel status) {
    statusRef.doc(status.authorId).set({'statusTime': status.timestamp});
    statusRef.doc(status.authorId).collection('userStatus').add({
      'text': status.text,
      'image': status.image,
      "authorId": status.authorId,
      "timestamp": status.timestamp,
      'likes': status.likes,
      'comments': status.comments,
    }).then((doc) async {
      QuerySnapshot followerSnapshot =
          await followersRef.doc(status.authorId).collection('Followers').get();

      for (var docSnapshot in followerSnapshot.docs) {
        feedRefs.doc(docSnapshot.id).collection('userFeed').doc(doc.id).set({
          'text': status.text,
          'image': status.image,
          "authorId": status.authorId,
          "timestamp": status.timestamp,
          'likes': status.likes,
          'comments': status.comments,
        });
      }
    });
  }

  static Future<List> getUserStatus(String userId) async {
    QuerySnapshot userStatusSnap = await statusRef
        .doc(userId)
        .collection('userStatus') 
        .orderBy('timestamp', descending: true)
        .get();
    List<StatusModel> userStatus =
        userStatusSnap.docs.map((doc) => StatusModel.fromDoc(doc)).toList();

    return userStatus;
  }

  static Future<List> getHomeStatus(String currentUserId) async {
    QuerySnapshot homeStatus = await feedRefs
        .doc(currentUserId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .get();

    List<StatusModel> followingStatus =
        homeStatus.docs.map((doc) => StatusModel.fromDoc(doc)).toList();
    return followingStatus;
  }

  static void likeStatus(String currentUserId, StatusModel status) {
    DocumentReference statusDocProfile =
        statusRef.doc(status.authorId).collection('userStatus').doc(status.id);
    statusDocProfile.get().then((doc) {
      int likes = doc.data()['likes'];
      statusDocProfile.update({'likes': likes + 1});
    });

    DocumentReference statusDocFeed =
        feedRefs.doc(currentUserId).collection('userFeed').doc(status.id);
    statusDocFeed.get().then((doc) {
      if (doc.exists) {
        int likes = doc.data()['likes'];
        statusDocFeed.update({'likes': likes + 1});
      }
    });

    likesRef.doc(status.id).collection('statusLikes').doc(currentUserId).set({});

     addNotification(currentUserId, status, false, null);
  }

  static void unlikeStatus(String currentUserId, StatusModel status) {
    DocumentReference statusDocProfile =
        statusRef.doc(status.authorId).collection('userStatus').doc(status.id);
    statusDocProfile.get().then((doc) {
      int likes = doc.data()['likes'];
      statusDocProfile.update({'likes': likes - 1});
    });

    DocumentReference statusDocFeed =
        feedRefs.doc(currentUserId).collection('userFeed').doc(status.id);
    statusDocFeed.get().then((doc) {
      if (doc.exists) {
        int likes = doc.data()['likes'];
        statusDocFeed.update({'likes': likes - 1});
      }
    });

    likesRef
        .doc(status.id)
        .collection('statusLikes')
        .doc(currentUserId)
        .get()
        .then((doc) => doc.reference.delete());
  }

  static Future<bool> isLikeStatus(String currentUserId, StatusModel status) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(status.id)
        .collection('statusLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  static Future<List<NotificationModel>> getNotification(String userId) async {
    QuerySnapshot userNotificationSnapshot = await notificationRef
        .doc(userId)
        .collection('userNotification')
        .orderBy('timestamp', descending: true)
        .get();

    List<NotificationModel> notification = userNotificationSnapshot.docs
        .map((doc) => NotificationModel.fromDoc(doc))
        .toList();

    return notification;
  }

  static void addNotification(
      String currentUserId, StatusModel status, bool follow, String followedUserId) {
    if (follow) {
      notificationRef.doc(followedUserId).collection('userNotification').add({
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        "follow": true,
      });
    } else {
      //like
      notificationRef.doc(status.authorId).collection('userNotification').add({
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        "follow": false,
      });
    }
  }
}