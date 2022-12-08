import 'package:flutter/material.dart';
import 'package:value_listening/csv_converter.dart';
import 'package:value_listening/second_screen.dart';

import 'first_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      // home: const FirstScreen(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) =>  FirstScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) =>  SecondScreen(),
        '/third': (context) =>  CsvConverter(),
      },
    );
  }
}
