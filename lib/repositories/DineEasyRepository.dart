import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:thesis/models/Availability.dart';
import 'package:thesis/models/Booking.dart';
import 'package:thesis/models/Filters.dart';
import 'package:thesis/models/Offer.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/models/ToggableItem.dart';
import 'package:thesis/models/User.dart';
import 'package:thesis/modules/BaseService.dart';
import 'package:thesis/modules/ServiceFactory.dart';

import 'BaseRepository.dart';

class DineEasyRepository extends BaseRepository {
  final LocalStorage _storage;

  final http.Client _httpClient;

  DineEasyRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client(),
        _storage = LocalStorage('users.json');

  @override
  void dispose() {
    _httpClient.close();
  }

  @override
  Future<AvailabilityState> getRestaurantAvailability({DateTime dateTime, TimeOfDay timeOfDay, Restaurant restaurant, int nrOfPeople}) async {
    int time = timeOfDay.hour * 60 + timeOfDay.minute;
    restaurant.availabilityState = isOpenAtDateAndTime(restaurant.availability, dateTime, time);

    if (restaurant.availabilityState == AvailabilityState.Closed) {
      return restaurant.availabilityState;
    }

    BaseService service = ServicesFactory.getService(restaurant.bookingType);
    if (service == null) {
      return restaurant.availabilityState;
    }

    try {
      List<int> times = restaurant.availableTimes;

      if (times == null) {
        String data = await service.fetchTimes(dateTime, nrOfPeople, restaurant);
        times = await service.parseTimes(data);

        sendToServer(times, dateTime, nrOfPeople, restaurant);
      }

      restaurant.availableTimes = times;
      if (times.isEmpty) {
        restaurant.availabilityState = AvailabilityState.FullyBooked;
      } else if (time != null) {
        int timeDiff = 24 * 60;
        for (int availableTime in times) {
          int abs = (availableTime - time).abs();
          if (abs <= timeDiff) {
            timeDiff = abs;
            break;
          }
        }
        if (timeDiff < 20) {
          restaurant.availabilityState = AvailabilityState.TimeSlotAvailable;
        } else if (timeDiff < 60) {
          restaurant.availabilityState = AvailabilityState.TimeSlotAlternativePossible;
        } else {
          restaurant.availabilityState = AvailabilityState.TimeSlotUnavailable;
        }
      }
      return restaurant.availabilityState;
    } catch (err) {
      throw (err);
    }
  }

  AvailabilityState isOpenAtDateAndTime(Availability availability, DateTime dateTime, int time) {
    AvailabilityState state = AvailabilityState.Closed;

    for (NormalDay day in availability.normalDays) {
      if (day.daysMask & (dateTime.weekday + 1) != 0) {
        state = day.openFrom < time && day.openTill > time ? AvailabilityState.Open : AvailabilityState.Closed;
        break;
      }
    }

    for (SpecialDay day in availability.specialDays) {
      for (String date in day.dates) {
        if (date == DateFormat("yyyy-MM-dd").format(dateTime)) {
          return day.open && day.openFrom < time && day.openTill > time ? AvailabilityState.Open : AvailabilityState.Closed;
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
            foodCategories: ["Thai", "Chineese", "Danish", "French"].map((item) => TogglableItem(item)).toList(),
            prices: [
              "\$",
              "\$\$",
              "\$\$\$",
            ].map((item) => TogglableItem(item)).toList(),
            tags: ["Takeout", "Gardern"].map((item) => TogglableItem(item)).toList()));
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

  Future<Booking> makeReservation(String phoneNumber, TextEditingValue value, TextEditingValue value2, int selectedTime) {
    return Future.delayed(Duration(seconds: 1), () {
      return Booking(id: 1, date: DateTime.now(), nrOfPeople: 2, discount: 15, name: "Stepan", phoneNr: "+4550207092");
    });
  }

  Future<List<Booking>> getBookings() async {
    try {
      final response = await _httpClient.get("https://my-json-server.typicode.com/kioshi/thesis-mockup/bookings");
      if (response.statusCode == 200) {
        return (json.decode(response.body) as List).map((i) => Booking.fromJson(i)).toList();
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
            name: "Štepan Martinek",
            nrOfPeople: 2,
            phoneNr: "+45000000",
            state: BookingState.confirmed,
            restaurantName: "Restaurant $i"));
      }
      return bookings;
    });
  }

  Future<User> getUser() async {
    await _storage.ready;
    Map<String, dynamic> data = _storage.getItem('user');
    User user;
    if (data == null) {
      user = User(id: 1, name: "Štěpán Martínek", phoneNr: "+4500000000");
      await _storage.setItem("user", user);
    } else {
      user = User.fromJson(data);
    }
    return User.fromJson(_storage.getItem('user'));
  }

  Future<void> updateUser(User user) async {
    await _storage.ready;
    await _storage.setItem("user", user.toJson());
  }

  void sendToServer(List<int> times, DateTime dateTime, int nrOfPeople, Restaurant restaurant) async {
    //TODO send on background to server
  }

  Future<List<Offer>> getOffers(Restaurant restaurant) {
    return Future.delayed(Duration(seconds: 2), () {
      return [Offer(id: 0, days: 127, discount: 0), Offer(id: 1, days: 60, discount: 10), Offer(id: 2, days: 103, discount: 7)];
    });
  }
}
