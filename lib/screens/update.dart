import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import 'HomePage.dart';

class AlarmEditor extends StatefulWidget {
  final String alarmId;

  const AlarmEditor({Key? key, required this.alarmId}) : super(key: key);

  @override
  _AlarmEditorState createState() => _AlarmEditorState();
}

class _AlarmEditorState extends State<AlarmEditor> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    loadAlarmData();
  }

  Future<void> loadAlarmData() async {
    try {
      DocumentSnapshot<Object?> alarmSnapshot = await FirebaseFirestore.instance
          .collection('alarms')
          .doc(widget.alarmId)
          .get();

      Map<String, dynamic> alarmData =
          alarmSnapshot.data() as Map<String, dynamic>;
      titleController.text = alarmData['title'] ?? '';

      // Convert DateTime to Timestamp
      DateTime dt = (alarmData['time'] as Timestamp).toDate();

      DateTime timeDateTime = alarmData['time'];
      // Timestamp timeTimestamp = Timestamp.fromDate(timeDateTime);

      // DateTime timeDateTimeConverted = (alarmData['time'] as DateTime);
      print(alarmData['time']);

      // Set the loaded data to the form fields
      _formKey.currentState?.patchValue({
        'title': titleController.text,
        'time': dt,
        'serving': alarmData['serving'],
        'repeat': alarmData['repeat'],
        // 'status': alarmData['status'],
        // Add other form fields based on your requirements
      });
    } catch (e) {
      print('Error loading alarm data: $e');
    }
  }

  void deleteAlarm(String alarmId) async {
    try {
      await FirebaseFirestore.instance
          .collection('alarms')
          .doc(alarmId)
          .delete();
      print('Alarm deleted successfully!');
    } catch (e) {
      print('Error deleting alarm: $e');
    }
  }

  Future<void> updateAlarm() async {
    try {
      if (_formKey.currentState?.saveAndValidate() ?? false) {
        // Get the form values
        Map<String, dynamic> formData = _formKey.currentState?.value ?? {};

        // Update alarm data in Firestore
        await FirebaseFirestore.instance
            .collection('alarms')
            .doc(widget.alarmId)
            .update(formData);

        print('Alarm updated successfully!');
      }
    } catch (e) {
      print('Error updating alarm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Schedule',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
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
                  // key: _titleFieldKey,
                  controller: titleController,
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
              const SizedBox(height: 16),
              Container(
                // margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.only(
                    top: 0, right: 16.0, bottom: 16.0, left: 16.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color(0xff222831),
                ),
                child: FormBuilderDateTimePicker(
                  // key: _timeFieldKey,
                  name: 'time',
                  format: DateFormat.jm(),
                  enabled: true,
                  // firstDate: DateTime.now(),
                  // initialDate: DateTime.now(),
                  inputType: InputType.time,
                  // initialValue: DateTime.now(),
                  initialValue:
                      _formKey.currentState?.value['time'] ?? DateTime.now(),

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
                ),
              ),
              const SizedBox(height: 16),
              Container(
                // margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.only(
                    top: 0, right: 16.0, bottom: 16.0, left: 16.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color(0xff222831),
                ),
                child: FormBuilderDropdown(
                  // key: _servingFieldKey,
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
              const SizedBox(height: 16),
              Container(
                // margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.only(
                    top: 0, right: 16.0, bottom: 16.0, left: 16.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color(0xff222831),
                ),
                child: FormBuilderCheckboxGroup(
                  // key: _repeatFieldKey,
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
                        value: 'Sunday', child: Text('Sunday')),
                    FormBuilderFieldOption(
                        value: 'Monday', child: Text('Monday')),
                    FormBuilderFieldOption(
                        value: 'Tuesday', child: Text('Tuesday')),
                    FormBuilderFieldOption(
                        value: 'Wednesday', child: Text('Wednesday')),
                    FormBuilderFieldOption(
                        value: 'Thursday', child: Text('Thursday')),
                    FormBuilderFieldOption(
                        value: 'Friday', child: Text('Friday')),
                    FormBuilderFieldOption(
                        value: 'Saturday', child: Text('Saturday')),
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
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 60.0,
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        width: double.infinity,
                        child: Row(
                          children: [
                            ButtonTheme(
                                minWidth: 200.0,
                                height: 100.0,
                                child: MaterialButton(
                                  color: const Color(0xffEA2843),
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.42,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  onPressed: () {
                                    deleteAlarm(widget.alarmId);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                    );
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 24.0,
                                    ),
                                  ),
                                )),
                            const Spacer(),
                            ButtonTheme(
                                minWidth: 200.0,
                                height: 100.0,
                                child: MaterialButton(
                                  color: const Color(0xff2860EA),
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.42,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  onPressed: () {
                                    updateAlarm();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                    );
                                  },
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 24.0,
                                    ),
                                  ),
                                )),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
