import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pakain_aso/screens/homePage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

void submitFormToFirebase(Map<String, dynamic> formData) {
  // Function to unwrap the map if it's an UnmodifiableMapView
  Map<String, dynamic> unwrapMap(Map<String, dynamic> wrappedMap) {
    return wrappedMap is UnmodifiableMapView
        ? Map<String, dynamic>.from(wrappedMap)
        : wrappedMap;
  }

  // Ensure formData is a modifiable map
  formData = unwrapMap(formData);

  DateTime today = DateTime.now();
  DateTime combinedDateTime = DateTime(
    today.year,
    today.month,
    today.day,
    formData['time'].hour,
    formData['time'].minute,
  );
// Convert combinedDateTime to Timestamp
  Timestamp timestamp = Timestamp.fromDate(combinedDateTime);

  // Update formData with the Timestamp
  formData['time'] = timestamp;
  // formData['time'] = FieldValue.serverTimestamp();

  print('formData before sending to Firestore: $formData');
  print(formData['time'].runtimeType);


  // Now, send the modified data to Firebase
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  databaseReference.child('alarms').push().set(formData);

  db.collection("alarms").add(formData).then((DocumentReference doc) =>
      print('DocumentSnapshot added with ID: ${doc.id}'));

  // print('Data written to Firebase successfully!!!!!!!!!');
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // title: 'Flutter layout demo',
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFF141414),
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: const Color(0xffeeeeee),
                  displayColor: const Color(0xffeeeeee),
                )),
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Add Schedule',
              style: TextStyle(color: Color(0xffeeeeee)),
            ),
            backgroundColor: const Color(0xFF141414),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          body: const Center(
            child: Padding(padding: EdgeInsets.all(32.0), child: MyForm()),
          ),
        ));
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _titleFieldKey = GlobalKey<FormBuilderFieldState>();
  final _timeFieldKey = GlobalKey<FormBuilderFieldState>();
  final _servingFieldKey = GlobalKey<FormBuilderFieldState>();
  final _repeatFieldKey = GlobalKey<FormBuilderFieldState>();
  final _statusFieldKey = GlobalKey<FormBuilderFieldState>();

  String formattedTime = DateFormat.Hm().format(DateTime.now());
  void _onChanged(dynamic val) => debugPrint(val.toString());

  dynamic datehaha;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Container(
            // margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.only(
                top: 0, right: 16.0, bottom: 16.0, left: 16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0xff222831),
            ),
            child: FormBuilderTextField(
              key: _titleFieldKey,
              name: 'title',
              cursorColor: const Color(0x80EEEEEE),
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  color: Color(0xeeEEEEEE),
                ),
                floatingLabelStyle: TextStyle(color: Color(0x90EEEEEE)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0x90EEEEEE)),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE34D61))),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            // margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.only(
                top: 0, right: 16.0, bottom: 16.0, left: 16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0xff222831),
            ),
            child: FormBuilderDateTimePicker(
                key: _timeFieldKey,
                name: 'time',
                format: DateFormat.jm(),
                enabled: true,
                currentDate: datehaha,
                firstDate: datehaha,
                initialDate: datehaha,
                inputType: InputType.time,
                initialValue: DateTime.now(),
                decoration: const InputDecoration(
                    labelText: 'Alarm Time',
                    labelStyle: TextStyle(
                        color: Color(0x90eeeeee),
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal)),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                onChanged: (DateTime? selectedTime) {
                  // Combine selected time with today's date
                  DateTime today = DateTime.now();
                  DateTime combinedDateTime = DateTime(
                    today.year,
                    today.month,
                    today.day,
                    selectedTime!.hour,
                    selectedTime.minute,
                  );
                  datehaha = combinedDateTime;
                }),
          ),
          const SizedBox(height: 10),
          Container(
            // margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.only(
                top: 0, right: 16.0, bottom: 16.0, left: 16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0xff222831),
            ),
            child: FormBuilderDropdown(
              key: _servingFieldKey,
              name: 'serving',
              dropdownColor: const Color(0xff222831),
              initialValue: 1,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              decoration: const InputDecoration(
                labelText: 'Serving Size',
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal),
                floatingLabelStyle: TextStyle(color: Color(0x80EEEEEE)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffEEEEEE)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0x80EEEEEE)),
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              items: const [
                DropdownMenuItem(value: 1, child: Text('1')),
                DropdownMenuItem(value: 2, child: Text('2')),
                DropdownMenuItem(value: 3, child: Text('3')),
                DropdownMenuItem(value: 4, child: Text('4')),
                DropdownMenuItem(value: 5, child: Text('5')),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            // margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.only(
                top: 0, right: 16.0, bottom: 16.0, left: 16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0xff222831),
            ),
            child: FormBuilderCheckboxGroup(
              key: _repeatFieldKey,
              name: 'repeat',
              initialValue: const ['noRepeat'],
              decoration: const InputDecoration(
                labelText: 'Repeat',
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal),
                floatingLabelStyle: TextStyle(color: Color(0x80EEEEEE)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffEEEEEE)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0x80EEEEEE)),
                ),
              ),
              wrapAlignment: WrapAlignment.spaceEvenly,
              checkColor: Colors.white,
              activeColor: const Color(0xffEA2843),
              options: const [
                FormBuilderFieldOption(
                  value: 'Sunday',
                  child: Text('Sunday'),
                ),
                FormBuilderFieldOption(
                  value: 'Monday',
                  child: Text('Monday'),
                ),
                FormBuilderFieldOption(
                  value: 'Tuesday',
                  child: Text('Tuesday'),
                ),
                FormBuilderFieldOption(
                  value: 'Wednesday',
                  child: Text('Wednesday'),
                ),
                FormBuilderFieldOption(
                  value: 'Thursday',
                  child: Text('Thursday'),
                ),
                FormBuilderFieldOption(
                  value: 'Friday',
                  child: Text('Friday'),
                ),
                FormBuilderFieldOption(
                  value: 'Saturday',
                  child: Text('Saturday'),
                ),
              ],
              onChanged: (value) {
                // Handle changes in checkbox group
                if (value!.isNotEmpty && value.contains("noRepeat")) {
                  value.remove("noRepeat");
                } else if (value.isEmpty) {
                  value.add("noRepeat");
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
              // margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.only(
                  top: 0, right: 16.0, bottom: 0.0, left: 16.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xff222831),
              ),
              child: FormBuilderSwitch(
                  title: const Text(
                    "Activate immediately",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  decoration: const InputDecoration(
                      // labelText: 'Title',
                      // labelStyle: TextStyle(
                      //   color: Color(0xeeEEEEEE),
                      // ),
                      // floatingLabelStyle: TextStyle(color: Color(0x90EEEEEE)),
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: Color(0x90EEEEEE)),
                      // ),
                      // focusedBorder: UnderlineInputBorder(
                      //     borderSide: BorderSide(color: Color(0xFFE34D61))),
                      border: InputBorder.none),
                  activeColor: const Color(0xffffffff),
                  activeTrackColor: const Color(0xffDA0037),
                  inactiveTrackColor: const Color(0xff393E46),
                  inactiveThumbColor: const Color(0xffeeeeee),
                  key: _statusFieldKey,
                  name: 'status',
                  initialValue: true,
                  onChanged: _onChanged)),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 60.0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  width: double.infinity,
                  child: MaterialButton(
                    color: const Color(0xffEA2843),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    onPressed: () {
                      // Validate and save the form values
                      _formKey.currentState?.saveAndValidate();
                      debugPrint(_formKey.currentState?.value.toString());

                      // On another side, can access all field values without saving form with instantValues
                      _formKey.currentState?.validate();
                      debugPrint(
                        _formKey.currentState?.instantValue.toString(),
                      );
                      _formKey.currentState?.save();
                      if (_formKey.currentState!.validate()) {
                        final formData = _formKey.currentState?.value;
                        // formData = { 'field1': ..., 'field2': ..., 'field3': ... }
                        // do something with the form data
                        submitFormToFirebase(_formKey.currentState!.value);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                        // print(formData);
                      }
                      // writeToFirebase(_formKey.currentState?.value);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
