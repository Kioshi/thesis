import 'package:json_annotation/json_annotation.dart';

part 'Booking.g.dart';

enum BookingTypes { DineEasyCallBooking, NoBooking, EasyTableBooking }
enum BookingState { requested, confirmed, canceled_by_user, canceled_by_restaurant, no_show }

@JsonSerializable()
class Booking {
  final int id;
  // Date and time of reservation
  final DateTime date;
  final int nrOfPeople;
  final int discount;
  final String name;
  final String phoneNr;
  final String restaurantName;

  final BookingState state;

  Booking(
      {/*required*/ this.id,
      /*required*/ this.date,
      /*required*/ this.nrOfPeople,
      /*required*/ this.discount,
      /*required*/ this.name,
      /*required*/ this.phoneNr,
      /*required*/ this.state,
      /*required*/ this.restaurantName});

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
