import 'package:json_annotation/json_annotation.dart';
import 'package:thesis/models/Availability.dart';
import 'package:thesis/models/Booking.dart';

part 'Restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  int id;
  String name;
  String address;
  String type;
  int postalCode;
  String website;
  String menuURL;
  String description;
  String publicEmail;
  int publicPhone;
  int publicPhoneCountryCode;
  String city;
  int latitude;
  int longitude;
  int capacity;
  List<String> foodCategories;
  BookingTypes bookingType;
  Availability availability;

  // Internal state variables
  AvailabilityState availabilityState = AvailabilityState.Open;
  List<int> availableTimes;

  Restaurant(
      {this.id,
      this.name,
      this.address,
      this.type,
      this.postalCode,
      this.website,
      this.menuURL,
      this.description,
      this.publicEmail,
      this.publicPhone,
      this.publicPhoneCountryCode,
      this.city,
      this.latitude,
      this.longitude,
      this.capacity,
      this.foodCategories,
      this.bookingType,
      this.availability});

  Restaurant.test(int i) {
    this.id = i;
    this.name = "Resturant $i";
    this.address = "Addr $i";
    this.type = "Type $i";
    this.bookingType = BookingTypes.EasyTableBooking;
    this.availabilityState = AvailabilityState.Open;
    this.availability = Availability(normalDays: [
      NormalDay(daysMask: 31, openFrom: 600, openTill: 1800, open: true),
      NormalDay(daysMask: 96, openFrom: 300, openTill: 600, open: true)
    ], specialDays: [
      SpecialDay(dates: ["2020-04-03"], open: true, openFrom: 0, openTill: 1440)
    ]);
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
