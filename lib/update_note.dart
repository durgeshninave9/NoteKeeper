import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notekeeper1/home_page.dart';

class UpdateNotes extends StatefulWidget{
  String id;
  UpdateNotes(this.id);
  @override
  State<StatefulWidget> createState() {
    return UpdateNotesState();
  }
}

class UpdateNotesState extends State<UpdateNotes>{

  final _formKey = GlobalKey<FormState>();
  var priority;
  var drop = 'Low';
  CollectionReference student =
  FirebaseFirestore.instance.collection('notes');

  Future<void> updateUser(id,title, description, priority) {
    return student
        .doc(id)
        .update({'title': title, 'description': description, 'priority': priority})
        .then((value) => print("user updated"))
        .catchError((error)=>print("something went wrong $error"));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

        onWillPop: () async => true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Update Notes'),
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),

            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('notes')
                  .doc(widget.id)
                  .get(),
              builder: (_,snapshot){
                if(snapshot.hasError){
                  print('something went wrong');
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var data = snapshot.data!.data();
                var title = data!['title'];
                var description = data['description'];
                return Form(child:

                  ListView(
                  children: <Widget>[
                    // First element
                    ListTile(
                      title: DropdownButtonFormField(
                          value: drop,

                          items: <String>['Low','High']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),

                          onChanged: (dynamic newValue) {
                            setState(() {
                              drop = newValue;
                              // print(newValue);
                              priority = drop;
                            });
                          }),
                    ),

                    // Second Element
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextFormField(
                        initialValue: title,
                        onChanged: (value) {
                          debugPrint('Something changed in Title Text Field');
                          title = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'Title',
                            // labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                       validator: (value){
                          if(value==null || value.isEmpty){
                            return "Please Enter Title";
                          }
                       },
                      ),
                    ),

                    // Third Element
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextFormField(
                        // style: textStyle,
                        initialValue: description,
                        onChanged: (value) {
                          debugPrint('Something changed in Description Text Field');
                          description = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'Description',
                            // labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),

                    // Fourth Element
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                'Update',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  // print(title);
                                  // if (_formKey.currentState!.validate()){
                                  debugPrint("Update button clicked");
                                  updateUser(widget.id, title, description, priority);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                                // }
                              });
                              },
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                'Delete',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  debugPrint("Delete button clicked");
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
              },
            ),



          ),
        ));
  }
}

