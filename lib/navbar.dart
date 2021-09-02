import 'package:akyatbukid/newsfeed/feed1.dart';
import 'package:flutter/material.dart';
import 'package:akyatbukid/constant/constant.dart';
import 'package:akyatbukid/newsfeed/feed.dart';
import 'package:akyatbukid/screens/booking.dart';
import 'package:akyatbukid/screens/message.dart';
import 'package:akyatbukid/screens/notification.dart';
import 'package:akyatbukid/screens/profile.dart';

class NavPage extends StatefulWidget {
  final String currentUserId;

  const NavPage({Key key, this.currentUserId}) : super(key: key);

  @override
  NavPageState createState() => NavPageState();
}

class NavPageState extends State<NavPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      FeedPage(currentUserId: widget.currentUserId),
      BookingPage(),
      MessagePage(),
      NotificationPage(),
      ProfilePage(
        currentUserId: widget.currentUserId,
        visitedUserId: widget.currentUserId,
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Image(
            image: AssetImage('assets/images/Logo2.png'),
            width: 100.0,
            height: 100.0,
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          onTap: (index) => setState(() {
            selectedIndex = index;
          }),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.hiking), label: 'Book'),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: 'Message'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notification'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        body: Container(
          child: tabs[selectedIndex],
        ));
  }
}
