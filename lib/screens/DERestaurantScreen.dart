import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';
import 'package:thesis/widgets/ReservePopUp.dart';

List<BoxShadow> customShadow = [
  BoxShadow(
      color: Colors.white.withOpacity(0.5),
      spreadRadius: -5,
      offset: Offset(-5, -5),
      blurRadius: 10),
  BoxShadow(
      color: Colors.green[900].withOpacity(0.2),
      spreadRadius: 2,
      offset: Offset(5, 5),
      blurRadius: 5),
];

class DERestaurantScreen extends StatelessWidget {
  static const routeName = '/restaurant';

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant =
        ModalRoute.of(context).settings.arguments as Restaurant;
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
                    //minWidth: 44,
                    minHeight: 200,
                    //maxWidth: 56,
                    maxHeight: 200,
                  ),
                  child: SvgPicture.asset("assets/dinner.svg",
                      semanticsLabel: 'Dinner plate Logo')),
              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(restaurant.address,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(
                  height: 130.0,
                  child: FutureBuilder(
                      //future: _dineEasyRepository.restaurantDetails(restaurant, filters),
                      builder: (context, snapshot) {
                    //if (snapshot.connectionState == ConnectionState.done)
                    {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 4, //restaurant.offers.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () => _showDialog(context, restaurant),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 3.0,
                                height: 20,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: customShadow,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(i == 0 ? "Every day" : "Mo, Tue, Wen"),
                                    Text(i == 0
                                        ? "Regular booking"
                                        : "Discount: 50%"),
                                    Text("Available",
                                        style:
                                            TextStyle(color: Colors.lightGreen))
                                  ],
                                )),
                          );
                        },
                      );
                    }
                    return CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    );
                  })),
              FutureBuilder(
                  //future: _dineEasyRepository.restaurantDetails(restaurant, filters),
                  builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(restaurant.description);
                }
                return Center(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).accentColor),
                        )));
              }),
              Text(
                'Demo Headline 2',
                style: TextStyle(fontSize: 18),
              ),
              Card(
                child: ListTile(
                    title: Text('Motivation $int'),
                    subtitle: Text('this is a description of the motivation')),
              ),
              Card(
                child: ListTile(
                    title: Text('Motivation $int'),
                    subtitle: Text('this is a description of the motivation')),
              ),
              Card(
                child: ListTile(
                    title: Text('Motivation $int'),
                    subtitle: Text('this is a description of the motivation')),
              ),
              Card(
                child: ListTile(
                    title: Text('Motivation $int'),
                    subtitle: Text('this is a description of the motivation')),
              ),
              Card(
                child: ListTile(
                    title: Text('Motivation $int'),
                    subtitle: Text('this is a description of the motivation')),
              ),
            ],
          ),
        ));
  }

  void _showDialog(BuildContext context, Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReservePupUp(restaurant);
      },
    );
  }
}
