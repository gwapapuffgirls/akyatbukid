import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Services/authServices.dart';
import 'package:akyatbukid/Services/dataServices.dart';
import 'package:akyatbukid/constant/constant.dart';
import 'package:akyatbukid/homepage.dart';
import 'package:akyatbukid/newsfeed/mediaContainer.dart';
import 'package:akyatbukid/newsfeed/statusContainer.dart';
import 'package:akyatbukid/profile/peers.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:akyatbukid/profile/editprofile.dart';


class ProfilePage extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  const ProfilePage({Key key, this.currentUserId, this.visitedUserId})
      : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  int _followersCount = 0;
  int _followingCount = 0;
  bool _isFollowing = false;
  int _profileSegmentedValue = 0;
  List<StatusModel> _allStatus = [];
  List<StatusModel> _mediaStatus = [];

  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Posts',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Media',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
    2: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Peers',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
    3: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Events',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
  };

  Widget buildProfileWidgets(UserModel author) {
    switch (_profileSegmentedValue) {
      case 0:
        return
            // Container(child: Text('Post'));
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _allStatus.length,
                itemBuilder: (context, index) {
                  return StatusContainer(
                    currentUserId: widget.currentUserId,
                    author: author,
                    status: _allStatus[index],
                  );
                });
        break;
      case 1:
        return
            // Center(child: Text('Media'));
            Container
            (
              // margin:EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
               padding: EdgeInsets.only(top: 10.0), 
              // color: Colors.amber,
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _mediaStatus.length,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    return MediaContainer(
                      currentUserId: widget.currentUserId,
                      author: author,
                      status: _mediaStatus[index],
                    );
                  }),
            );
        break;
      case 2:
        return 
        // Center(child: Text('Peers'));
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // itemCount: _mediaTweets.length,
            // followersRef.document(widget.uid).collection('userFollowers').snapshots(),
            itemBuilder: (context, index) {
              return Peers(
                currentUserId: widget.currentUserId,
                //  author: author,
                // tweet: _mediaTweets[index],
              );
            });
        break;
      case 3:
        return Center(child: Text('Events'));
        // ListView.builder(
        //     shrinkWrap: true,
        //     physics: NeverScrollableScrollPhysics(),
        //     itemCount: _mediaTweets.length,
        //     itemBuilder: (context, index) {
        //       return TweetContainer(
        //         currentUserId: widget.currentUserId,
        //         author: author,
        //         tweet: _mediaTweets[index],
        //       );
        //     });
        break;
      default:
        return Center(
            child: Text('Something wrong', style: TextStyle(fontSize: 25)));
        break;
    }
  }

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

  followOrUnFollow() {
    if (_isFollowing) {
      unFollowUser();
    } else {
      followUser();
    }
  }

  unFollowUser() {
    DatabaseServices.unFollowUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  followUser() {
    DatabaseServices.followUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  setupIsFollowing() async {
    bool isFollowingThisUser = await DatabaseServices.isFollowingUser(
        widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = isFollowingThisUser;
    });
  }

  getAllStatus() async {
    List<StatusModel> userStatus =
        await DatabaseServices.getUserStatus(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _allStatus = userStatus;
        _mediaStatus =
            _allStatus.where((element) => element.image.isNotEmpty).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupIsFollowing();
    getAllStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: usersRef.doc(widget.visitedUserId).get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Color.fromRGBO(69, 95, 70, 1.0)),
                  ),
                ); 
              }
              UserModel userModel = UserModel.fromDoc(snapshot.data);
              return ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Column(children: <Widget>[
                      Column(children: [
                        Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: widget.currentUserId ==
                                            widget.visitedUserId
                                        ? PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_horiz,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            itemBuilder: (_) {
                                              return <PopupMenuItem<String>>[
                                                new PopupMenuItem(
                                                  child: Text('Logout'),
                                                  value: 'logout',
                                                )
                                              ];
                                            },
                                            onSelected: (selectedItem) {
                                              if (selectedItem == 'logout')
                                                AuthService.logout();
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             HomePage()));
                                            })
                                        : SizedBox()),
                                Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -20.0, 0.0),
                                    child: CircleAvatar(
                                        radius: 52,
                                        backgroundImage: userModel
                                                .profilePicture.isEmpty
                                            ? AssetImage(
                                                'assets/images/placeholder.png')
                                            : NetworkImage(
                                                userModel.profilePicture))),
                                Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -25.0, 0.0),
                                    width: 80,
                                    height: 20,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.green[700]),
                                    child: Center(
                                        child: Text("begginer",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12)))),
                                Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -16.0, 0.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(userModel.fname,
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(width: 5),
                                          Text(userModel.lname,
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -15.0, 0.0),
                                    child: Text(userModel.bio,
                                        style: TextStyle(fontSize: 14))),
                                Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -8.0, 0.0),
                                    width: 80,
                                    height: 20,
                                    child: widget.currentUserId ==
                                            widget.visitedUserId
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfile(
                                                            user: userModel)),
                                              );
                                              setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0))),
                                            child: Text('Edit',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11)),
                                          )
                                        : ElevatedButton(
                                            onPressed: () {
                                              followOrUnFollow();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: _isFollowing
                                                    ? Colors.white
                                                    : Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0))),
                                            child: Text(
                                                _isFollowing
                                                    ? 'Following'
                                                    : 'Follow',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11)),
                                          )),
                                SizedBox(height: 5),
                                Container(
                                  transform:
                                      Matrix4.translationValues(0.0, -8.0, 0.0),
                                  width: 80,
                                  height: 20,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0))),
                                    child: Text('Message',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 11)),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_followingCount Following',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      '$_followersCount Followers',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        )
                      ]),
                      SizedBox(height: 10),
                      Container(
                          //height:50,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: CupertinoSlidingSegmentedControl(
                                  groupValue: _profileSegmentedValue,
                                  thumbColor: Colors.orange[400],
                                  backgroundColor: Colors.transparent,
                                  children: _profileTabs,
                                  onValueChanged: (i) {
                                    setState(() {
                                      _profileSegmentedValue = i;
                                    });
                                  },
                                )),
                          )),
                      // SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left:12.0,right: 12.0),
                        child: Divider(
                         
                        ),
                      ),
                      buildProfileWidgets(userModel),
                    ]),
                  ]);
            }));
  }
}
