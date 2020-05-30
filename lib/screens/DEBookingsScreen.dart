import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:localstorage/localstorage.dart';
import 'package:thesis/models/Booking.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/widgets/BookingStateWidget.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';

import 'DEBookingScreen.dart';

// List of bookings screen
class DEBookingsScreen extends StatefulWidget {
  static const routeName = '/bookings';

  @override
  State<StatefulWidget> createState() {
    return DEBookingsState();
  }
}

class DEBookingsState extends State<StatefulWidget> {
  final _dineEasyRepository = DineEasyRepository();
  final LocalStorage storage = LocalStorage('bookings.json');
  List<Booking> data;
  Future<List<Booking>> bookingsFuture;

  @override
  void initState() {
    super.initState();
    bookingsFuture = _dineEasyRepository.getBookings();
  }

  // Build function for retrieving data from local Storage
  Widget buildFromLocalData(bool isConnected) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (!isConnected)
          Positioned(
            height: 24.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: Color(0xFFEE4400),
              child: Center(
                child: Text("OFFLINE"),
              ),
            ),
          ),
        FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == true) {
              data = (storage.getItem('bookings') as List).map((dynamic i) => Booking.fromJson(i as Map<String, dynamic>)).toList();
              return builBookingsList();
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }

  // Build function for building list of bookings from already retrieve data
  Widget builBookingsList() {
    return RefreshIndicator(
        // Pull to refresh data from remote storage
        onRefresh: () async {
          data = await _dineEasyRepository.getBookings();
          setState(() {
            //print("refresh ${bookingsFuture == _dineEasyRepository.getBookings()}");
            //bookingsFuture = _dineEasyRepository.getBookings();
          });
        },
        child: ListView.separated(
          itemBuilder: (context, i) {
            final booking = data[i];
            return ListTile(
              leading: Text(booking.id.toString()),
              title: Text(booking.restaurantName),
              subtitle: Text(booking.date.toString()),
              trailing: BookingStateWidget(booking.state),
              onTap: () {
                // Invoke Booking screen
                Navigator.pushNamed(
                  context,
                  DEBookingScreen.routeName,
                  arguments: booking,
                );
              },
            );
          },
          itemCount: data.length,
          separatorBuilder: (context, i) => Divider(),
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        ));
  }

  // Build function for retrieving and data from remote storage
  Widget retrieveAndBuild() {
    return FutureBuilder(
      future: bookingsFuture,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData == true) {
          data = snapshot.data as List<Booking>;
          storage.setItem("bookings", data);
        }
        return Stack(fit: StackFit.expand, children: [
          if (!snapshot.hasData || snapshot.hasError)
            Positioned(
              height: 24.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: snapshot.hasError ? Theme.of(context).errorColor : Theme.of(context).primaryColor,
                child: Center(
                  child: Text(snapshot.hasError ? "Error occured" : "Loading..."),
                ),
              ),
            ),
          if (data != null) builBookingsList() else Center(child: const CircularProgressIndicator())
        ]);
      },
    );
  }

  // Default screen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      bottomNavigationBar: DEBottomNavigationBar(0),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool isConnected = connectivity != ConnectivityResult.none;
          if (!isConnected) {
            return buildFromLocalData(isConnected);
          } else {
            return retrieveAndBuild();
          }
        },
        child: Text('Initializing...'),
      ),
    );
  }
}
