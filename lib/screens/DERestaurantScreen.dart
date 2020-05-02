import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thesis/models/Offer.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';
import 'package:thesis/widgets/ReservePopUp.dart';

List<BoxShadow> customShadow = [
  BoxShadow(color: Colors.white.withOpacity(0.5), spreadRadius: -5, offset: Offset(-5, -5), blurRadius: 10),
  BoxShadow(color: Colors.green[900].withOpacity(0.2), spreadRadius: 2, offset: Offset(5, 5), blurRadius: 5),
];

class DERestaurantScreen extends StatelessWidget {
  static const routeName = '/restaurant';

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = ModalRoute.of(context).settings.arguments as Restaurant;
    final _dineEasyRepository = DineEasyRepository();
    return Scaffold(
        appBar: AppBar(
          title: Text(restaurant.name),
        ),
        bottomNavigationBar: DEBottomNavigationBar(1),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 200,
                    maxHeight: 200,
                  ),
                  child: SvgPicture.asset("assets/dinner.svg", semanticsLabel: 'Dinner plate Logo')),
              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(restaurant.address, style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(
                  height: 130.0,
                  child: FutureBuilder(
                      future: _dineEasyRepository.getOffers(restaurant),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Offer> offers = snapshot.data;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: offers.length,
                            itemBuilder: (context, i) {
                              Offer offer = offers[i];
                              return GestureDetector(
                                onTap: () => _showDialog(context, restaurant),
                                child: Container(
                                    width: MediaQuery.of(context).size.width / 3.0,
                                    height: 20,
                                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                    decoration: BoxDecoration(color: Colors.white, boxShadow: customShadow, borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[buildDaysWidget(offer.days), buildDiscountWidget(offer.discount), buildAvailableWidget(offer.days)],
                                    )),
                              );
                            },
                          );
                        }
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
                        );
                      })),
              Text(
                'Description',
                style: TextStyle(fontSize: 18),
              ),
              Card(
                child: Padding(padding: EdgeInsets.all(20), child: Text(restaurant.description)),
              )
            ],
          ),
        ));
  }

  void _showDialog(BuildContext context, Restaurant restaurant) {
    if (restaurant.availableTimes == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No time available for booking"),
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReservePupUp(restaurant);
      },
    );
  }

  buildDaysWidget(int days) {
    List<String> names = ["Mo,", "Tue,", "We,", "Thu,", "Fri,", "Sa,", "Su,"];
    if (days == 1 + 2 + 4 + 8 + 16 + 32 + 64) {
      return Text("Everyday");
    }
    String text = "";
    for (int i = 0; i < 7; i++) {
      if ((days & (1 << i)) > 0) {
        text += names[i];
      }
    }
    return Text(text.substring(0, text.length - 1));
  }

  buildDiscountWidget(int discount) {
    if (discount == 0) {
      return Text("Regular booking");
    }

    return Text("Discount $discount%");
  }

  buildAvailableWidget(int days) {
    if ((days & (1 << DateTime.now().weekday - 1)) > 0) {
      return Text("Available", style: TextStyle(color: Colors.lightGreen));
    }
    return Text("Unavailable", style: TextStyle(color: Colors.red));
  }
}
