import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:thesis/models/Availability.dart';
import 'package:thesis/models/Filters.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/screens/DERestaurantScreen.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';
import 'package:thesis/widgets/ToggableText.dart';

class DERestaurantsScreen extends StatefulWidget {
  static const routeName = '/restaurants';

  @override
  _DERestaurantsScreenState createState() => _DERestaurantsScreenState();
}

class _DERestaurantsScreenState extends State<DERestaurantsScreen> {
  final _dineEasyRepository = DineEasyRepository();

  bool _showFilters = false;

  String _location = null;
  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  bool _areSearchCriteriaDirty = false;

  //String _search = null;
  //final TextEditingController _searchController = new TextEditingController();
  List<bool> _priceRangeEnabled;
  Future<List<Restaurant>> _restaurantsFuture = null;
  Future<Filters> _filtersFuture;
  Filters _filters = null;

  _DERestaurantsScreenState() {
    TimeOfDay now = TimeOfDay.now();
    int hours = now.hour + 1;
    int minutes = now.minute + (10 - now.minute % 10);
    if (minutes >= 60) {
      hours++;
      minutes -= 60;
    }
    _selectedTime = TimeOfDay(hour: hours, minute: minutes);
    DateTime today = DateTime.now();
    _selectedDate = DateTime(today.year, today.month, today.day);
    _filtersFuture = _dineEasyRepository.getFilters();
  }

