import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:thesis/models/Booking.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';

class ReservePupUp extends StatefulWidget {
  Restaurant _restaurant;

  ReservePupUp(this._restaurant);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReservePupUpState(_restaurant);
  }
}

class ReservePupUpState extends State<ReservePupUp> {
  String phoneNumber;
  String phoneIsoCode;
  bool visible = false;
  String confirmedNumber = '';
  final _dineEasyRepository = DineEasyRepository();

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print(number);
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  Restaurant _restaurant;
  TextEditingController _nrOfPeopleController;
  TextEditingController _nameController;
  List<int> data = [60, 300, 652, 654, 1200, 1300, 2000];
  int selectedTime;

  Future<Booking> reservationFuture = null;

  ReservePupUpState(this._restaurant);

  @override
  void initState() {
    super.initState();
    selectedTime = data.first;
    _nrOfPeopleController = TextEditingController(text: '2');
    _nameController = TextEditingController(text: "Jmeno");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_restaurant.name),
      content: SingleChildScrollView(
          // new line
          child: Builder(
        builder: (BuildContext context) {
          if (reservationFuture == null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                InternationalPhoneInput(
                  onPhoneNumberChange: onPhoneNumberChange,
                  initialPhoneNumber: phoneNumber,
                  initialSelection: phoneIsoCode,
                  enabledCountries: ['+45', '+420'],
                  decoration: InputDecoration(labelText: "Phone Number"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Number of people"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter
                        .digitsOnly //TODO add min max formater
                  ], // Only numbers can be entered
                  controller: _nrOfPeopleController,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: "Time of reservation"),
                  value: selectedTime,
                  //isExpanded: true,
                  items: data
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "${(e / 60).toInt()}:${e % 60}",
                                  style: TextStyle(color: Colors.black),
                                )),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTime = value;
                    });
                  },
                  hint: Align(
                      alignment: FractionalOffset.center,
                      child: Text("Select city")),
                ),
              ],
            );
          }
          return FutureBuilder(
            future: reservationFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error);
              }

              return Text("Reservation sucessfull");
            },
          );
        },
      )),
      actions: reservationFuture == null
          ? <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Reserve"),
                onPressed: () {
                  setState(() {
                    reservationFuture = _dineEasyRepository.makeReservation(
                        phoneNumber,
                        _nameController.value,
                        _nrOfPeopleController.value,
                        selectedTime);
                    //TODO solve case when widget is closed

                    reservationFuture.whenComplete(() {
                      print("done");
                    });
                  });
                },
              )
            ]
          : <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
    );
  }
}