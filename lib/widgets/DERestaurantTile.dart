import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thesis/models/Availability.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/screens/DERestaurantScreen.dart';

// Restaurant tile showing available information and loading availability state asynchronously
class DERestaurantTile extends StatelessWidget {
  final _dineEasyRepository = DineEasyRepository();
  final Restaurant _restaurant;
  final DateTime _dayAndTime;
  final int _nrOfPeople;

  DERestaurantTile(this._restaurant, this._dayAndTime, this._nrOfPeople);

  @override
  Widget build(BuildContext context) {
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
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(
        _restaurant.address,
        style: Theme.of(context).textTheme.subtitle,
      ),
      trailing: FutureBuilder(
        future: _dineEasyRepository.getRestaurantAvailability(restaurant: _restaurant, dayAndTime: _dayAndTime, nrOfPeople: _nrOfPeople),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Checking availability...', style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600));
          }

          AvailabilityState state = snapshot.data as AvailabilityState;

          return Text('${state.toString().substring(18)}', style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600));
        },
      ),
    );
  }
}
