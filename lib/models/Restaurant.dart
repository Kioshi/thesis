import 'package:thesis/models/Availability.dart';
import 'package:thesis/models/Booking.dart';

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

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    type = json['type'];
    postalCode = json['postalCode'];
    website = json['website'];
    menuURL = json['menuURL'];
    description = json['description'];
    publicEmail = json['publicEmail'];
    publicPhone = json['publicPhone'];
    publicPhoneCountryCode = json['publicPhoneCountryCode'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    capacity = json['capacity'];
    foodCategories = json['foodCategories'].cast<String>();

    availability = json['availability'] != null
        ? new Availability.fromJson(json['availability'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['type'] = this.type;
    data['postalCode'] = this.postalCode;
    data['website'] = this.website;
    data['menuURL'] = this.menuURL;
    data['description'] = this.description;
    data['publicEmail'] = this.publicEmail;
    data['publicPhone'] = this.publicPhone;
    data['publicPhoneCountryCode'] = this.publicPhoneCountryCode;
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['capacity'] = this.capacity;
    data['foodCategories'] = this.foodCategories;

    data['bookingType'] = this.bookingType.toString();

    if (this.availability != null) {
      data['availability'] = this.availability.toJson();
    }
    return data;
  }

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
}
