import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:thesis/models/Filters.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/models/ToggableItem.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/widgets/DEBottomNavigationBar.dart';
import 'package:thesis/widgets/DEDropDownButton.dart';
import 'package:thesis/widgets/DERestaurantTile.dart';
import 'package:thesis/widgets/ToggableText.dart';

// Screen with list of restaurants
class DERestaurantsScreen extends StatefulWidget {
  static const routeName = '/restaurants';

  @override
  _DERestaurantsScreenState createState() => _DERestaurantsScreenState();
}

class _DERestaurantsScreenState extends State<DERestaurantsScreen> {
  final _dineEasyRepository = DineEasyRepository();

  // Indication if search filter should be shown (default yes, for initial search)
  bool _showFilters = true;
  // Indication if search criteria changed and we should reload data
  bool _areSearchCriteriaDirty = true;

  // Selected location
  String _location;
  // Selected day and time
  DateTime _dayAndTime;

  // Future promise of list of restaurant so we can refresh it when requirements change
  Future<List<Restaurant>> _restaurantsFuture;
  // Future promise of filters, defined here so we can lead them when initiating rather than when opening filters
  Future<Filters> _filtersFuture;

  // List of filter, later retrieved from future for simplier use
  Filters _filters;

  // Controller for number of people widget
  TextEditingController _nrOfPeopleController;

  _DERestaurantsScreenState() {
    // create default time 1 hour from now rounded to 10 minutes
    TimeOfDay now = TimeOfDay.now();
    int hours = now.hour + 1;
    int minutes = now.minute + (10 - now.minute % 10);
    if (minutes >= 60) {
      hours++;
      minutes -= 60;
    }
    DateTime today = DateTime.now();
    _dayAndTime = DateTime(today.year, today.month, today.day, hours, minutes);
    // Initiate retrieving of filters
    _filtersFuture = _dineEasyRepository.getFilters();
    // Default value of people
    _nrOfPeopleController = TextEditingController(text: '2');
  }

  // Build restaurant list
  FutureBuilder<List<Restaurant>> buildRestaurantList(BuildContext context) {
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
                  return DERestaurantTile(restaurant, _dayAndTime, int.parse(_nrOfPeopleController.text));
                }));
      },
    );
  }

  // Build application layout
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          floatingActionButton: buildFloatingButton(),
          bottomNavigationBar: DEBottomNavigationBar(1),
          body: SafeArea(
            child: Container(
                child: Stack(
              children: <Widget>[buildRestaurantList(context), buildSearchView(context)],
            )),
          )),
      onWillPop: () async {
        if (_showFilters == true) {
          setState(() {
            _showFilters = false;
          });
          return false;
        }
        return true;
      },
    );
  }

  // Build search button that will initiate refresh of restaurants if necessary
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

  // Build Floating button that hides when options menu is shown
  Widget buildFloatingButton() {
    return _showFilters == true
        ? null
        : FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () async {
              setState(() => _showFilters = true);
            });
  }

  // Build date, time and number of people selectors row
  Widget buildDateAndTimeSelectors() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      // Date selector
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
                _dayAndTime = DateTime(date.year, date.month, date.day, _dayAndTime.hour, _dayAndTime.minute);
                _areSearchCriteriaDirty = true;
              });
            }
          });
        },
      ),
      // Time selector
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
      ),
      // Number of people selector
      SizedBox(
        width: 150,
        child: TextField(
          decoration: InputDecoration(labelText: "Number of people"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly //TODO add min max formater
          ], // Only numbers can b
          maxLength: 2, // e entered
          controller: _nrOfPeopleController,
        ),
      )
    ]);
  }

  // Build Search view
  Widget buildSearchView(BuildContext context) {
    Divider divider = Divider(color: Theme.of(context).dividerColor);
    return Align(
        alignment: FractionalOffset.bottomCenter,
        child: IgnorePointer(
            ignoring: !_showFilters,
            child: AnimatedOpacity(
                opacity: _showFilters ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Card(
                    color: Theme.of(context).cardColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FutureBuilder(
                          future: _filtersFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _filters = snapshot.data as Filters;
                              List<String> locations = _filters.locations;
                              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                buildLocationSelector(locations),
                                divider,
                                buildDateAndTimeSelectors(),
                                divider,
                                buildWrappedFilters(_filters.prices),
                                divider,
                                buildWrappedFilters(_filters.foodCategories),
                                divider,
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

  // Helper to create wrapped widgets from list
  Widget buildWrappedFilters(List<TogglableItem> data) {
    return Wrap(children: data.map((item) => ToggleText(item)).toList());
  }

  // Build location selector with button for possible geolocation sorting in future
  Widget buildLocationSelector(List<String> locations) {
    return Row(children: <Widget>[
      FlatButton(
        child: Icon(Icons.location_on),
        onPressed: () async {
          //TODO not implemented yet
        },
      ),
      Expanded(
          child: DEDropDownButton(
        "Select place",
        _location,
        locations,
        <String>(String l) {
          return l.toString();
        },
        callback: <String>(String newValue) {
          setState(() {
            _areSearchCriteriaDirty = true;
          });
        },
      ))
    ]);
  }
}
