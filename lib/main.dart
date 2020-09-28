import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_fire_auth/ui/admin_home.dart';
import 'package:fl_fire_auth/ui/home.dart';
import 'package:fl_fire_auth/ui/login.dart';
import 'package:fl_fire_auth/utils/auth_helper.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          UserHelper.saveUser(snapshot.data);
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(snapshot.data.uid).snapshots() ,
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.hasData && snapshot.data != null) {
                final userDoc = snapshot.data;
                final user = userDoc.data();
                if(user['role'] == 'admin') {
                  return AdminHomePage();
                }else{
                  return HomePage();
                }
              }else{
                return Material(
                  child: Center(child: CircularProgressIndicator(),),
                );
              }
            },
          );
        }
        return LoginPage();
      }
    );
  }
}
