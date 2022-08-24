import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:notekeeper1/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
        builder: (context,snapshot){
          if(snapshot.hasError){
            print("something went wrong");
          }
          if(snapshot.connectionState==ConnectionState.done){
            return MaterialApp(
              title: 'Note Keeper',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.deepPurple
              ),

              home: HomePage(),
            );
          }
          return CircularProgressIndicator();
        }
    );
  }
}