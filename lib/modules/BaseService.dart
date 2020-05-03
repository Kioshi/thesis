import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thesis/models/Restaurant.dart';

@immutable
abstract class BaseService {
  final http.Client httpClient;

  BaseService(this.httpClient);

  Future<String> fetchTimes(DateTime dateTime, int nrOfPeople, Restaurant restaurant);

  Future<List<int>> parseTimes(String times);
}
