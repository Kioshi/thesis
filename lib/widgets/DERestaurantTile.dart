import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thesis/models/Availability.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/screens/DERestaurantScreen.dart';

class DERestaurantTile extends StatelessWidget {
  final _dineEasyRepository = DineEasyRepository();
  Restaurant _restaurant;
  DateTime _dayAndTime;

  DERestaurantTile(this._restaurant, this._dayAndTime);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          DERestaurantScreen.routeName,
          arguments: _restaurant,
        );
      },
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 56,
                maxHeight: 56,
              ),
              child: SvgPicture.asset("assets/dinner.svg", semanticsLabel: 'Dinner plate Logo'))
        ],
      ),
      title: Text(
        _restaurant.name,
        style: TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        _restaurant.address,
        style: TextStyle(color: Colors.black87),
      ),
      trailing: FutureBuilder(
        future: _dineEasyRepository.getRestaurantAvailability(restaurant: _restaurant, dayAndTime: _dayAndTime),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Cheking availability...', style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600));
          }

          AvailabilityState state = snapshot.data;

          return Text('${state.toString().substring(18)}', style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600));
        },
      ),
    );
  }
}