import 'dart:math';

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
    Random random = Random();
    this.id = i;
    this.name = "Resturant $i";
    this.address = "Addr $i";
    this.type = "Type $i";
    this.bookingType = random.nextInt(1) == 0 ? BookingTypes.EasyTableBooking : BookingTypes.DineEasyCallBooking;
    this.availabilityState = AvailabilityState.Open;
    this.availability = Availability(normalDays: [
      NormalDay(daysMask: 31, openFrom: 600, openTill: 1800, open: true),
      NormalDay(daysMask: 96, openFrom: 300, openTill: 600, open: true)
    ], specialDays: [
      SpecialDay(dates: ["2020-04-03"], open: true, openFrom: 0, openTill: 1440)
    ]);
    if (i % 5 == 0) {
      this.availableTimes = List.generate(20, (i) {
        return 600 + random.nextInt(1200);
      });
    }

    this.description =
        '''Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed elit dui, pellentesque a, faucibus vel, interdum nec, diam. In convallis. Sed ac dolor sit amet purus malesuada congue. Etiam neque. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Curabitur ligula sapien, pulvinar a vestibulum quis, facilisis vel sapien. Donec quis nibh at felis congue commodo. In dapibus augue non sapien. Nullam at arcu a est sollicitudin euismod. Nullam dapibus fermentum ipsum.
    
Mauris tincidunt sem sed arcu. In convallis. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Quisque porta. Praesent id justo in neque elementum ultrices. Proin mattis lacinia justo. Mauris dolor felis, sagittis at, luctus sed, aliquam non, tellus. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Nulla non arcu lacinia neque faucibus fringilla. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.''';
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
