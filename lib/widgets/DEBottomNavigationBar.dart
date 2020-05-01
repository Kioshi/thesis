import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DEBottomNavigationBar extends StatelessWidget {
  int _currentIndex;

  DEBottomNavigationBar(this._currentIndex);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == _currentIndex) return;
        print("New page $index");
        switch (index) {
          case 0:
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DEBookingsScreen()));*/
            break;
          case 1:
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DERestaurantsScreen()));*/
            break;
          case 2:
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DEUser()));*/
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('Bookings'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          title: Text('Restaurants'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text('Profile'),
        ),
      ],
    );
  }
}
