import 'package:flutter/material.dart';
import 'package:notekeeper1/list_note.dart';
import 'package:notekeeper1/update_note.dart';
import 'add_notes.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListNotes(),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint('FAB Click');
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNotes()));
        },

        child: Icon(Icons.add),
      ),
    );
  }
}