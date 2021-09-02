import "package:flutter/material.dart";
//import 'package:flutter_widgets/const/_const.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:akyatbukid/profile/editprofile.dart';
import 'package:akyatbukid/profile/post.dart';
import 'package:akyatbukid/profile/media.dart';
import 'package:akyatbukid/profile/peers.dart';
import 'package:akyatbukid/profile/events.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 4,
      child: Column(
        children: <Widget>[
          Column(children: [
            Container(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()),
                        );
                      },
                    )),
                Container(
                    child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.amber,
                )),
                Container(
                    transform: Matrix4.translationValues(0.0, -8.0, 0.0),
                    width: 85,
                    height: 20,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: Center(
                        child: Text("begginer",
                            style:
                                TextStyle(color: Colors.black, fontSize: 12)))),
                Text("Finina Chloie Biscocho", style: TextStyle(fontSize: 20)),
                SizedBox(height: 5),
                Container(
                    child: Text("bio is here BTCH!",
                        style: TextStyle(fontSize: 15))),
                SizedBox(height: 15),
                Container(
                  width: 80,
                  height: 20,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    child: Text('Follow',
                        style: TextStyle(color: Colors.black, fontSize: 11)),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: 80,
                  height: 20,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    child: Text('Message',
                        style: TextStyle(color: Colors.black, fontSize: 11)),
                  ),
                )
              ]),
            )
          ]),
          TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BubbleTabIndicator(
                indicatorHeight: 25.0,
                indicatorColor: Colors.deepOrangeAccent,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
                // Other flags
                // indicatorRadius: 1,
                // insets: EdgeInsets.all(1),
                // padding: EdgeInsets.all(10)
              ),
              // indicator: RectangularIndicator(
              //   bottomLeftRadius: 100,
              //   bottomRightRadius: 100,
              //   topLeftRadius: 100,
              //   topRightRadius: 100,
              // ),
              tabs: [
                Tab(text: "Post"),
                Tab(text: "Media"),
                Tab(text: "Peers"),
                Tab(text: "Events"),
              ]),
          Expanded(
            child: Container(
              child: TabBarView(children: [
                Container(
                  child: Post(),
                ),
                Container(
                  child: Media(),
                ),
                Container(
                  child: Peers(),
                ),
                Container(
                  child: Events(),
                ),
              ]),
            ),
          )
        ],
      ),
    ));
  }
}
