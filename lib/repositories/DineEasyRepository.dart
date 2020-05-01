import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:thesis/models/Availability.dart';
import 'package:thesis/models/Booking.dart';
import 'package:thesis/models/Filters.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/models/ToggableItem.dart';

import 'BaseRepository.dart';

class DineEasyRepository extends BaseRepository {
  static const String _baseUrl = 'http://localhost:8888';

  final http.Client _httpClient;

  final _random = new Random();

  /**
   * Generates a positive random integer uniformly distributed on the range
   * from [min], inclusive, to [max], exclusive.
   */
  int next(int min, int max) => min + _random.nextInt(max - min);

  DineEasyRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  void dispose() {
    _httpClient.close();
  }

  @override
  Future<AvailabilityState> getRestaurantAvailability(
      {DateTime dateTime, TimeOfDay timeOfDay, Restaurant restaurant}) async {
    int time = timeOfDay.hour * 60 + timeOfDay.minute;
    restaurant.availabilityState =
        isOpenAtDateAndTime(restaurant.availability, dateTime, time);

    if (restaurant.availabilityState == AvailabilityState.Closed ||
        restaurant.bookingType == BookingTypes.DineEasyCallBooking ||
        restaurant.bookingType == BookingTypes.NoBooking) {
      return restaurant.availabilityState;
    }

    //TODO move to factory based on reservation type
    //String requestUrl = '$_baseUrl/restaurants/${restaurant.id}/times';
    try {
      //final response = await _httpClient.get(requestUrl);
      final response =
          await Future.delayed(Duration(milliseconds: next(500, 5000)), () {
        return http.Response("[100,256,354,68,549]", 200);
      });
      if (response.statusCode == 200) {
        List<int> data = json.decode(response.body).cast<int>();
        restaurant.availableTimes = data;
        if (data.isEmpty) {
          restaurant.availabilityState = AvailabilityState.FullyBooked;
        } else if (time != null) {
          int timeDiff = 24 * 60;
          for (int availableTime in data) {
            int abs = (availableTime - time).abs();
            if (abs <= timeDiff) {
              timeDiff = abs;
              break;
            }
          }
          if (timeDiff < 20) {
            restaurant.availabilityState = AvailabilityState.TimeSlotAvailable;
          } else if (timeDiff < 60) {
            restaurant.availabilityState =
                AvailabilityState.TimeSlotAlternativePossible;
          } else {
            restaurant.availabilityState =
                AvailabilityState.TimeSlotUnavailable;
          }
        }
      }
      return restaurant.availabilityState;
    } catch (err) {
      throw (err);
    }
  }

  AvailabilityState isOpenAtDateAndTime(
      Availability availability, DateTime dateTime, int time) {
    AvailabilityState state = AvailabilityState.Closed;

    for (NormalDay day in availability.normalDays) {
      if (day.daysMask & (dateTime.weekday + 1) != 0) {
        state = day.openFrom < time && day.openTill > time
            ? AvailabilityState.Open
            : AvailabilityState.Closed;
        break;
      }
    }

    for (SpecialDay day in availability.specialDays) {
      for (String date in day.dates) {
        if (date == DateFormat("yyyy-MM-dd").format(dateTime)) {
          return day.open && day.openFrom < time && day.openTill > time
              ? AvailabilityState.Open
              : AvailabilityState.Closed;
        }
      }
    }
    return state;
  }

  Future<Filters> getFilters() {
    return Future.delayed(
        Duration(seconds: 3),
        () => Filters(
            locations: ["Odense", "Plzeň"],
            foodCategories: ["Thai", "Chineese", "Danish", "French"]
                .map((item) => TogglableItem(item))
                .toList(),
            prices: [
              "\$",
              "\$\$",
              "\$\$\$",
            ].map((item) => TogglableItem(item)).toList(),
            tags: ["Takeout", "Gardern"]
                .map((item) => TogglableItem(item))
                .toList()));
  }

  Future<List<Restaurant>> getRestaurants(String location, Filters filters) {
    return Future.delayed(Duration(seconds: 3), () {
      List<Restaurant> restaurants = List();
      for (int i = 0; i < 100; i++) {
        restaurants.add(Restaurant.test(i));
      }
      return restaurants;
    });
  }

  Future<Booking> makeReservation(String phoneNumber, TextEditingValue value,
      TextEditingValue value2, int selectedTime) {
    return Future.delayed(Duration(seconds: 1), () {
      return Booking(
          id: 1,
          date: DateTime.now(),
          nrOfPeople: 2,
          discount: 15,
          name: "Stepan",
          phoneNr: "+4550207092");
    });
  }

  Future<List<Booking>> getBookings() async {
    try {
      final response = await _httpClient.get(
          "https://my-json-server.typicode.com/kioshi/thesis-mockup/bookings");
      if (response.statusCode == 200) {
        return (json.decode(response.body) as List)
            .map((i) => Booking.fromJson(i))
            .toList();
      }
    } catch (ex) {
      print(ex);
    }
    return Future.delayed(Duration(seconds: 2), () {
      List<Booking> bookings = [];
      for (int i = 1; i < 15; i++) {
        bookings.add(Booking(
            id: i,
            discount: i + 10,
            date: DateTime.now(),
            name: "Stepan Martinek",
            nrOfPeople: 2,
            phoneNr: "+45000000",
            state: BookingState.confirmed));
      }
      return bookings;
    });
  }
}
