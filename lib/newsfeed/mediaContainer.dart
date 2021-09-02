import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MediaContainer extends StatefulWidget {
  final StatusModel status;
  final UserModel author;
  final String currentUserId;

  const MediaContainer({Key key, this.status, this.author, this.currentUserId})
      : super(key: key);
  @override
  _MediaContainerState createState() => _MediaContainerState();
}

class _MediaContainerState extends State<MediaContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget.status.image.isEmpty
            ? SizedBox.shrink()
            : Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.status.image),
                    )),
              ));
  }
}
