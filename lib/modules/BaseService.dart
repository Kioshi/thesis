import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thesis/models/Restaurant.dart';

// Base class for all 3rd party service modules
@immutable
abstract class BaseService {
  final http.Client httpClient;

  BaseService(this.httpClient);

  // Retrieving data from remote source for specific date, number of people and restaurant
  Future<String> fetchTimes(DateTime dateTime, int nrOfPeople, Restaurant restaurant);

  // Parsing (previously retrieved) data to list of times in minutes from midnight
  Future<List<int>> parseTimes(String times);
}
