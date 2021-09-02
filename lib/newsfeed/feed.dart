import 'package:akyatbukid/newsfeed/search.dart';
import 'package:flutter/material.dart';
import 'package:akyatbukid/newsfeed/addStatus.dart';

class ThreadPostData {
  final String userName;
  final String userThumbnail;
  final int postTimeStamp;
  final String postContent;
  final String postImage;
  final int postLikeCount;
  final int postCommentCount;

  ThreadPostData(
      {this.userName,
      this.userThumbnail,
      this.postTimeStamp,
      this.postContent,
      this.postImage,
      this.postLikeCount,
      this.postCommentCount});
}

class FeedPage1 extends StatefulWidget {
  final String currentUserId;

  const FeedPage1({Key key, this.currentUserId}) : super(key: key);
  @override
  FeedPage1State createState() => FeedPage1State();
}

class FeedPage1State extends State<FeedPage1> {
  List<ThreadPostData> dummyData = [
    new ThreadPostData(
        userName: "Nathalie",
        userThumbnail: "",
        postTimeStamp: DateTime.now()
            .subtract(new Duration(seconds: 10))
            .millisecondsSinceEpoch,
        postContent: "Hello",
        postLikeCount: 5,
        postCommentCount: 2,
        postImage: ''),
    new ThreadPostData(
        userName: "Jo",
        userThumbnail: "",
        postTimeStamp: DateTime.now()
            .subtract(new Duration(seconds: 10))
            .millisecondsSinceEpoch,
        postContent:
            "HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello",
        postLikeCount: 5,
        postCommentCount: 2,
        postImage: ''),
    new ThreadPostData(
        userName: "Nicole",
        userThumbnail: "",
        postTimeStamp: DateTime.now()
            .subtract(new Duration(seconds: 10))
            .millisecondsSinceEpoch,
        postContent: "Hello",
        postLikeCount: 5,
        postCommentCount: 2,
        postImage: ''),
    new ThreadPostData(
        userName: " Biscocho  ",
        userThumbnail: "",
        postTimeStamp: DateTime.now()
            .subtract(new Duration(seconds: 10))
            .millisecondsSinceEpoch,
        postContent: "Hello",
        postLikeCount: 5,
        postCommentCount: 2,
        postImage: ''),
  ];

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _takeUserData() async {
    setState(() {
      _isLoading = true;
    });
  }

  void _incrementCounter() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddStatus(currentUserId: widget.currentUserId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 20.0),
            child: TextField(
              // controller: _searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                hintText: 'Search ...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[400]),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPage(
                                currentUserId:
                                    widget.currentUserId))); // clearSearch();
                  },
                ),
                filled: true,
              ),
              readOnly: true,
              enableInteractiveSelection: false,
              // focusNode: FocusNode(),
              onTap: () {
                // Navigator.push(context,MaterialPageRoute(builder: (context) => BookingPage(currentUserId:widget.currentUserId)));
              },
            ),
          ),
          Stack(
            children: <Widget>[
              ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                  children: dummyData.map(_listTile).toList()),
              _isLoading
                  ? Positioned(
                      child: Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                          color: Colors.white.withOpacity(0.7)),
                    )
                  : Container()
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ),
    );
  }

  Widget _listTile(ThreadPostData data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person_pin, size: 30)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(data.userName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          //child: Text(readTimestamp(data.postTimeStamp), style: TextStyle (fontSize: 18),),
                        ),
                      ])
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 10.4, 4.0, 10.0),
                child: Text(data.postContent, style: TextStyle(fontSize: 16)),
              ),
              Divider(height: 2, color: Colors.black),
              Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.thumb_up_alt_rounded, size: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('${data.postLikeCount}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.mode_comment, size: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('${data.postCommentCount}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.share_rounded, size: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                          )
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
