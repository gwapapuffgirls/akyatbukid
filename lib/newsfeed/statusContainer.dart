import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:flutter/material.dart';
import 'package:akyatbukid/constant/constant.dart';
import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Services/dataServices.dart';

class StatusContainer extends StatefulWidget {
  final StatusModel status;
  final UserModel author;
  final String currentUserId;

  const StatusContainer({Key key, this.status, this.author, this.currentUserId})
      : super(key: key);
  @override
  _StatusContainerState createState() => _StatusContainerState();
}

class _StatusContainerState extends State<StatusContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  initStatusLikes() async {
    bool isLiked = await DatabaseServices.isLikeStatus(
        widget.currentUserId, widget.status);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likeStatus() {
    if (_isLiked) {
      DatabaseServices.unlikeStatus(widget.currentUserId, widget.status);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likeStatus(widget.currentUserId, widget.status);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.status.likes;
    initStatusLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  color: Colors.amber,
      //  margin: EdgeInsets.fromLTRB(10.0, top, right, bottom)
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               widget.status.image.isEmpty
                  ? SizedBox.shrink()
                  : Column(
                      children: [
                        // SizedBox(height: 10),
                        Padding(
                           padding: const EdgeInsets.all(0.0),
                          // padding: const EdgeInsets.fromLTRB(8.0, 10.4, 4.0, 20.0),
                          child: Container(
                            
                            height: 250,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.status.image),
                                )),
                          ),
                        )
                      ],
                    ),
              Row(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: widget.author.profilePicture.isEmpty
                          ? AssetImage('assets/images/placeholder.png')
                          : NetworkImage(widget.author.profilePicture),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.author.fname + " " + widget.author.lname,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Padding(
                 padding: const EdgeInsets.fromLTRB(8.0, 5.0, 4.0, 10.0),
                child: Text(
                  widget.status.text,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
             
                    Divider( height: 2, color: Colors.black),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                          color: _isLiked ? Colors.blue : Colors.black,
                        ),
                        onPressed: likeStatus,
                      ),
                      Padding(
                         padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _likesCount.toString() ,
                        ),
                      ),
                    ],
                  ),
                      Row(
                      children: <Widget> [
                        Icon(Icons.mode_comment, size: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          // child: Text('${data.postCommentCount}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget> [
                        Icon(Icons.share_rounded, size: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                        )
                      ],
                    ),
                  // Text(
                  //   widget.status.timestamp.toDate().toString().substring(0, 19),
                  //   style: TextStyle(color: Colors.grey),
                  // )
                ],
              ),
           
            ],
          ),
        ),
      ),
    );
  }
}
