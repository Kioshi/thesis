import 'package:flutter/material.dart';
import 'package:thesis/models/Booking.dart';
import 'package:thesis/widgets/BookingStateWidget.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';

// Simple screen to show informations about booking
class DEBookingScreen extends StatelessWidget {
  static const routeName = '/booking';

  @override
  Widget build(BuildContext context) {
    // Retrieve booking passed as argument
    Booking booking = ModalRoute.of(context).settings.arguments as Booking;

    return Scaffold(
        appBar: AppBar(
          title: Text("Booking info"),
        ),
        bottomNavigationBar: DEBottomNavigationBar(0, backOnSameIndex: true),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                child: ListTile(title: Text('Restaurant'), subtitle: Text(booking.restaurantName)),
              ),
              Card(
                child: ListTile(title: Text('Date and time'), subtitle: Text(booking.date.toString())),
              ),
              Card(
                child: ListTile(title: Text('Reservation is under name'), subtitle: Text(booking.name)),
              ),
              Card(
                child: ListTile(title: Text('Reservation is under number'), subtitle: Text(booking.phoneNr)),
              ),
              Card(child: ListTile(title: Text('State'), subtitle: BookingStateWidget(booking.state))),
            ],
          ),
        ));
  }
}
