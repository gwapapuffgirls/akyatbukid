import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/Services/authServices.dart';
import 'package:akyatbukid/Services/dataServices.dart';
import 'package:akyatbukid/constant/constant.dart';
import 'package:akyatbukid/homepage.dart';
import 'package:akyatbukid/booking/topbukid.dart';
import 'package:akyatbukid/booking/suggested.dart';
import 'package:akyatbukid/booking/available.dart';
import 'package:akyatbukid/booking/minorhike.dart';
import 'package:akyatbukid/booking/majorhike.dart';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class BookingPage extends StatefulWidget {
  @override
  BookingPageState createState() => BookingPageState();
}

class BookingPageState extends State<BookingPage> {
  int _bookingSegmentedValue = 0;

  Map<int, Widget> _bookingTabs = <int, Widget>{
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Top Bukid',
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
        'Suggested',
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
        'Available',
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
        'Minor Hike',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
    4: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Major Hike',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Column(children: <Widget>[
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
                        groupValue: _bookingSegmentedValue,
                        thumbColor: Colors.orange[400],
                        backgroundColor: Colors.transparent,
                        children: _bookingTabs,
                        onValueChanged: (i) {
                          setState(() {
                            _bookingSegmentedValue = i;
                          });
                        },
                      )),
                )),
            // SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Divider(),
            ),
            //  buildBookingWidgets(userModel),
          ]),
        ]);
  }
}
