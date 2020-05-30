import 'package:flutter/material.dart';
import 'package:thesis/screens/DEBookingScreen.dart';
import 'package:thesis/screens/DEBookingsScreen.dart';
import 'package:thesis/screens/DERestaurantScreen.dart';
import 'package:thesis/screens/DERestaurantsScreen.dart';
import 'package:thesis/screens/DEUserScreen.dart';

class DEApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dine Easy thesis prototype',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.teal,
          brightness: Brightness.dark),
      // Home Screen
      home: DERestaurantsScreen(),
      // List of routes for invoking by names
      routes: <String, WidgetBuilder>{
        DEBookingsScreen.routeName: (BuildContext context) => DEBookingsScreen(),
        DEBookingScreen.routeName: (BuildContext context) => DEBookingScreen(),
        DERestaurantsScreen.routeName: (BuildContext context) => DERestaurantsScreen(),
        DERestaurantScreen.routeName: (BuildContext context) => DERestaurantScreen(),
        DEUserScreen.routeName: (BuildContext context) => DEUserScreen(),
      },
    );
  }
}
