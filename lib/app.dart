import 'package:flutter/material.dart';
import 'package:pakain_aso/screens/homePage.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF141414),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xffeeeeee)),
          bodyMedium: TextStyle(color: Color(0xffeeeeee)),
          titleLarge: TextStyle(color: Color(0xffeeeeee)),
        ),
        fontFamily: "Poppins",
      ),
      home: const HomePage(),
    );
  }
}


