import 'package:flutter/material.dart';
import 'package:notekeeper1/update_note.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ListNotes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListNotesState();
  }
}

class ListNotesState extends State<ListNotes> {

  final Stream<QuerySnapshot> notesSteam = FirebaseFirestore.instance.collection('notes').snapshots();
  // var priority;
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');
  Future<void> deleteuser(id){
    return notes
        .doc(id)
        .delete()
        .then((value) => print("successfully deleted"))
        .catchError((error) => print("Not deleted"));
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: notesSteam,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if (snapshot.hasError) {
        print("something went wrong");
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }


      final List storedocs = [];
      snapshot.data!.docs.map((DocumentSnapshot document){
        Map a = document.data() as Map<String, dynamic>;
        storedocs.add(a);
        a['id'] = document.id;
      }).toList();

      return Container(
          child: ListView(
            children: <Widget>[

              for(int i=0;i<storedocs.length;i++) ...[
              Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    child: getPriorityIcon(storedocs[i]['priority']),
                    backgroundColor: getPriorityColor(storedocs[i]['priority']),
                  ),
                  title: Text(storedocs[i]['title']),
                  subtitle: Text(storedocs[i]['description']),
                  trailing: GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      deleteuser(storedocs[i]['id']);
                    },
                  ),
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateNotes(storedocs[i]['id'])));
                  },
                ),
              ),]

            ],
          ));
    }
    );

  }
  // Returns the priority color
  Color getPriorityColor(var priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
        break;
      case 'Low':
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(var priority) {
    switch (priority) {
      case 'High':
        return Icon(Icons.play_arrow);
        break;
      case 'Low':
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }
}
