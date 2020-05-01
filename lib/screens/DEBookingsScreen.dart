import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:localstorage/localstorage.dart';
import 'package:thesis/models/Booking.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';

class DEBookingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DEBookingsState();
  }
}

class DEBookingsState extends State<StatefulWidget> {
  final _dineEasyRepository = DineEasyRepository();
  final LocalStorage storage = new LocalStorage('bookings.json');
  List<Booking> data;
  Future<List<Booking>> bookingsFuture;

  @override
  void initState() {
    bookingsFuture = _dineEasyRepository.getBookings();
  }

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
              data = (storage.getItem('bookings') as List)
                  .map((i) => Booking.fromJson(i))
                  .toList();
              return builBookingsList();
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }

  Widget builBookingsList() {
    return RefreshIndicator(
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
              trailing: Text(booking.state.toString().substring(13)),
              title: Text(booking.name),
              subtitle: Text(booking.date.toString()),
              leading: Text(booking.id.toString()),
              onTap: () {
                /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DEBookingScreen(booking)));*/
              },
            );
          },
          itemCount: data.length,
          separatorBuilder: (context, i) => Divider(),
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        ));
  }

  Widget retrieveAndBuild() {
    return FutureBuilder(
      future: bookingsFuture,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData == true) {
          data = snapshot.data;
          storage.setItem("bookings", data);
        }
        return Stack(fit: StackFit.expand, children: [
          if (!snapshot.hasData || snapshot.hasError)
            Positioned(
              height: 24.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: snapshot.hasError ? Color(0xFFEE4400) : Colors.orange,
                child: Center(
                  child:
                      Text(snapshot.hasError ? "Error occured" : "Loading..."),
                ),
              ),
            ),
          if (data != null)
            builBookingsList()
          else
            Center(child: const CircularProgressIndicator())
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final repository = context.read<Repository<Booking>>();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'There are no bottons to push :)',
              ),
              new Text(
                'Just turn off your internet.',
              ),
            ],
          ),
        ));
  }
}