import 'package:flutter/material.dart';

import '../components/switch.dart';

Widget alarmWidget(data) => GestureDetector(
    onTap: () {
      print("Container clicked");
      print(data);
    },
    child: Container(
      margin: const EdgeInsets.only(top: 4, right: 16, bottom: 4, left: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xff222831),
      ),
      child: const Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Text(
                  'Alarm Title Sample 1',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                Text(
                  "12:00 PM",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
                ),
                Text(
                  "Servings: 2",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
              ],
            ),
          ),
          /*3*/
          SwitchExample()
        ],
      ),
    ));
