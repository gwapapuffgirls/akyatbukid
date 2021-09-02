import 'package:akyatbukid/homepage.dart';
import 'package:akyatbukid/login.dart';
import 'package:akyatbukid/navbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Models/UserModel.dart';
import 'Services/authServices.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';

// import 'package:akyatbukid/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget getScreenId() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return NavPage(currentUserId: snapshot.data.uid);
          } else {
            return HomePage();
          }
        });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return 
       MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: getScreenId(),
      // ),
    );
  }
}