  FutureBuilder buildRestaurantList(BuildContext context) {
    return FutureBuilder(
      future: _restaurantsFuture,
      builder: (context, snapshot) {
        if (_restaurantsFuture == null) {
          return Center(child: Text("Please select location."));
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
            ),
          );
        }
        final List<Restaurant> restaurants = snapshot.data;
        return RefreshIndicator(
            color: Theme.of(context).accentColor,
            onRefresh: () {
              setState(() {
                _restaurantsFuture =
                    _dineEasyRepository.getRestaurants(_location, _filters);
              });
              return _restaurantsFuture;
            },
            child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (BuildContext context, int index) {
                  final restaurant = restaurants[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DERestaurantScreen.routeName,
                        arguments: restaurant,
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
                            child: SvgPicture.asset("assets/dinner.svg",
                                semanticsLabel: 'Dinner plate Logo'))
                      ],
                    ),
                    title: Text(
                      restaurant.name,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      restaurant.address,
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: FutureBuilder(
                      future: _dineEasyRepository.getRestaurantAvailability(
                          restaurant: restaurant,
                          dateTime: _selectedDate,
                          timeOfDay: _selectedTime),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Cheking availability...',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w600));
                        }

                        AvailabilityState state = snapshot.data;

                        return Text('${state.toString().substring(18)}',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w600));
                      },
                    ),
                  );
                }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _showFilters == true
            ? null
            : FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () async {
                  setState(() => _showFilters = true);
                }),
        bottomNavigationBar: DEBottomNavigationBar(1),
        body: SafeArea(
          child: Container(
              child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                          height: 200.0, child: buildRestaurantList(context))),
                ],
              ),
              Positioned(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: IgnorePointer(
                          ignoring: !_showFilters,
                          child: AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: _showFilters ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                      color: Colors.green,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FutureBuilder(
                                            future: _filtersFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                _filters = snapshot.data;
                                                _priceRangeEnabled =
                                                    List<bool>.filled(
                                                        _filters.prices.length,
                                                        true);
                                                List<String> locations =
                                                    _filters.locations;
                                                return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Row(children: <Widget>[
                                                        FlatButton(
                                                          child: Icon(Icons
                                                              .location_on),
                                                          onPressed: () async {
                                                            setState(() {
                                                              _showFilters =
                                                                  false;
                                                            });
                                                          },
                                                        ),
                                                        Expanded(
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                                    child:
                                                                        DropdownButton(
                                                          value: _location,
                                                          //isExpanded: true,
                                                          items: [
                                                            "Odense",
                                                            "Plzen"
                                                          ]
                                                              .map((e) =>
                                                                  DropdownMenuItem(
                                                                    value: e,
                                                                    child: Align(
                                                                        alignment: FractionalOffset.center,
                                                                        child: Text(
                                                                          e,
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        )),
                                                                  ))
                                                              .toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _location = value;
                                                              _areSearchCriteriaDirty =
                                                                  true;
                                                            });
                                                          },
                                                          hint: Align(
                                                              alignment:
                                                                  FractionalOffset
                                                                      .center,
                                                              child: Text(
                                                                  "Select city")),
                                                        )))
                                                      ]),
                                                      Divider(
                                                          color: Colors.black),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: <Widget>[
                                                            RaisedButton(
                                                              child: Text(DateFormat(
                                                                      "yyyy-MM-dd")
                                                                  .format(
                                                                      _selectedDate)),
                                                              onPressed: () {
                                                                showDatePicker(
                                                                        context:
                                                                            context,
                                                                        initialDate:
                                                                            _selectedDate,
                                                                        firstDate: (DateTime.now().subtract(Duration(
                                                                            days:
                                                                                1))),
                                                                        lastDate: (DateTime.now().add(Duration(
                                                                            days:
                                                                                14))))
                                                                    .then(
                                                                        (date) {
                                                                  if (date !=
                                                                          null &&
                                                                      date !=
                                                                          _selectedDate) {
                                                                    setState(
                                                                        () {
                                                                      _selectedDate =
                                                                          date;
                                                                      _areSearchCriteriaDirty =
                                                                          true;
                                                                    });
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            RaisedButton(
                                                              child: Text(
                                                                  "${_selectedTime}"),
                                                              onPressed: () {
                                                                showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      _selectedTime,
                                                                ).then((time) {
                                                                  if (time !=
                                                                          null &&
                                                                      time !=
                                                                          _selectedTime) {
                                                                    setState(
                                                                        () {
                                                                      _selectedTime =
                                                                          time;
                                                                      _areSearchCriteriaDirty =
                                                                          true;
                                                                    });
                                                                  }
                                                                });
                                                              },
                                                            )
                                                          ]),
                                                      Divider(
                                                          color: Colors.black),
                                                      Wrap(
                                                          children: _filters
                                                              .tags
                                                              .map((item) =>
                                                                  ToggleText(
                                                                      item,
                                                                      callback:
                                                                          () =>
                                                                              {}))
                                                              .toList()),
                                                      Divider(
                                                          color: Colors.black),
                                                      Wrap(
                                                          children: _filters
                                                              .foodCategories
                                                              .map((item) =>
                                                                  ToggleText(
                                                                      item,
                                                                      callback:
                                                                          () =>
                                                                              {}))
                                                              .toList()),
                                                      Divider(
                                                          color: Colors.black),
                                                      Wrap(
                                                          children: _filters
                                                              .prices
                                                              .map((item) =>
                                                                  ToggleText(
                                                                      item,
                                                                      callback:
                                                                          () =>
                                                                              {}))
                                                              .toList())
                                                    ]);
                                              }
                                              return Center(
                                                  child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              Theme.of(context)
                                                                  .accentColor),
                                                    ),
                                                  ),
                                                  Text("Loading locations")
                                                ],
                                              ));
                                            },
                                          ),
                                          FlatButton(
                                              child: Text(
                                                  "Search for restaurants"),
                                              onPressed: () async {
                                                setState(() {
                                                  _showFilters = false;
                                                  if (_areSearchCriteriaDirty) {
                                                    _restaurantsFuture =
                                                        _dineEasyRepository
                                                            .getRestaurants(
                                                                _location,
                                                                _filters);
                                                    _areSearchCriteriaDirty =
                                                        false;
                                                  }
                                                });
                                              })
                                        ],
                                      )))))))
            ],
          )),
        ));
  }
}
