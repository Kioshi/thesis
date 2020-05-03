import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thesis/models/Filters.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/models/ToggableItem.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';
import 'package:thesis/widgets/DEDropDownButton.dart';
import 'package:thesis/widgets/DERestaurantTile.dart';
import 'package:thesis/widgets/ToggableText.dart';

class DERestaurantsScreen extends StatefulWidget {
  static const routeName = '/restaurants';

  @override
  _DERestaurantsScreenState createState() => _DERestaurantsScreenState();
}

class _DERestaurantsScreenState extends State<DERestaurantsScreen> {
  final _dineEasyRepository = DineEasyRepository();

  bool _showFilters = false;
  bool _areSearchCriteriaDirty = false;

  String _location;
  DateTime _dayAndTime;

  Future<List<Restaurant>> _restaurantsFuture;
  Future<Filters> _filtersFuture;
  Filters _filters;

  _DERestaurantsScreenState() {
    TimeOfDay now = TimeOfDay.now();
    int hours = now.hour + 1;
    int minutes = now.minute + (10 - now.minute % 10);
    if (minutes >= 60) {
      hours++;
      minutes -= 60;
    }
    DateTime today = DateTime.now();
    _dayAndTime = DateTime(today.year, today.month, today.day, hours, minutes);
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
            onRefresh: () async {
              _restaurantsFuture = _dineEasyRepository.getRestaurants(_location, _filters);
              return await _restaurantsFuture;
            },
            child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (BuildContext context, int index) {
                  final restaurant = restaurants[index];
                  return DERestaurantTile(restaurant, _dayAndTime);
                }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: buildFloatingButton(),
        bottomNavigationBar: DEBottomNavigationBar(1),
        body: SafeArea(
          child: Container(
              child: Stack(
            children: <Widget>[buildRestaurantList(context), buildSearchView(context)],
          )),
        ));
  }

  Widget buildSearchButton() {
    return FlatButton(
        child: Text("Search for restaurants"),
        onPressed: () async {
          setState(() {
            _showFilters = false;
            if (_areSearchCriteriaDirty) {
              _restaurantsFuture = _dineEasyRepository.getRestaurants(_location, _filters);
              _areSearchCriteriaDirty = false;
            }
          });
        });
  }

  Widget buildFloatingButton() {
    return _showFilters == true
        ? null
        : FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () async {
              setState(() => _showFilters = true);
            });
  }

  Widget buildDateAndTimeSelectors() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      RaisedButton(
        child: Text(DateFormat("yyyy-MM-dd").format(_dayAndTime)),
        onPressed: () {
          showDatePicker(
                  context: context,
                  initialDate: _dayAndTime,
                  firstDate: (DateTime.now().subtract(Duration(days: 1))),
                  lastDate: (DateTime.now().add(Duration(days: 14))))
              .then((date) {
            if (date != null && date != _dayAndTime) {
              setState(() {
                _dayAndTime = date;
                _areSearchCriteriaDirty = true;
              });
            }
          });
        },
      ),
      RaisedButton(
        child: Text("${_dayAndTime.hour} : ${_dayAndTime.minute}"),
        onPressed: () {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_dayAndTime),
          ).then((time) {
            if (time != null && time != TimeOfDay.fromDateTime(_dayAndTime)) {
              setState(() {
                _dayAndTime = DateTime(_dayAndTime.year, _dayAndTime.month, _dayAndTime.day, time.hour, time.minute);
                _areSearchCriteriaDirty = true;
              });
            }
          });
        },
      )
    ]);
  }

  Widget buildSearchView(BuildContext context) {
    return Align(
        alignment: FractionalOffset.bottomCenter,
        child: IgnorePointer(
            ignoring: !_showFilters,
            child: AnimatedOpacity(
                opacity: _showFilters ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Card(
                    color: Colors.blueGrey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FutureBuilder(
                          future: _filtersFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _filters = snapshot.data;
                              List<String> locations = _filters.locations;
                              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                buildLocationSelector(locations),
                                Divider(color: Colors.black),
                                buildDateAndTimeSelectors(),
                                Divider(color: Colors.black),
                                buildWrappedFilters(_filters.prices),
                                Divider(color: Colors.black),
                                buildWrappedFilters(_filters.foodCategories),
                                Divider(color: Colors.black),
                                buildWrappedFilters(_filters.tags),
                              ]);
                            }
                            return Center(
                                child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
                                  ),
                                ),
                                Text("Loading locations")
                              ],
                            ));
                          },
                        ),
                        buildSearchButton()
                      ],
                    )))));
  }

  Widget buildWrappedFilters(List<TogglableItem> data) {
    return Wrap(children: data.map((item) => ToggleText(item, callback: () => {})).toList());
  }

  Widget buildLocationSelector(List<String> locations) {
    return Row(children: <Widget>[
      FlatButton(
        child: Icon(Icons.location_on),
        onPressed: () async {
          //TODO not implemented yet
        },
      ),
      Expanded(
          child: DEDropDownButton("Select place", _location, locations, <String>(String l) {
        return l.toString();
      }, hint: "Select place"))
    ]);
  }
}
