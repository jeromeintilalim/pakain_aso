import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pakain_aso/components/alarmWidget.dart';

Future<void> getDataFromFirestore() async {
  // Get a reference to the Firestore collection
  CollectionReference alarms = FirebaseFirestore.instance.collection('alarms');

  // Get data from Firestore
  QuerySnapshot querySnapshot = await alarms.get();

  // Process the data
  for (var document in querySnapshot.docs) {
    print('Data from Firestore: ${document.data()}');
  }
}

class AlarmsList extends StatelessWidget {
  const AlarmsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        getDataFromFirestore();
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            return Center(
              child: alarmWidget(document),
            );
          },
        );
      },
    );
  }
}
