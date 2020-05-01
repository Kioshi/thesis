import 'package:flutter/material.dart';
import 'package:thesis/models/Booking.dart';
import 'package:thesis/widgets/BookingStateWidget.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';

class DEBookingScreen extends StatefulWidget {
  DEBookingScreen(this.booking, {Key key}) : super(key: key);

  Booking booking;

  @override
  _DEBookingScreenState createState() => _DEBookingScreenState(booking);
}

class BoolWrapper {
  bool value;
  BoolWrapper(this.value);
}

class _DEBookingScreenState extends State<DEBookingScreen> {
  Booking booking;

  _DEBookingScreenState(this.booking);

  BoolWrapper showPopUp = BoolWrapper(false);

  @override
  Widget build(BuildContext context) {
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
                child: ListTile(
                    title: Text('Restaurant'),
                    subtitle: Text(booking.restaurantName)),
              ),
              Card(
                child: ListTile(
                    title: Text('Date and time'),
                    subtitle: Text(booking.date.toString())),
              ),
              Card(
                child: ListTile(
                    title: Text('Reservation is under name'),
                    subtitle: Text(booking.name)),
              ),
              Card(
                child: ListTile(
                    title: Text('Reservation is under number'),
                    subtitle: Text(booking.phoneNr)),
              ),
              Card(
                  child: ListTile(
                      title: Text('State'),
                      subtitle: BookingStateWidget(booking.state))),
            ],
          ),
        ));
  }
}
