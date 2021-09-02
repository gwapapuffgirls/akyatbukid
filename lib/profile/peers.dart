import 'package:akyatbukid/Services/dataServices.dart';
import 'package:flutter/material.dart';

class Peers extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  const Peers({Key key, this.currentUserId, this.visitedUserId})
      : super(key: key);
  @override
  PeersState createState() => PeersState();
}

class PeersState extends State<Peers> {
  int _followersCount = 0;
  int _followingCount = 0;

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0), color: Colors.amber),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // '$_followingCount 
                  'Following',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  // '$_followersCount 
                  'Followers',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
