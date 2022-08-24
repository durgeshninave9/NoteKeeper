import 'package:notekeeper1/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNotes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddNotesState();
  }
}

class AddNotesState extends State<AddNotes> {
  static var _priorities = ['High', 'Low'];
  final _formKey = GlobalKey<FormState>();
  clearText(){
    titleController.clear();
    descriptionController.clear();
  }

  var title = '';
  var description = '';
  var priority = '';
  var drop = 'Low';

  CollectionReference notes = FirebaseFirestore.instance.collection('notes');
  Future<void> addNotes(){
    return notes
        .add({'title':title, 'description':description, 'priority':priority})
        .then((value) => debugPrint('added Successfully'))
        .catchError((error) => debugPrint('Not Added'));

  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Add Notes'),
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Form(child: ListView(
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
                    controller: titleController,
                    // style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
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
                  child: TextField(
                    controller: descriptionController,
                    // style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
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
                          child: const Text(
                            'Add',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              // if (_formKey.currentState!.validate()){
                              title = titleController.text;
                              description = descriptionController.text;

                              addNotes();
                              clearText();
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
                            'Clear',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              clearText();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ));
  }


}
