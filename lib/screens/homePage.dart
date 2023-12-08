// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pakain_aso/screens/update.dart';

import 'add.dart';

class Alarm {
  late String? id;
  late String? title;
  late Timestamp? time;
  late int? servingSize;
  late dynamic repeat;
  late bool status;

  // Constructor
  Alarm(
      {required this.id,
      required this.title,
      required this.time,
      required this.servingSize,
      required this.repeat,
      required this.status});

  // Named constructor for creating a User from a Firestore document
  Alarm.fromFirestore(DocumentSnapshot doc) {
    id = (doc.data() as dynamic)?['id'];
    title = (doc.data() as dynamic)?['title'];
    time = (doc.data() as dynamic)?['time'];
    servingSize = (doc.data() as dynamic)?['serving'];
    repeat = (doc.data() as dynamic)?['repeat'];
    status = (doc.data() as dynamic)?['status'];
  }
}

void updateStatus(String id, bool status) {
  final String documentId = id;
  final DocumentReference documentRef = db.collection("alarms").doc(documentId);

  documentRef.update({
    "status": !status, // Update the status in Firestore
  }).then((value) {
    print("Field updated successfully!");
  }).catchError((error) {
    print("Error updating field: $error");
  });
}

class FirebaseDataWidget extends StatelessWidget {
  const FirebaseDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot<Object?>>>(
      stream: streamDataFromFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Data is ready, use it to build your widget tree

          List<DocumentSnapshot<Object?>> data = snapshot.data!;

          
          return SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.75, // or any fixed height
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var document = data[index];
                  String id = document.id;
                  String title = document['title'];
                  // String time = document['time'];
                  int servingSize = document['serving'];
                  List<dynamic> repeat = document['repeat'];
                  bool status = document['status'];

                  // if (document['time'].runtimeType == Timestamp) {
                  Timestamp timeTimestamp = document['time'];
                  DateTime timeDateTime = timeTimestamp.toDate();
                  String formattedTimestamp =
                      DateFormat('hh:mm a').format(timeDateTime.toLocal());

                  // var listToBeMapped = repeat.join(", ");

                  var mapped = repeat.map((day) => {
                        day.toString().substring(0, 3),
                      });

                  print(repeat.join(", "));
                  var repeatValue =
                      mapped.join(", ").replaceAll('{', '').replaceAll('}', '');

                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlarmEditor(alarmId: id),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 4, right: 16, bottom: 4, left: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xff222831),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              /*1*/
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*2*/
                                  Text(
                                    title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    formattedTimestamp,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 32,
                                      color: Color(0xff00ADB5),
                                    ),
                                  ),
                                  Text(
                                    "Servings: $servingSize",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16),
                                  ),
                                  repeat.contains("noRepeat")
                                      ? Container()
                                      : Text(
                                          "Repeat: $repeatValue",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16),
                                        )
                                ],
                              ),
                            ),
                            /*3*/
                            Switch(
                              value: status,
                              activeColor: const Color(0xffffffff),
                              activeTrackColor: const Color(0xffDA0037),
                              inactiveTrackColor: const Color(0xff393E46),
                              inactiveThumbColor: const Color(0xffeeeeee),
                              onChanged: (newValue) {
                                // Use newValue in your logic
                                updateStatus(id, status);
                              },
                            )
                          ],
                        ),
                      ));
                },
              ));
        }
      },
    );
  }

  Stream<List<DocumentSnapshot<Object?>>> streamDataFromFirebase() {
    return FirebaseFirestore.instance
        .collection('alarms')
        .snapshots()
        .map((QuerySnapshot<Object?> querySnapshot) {
      return querySnapshot.docs;
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var logo = const AssetImage('assets/images/pakainaso.png');
    var image = Image(image: logo, width: 400.0);
    // getData();
    return MaterialApp(
      // title: 'Flutter layout demo',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF141414),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xffeeeeee),
                displayColor: const Color(0xffeeeeee),
              )),
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add schedule',
          backgroundColor: const Color(0xffEA2843),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondRoute()),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            Center(
                child: Container(
              margin: const EdgeInsets.only(top: 24),
              child: image,
            )),
            Center(
                child: Container(
              margin: const EdgeInsets.all(16),
              child: const Text(
                'SCHEDULES',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40),
              ),
            )),
            const FirebaseDataWidget()
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
