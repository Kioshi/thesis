import 'package:flutter/material.dart';
import 'package:thesis/models/Booking.dart';

class BookingStateWidget extends StatelessWidget {
  final BookingState _state;

  BookingStateWidget(this._state);

  @override
  Widget build(BuildContext context) {
    String text = _state.toString();
    Color color = Colors.blue;

    switch (_state) {
      case BookingState.confirmed:
        text = "Confirmed";
        color = Colors.green;
        break;
      case BookingState.no_show:
        text = "No-Show";
        color = Colors.red;
        break;
      case BookingState.requested:
        text = "Requested";
        color = Colors.blue;
        break;
      case BookingState.canceled_by_restaurant:
      case BookingState.canceled_by_user:
        color = Colors.grey;
        text = "Cancelled";
        break;
    }

    return Text(
      text,
      style: TextStyle(backgroundColor: color),
    );
  }
}
