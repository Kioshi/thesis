import 'package:json_annotation/json_annotation.dart';

part 'Booking.g.dart';

enum BookingTypes { DineEasyCallBooking, NoBooking, EasyTableBooking }
enum BookingState {
  requested,
  confirmed,
  canceled_by_user,
  canceled_by_restaurant,
  no_show
}

@JsonSerializable()
class Booking {
  @override
  final int id;
  final DateTime date;
  final int nrOfPeople;
  final int discount;
  final String name;
  final String phoneNr;

  final BookingState state;

  //final BelongsTo<Restaurant> restaurant;

  Booking(
      {this.id,
      this.date,
      this.nrOfPeople,
      this.discount,
      this.name,
      this.phoneNr,
      this.state
      //this.restaurant
      });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
