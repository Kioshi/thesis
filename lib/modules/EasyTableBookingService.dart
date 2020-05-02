import 'dart:convert';

import 'package:http/src/client.dart' as HTTP;
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/modules/BaseService.dart';

class EasyTableBookingService extends BaseService {
  EasyTableBookingService(HTTP.Client httpClient) : super(httpClient);

  @override
  Future<String> fetchTimes(DateTime dateTime, int nrOfPeople, Restaurant restaurant) async {
    final response = await httpClient.get("https://my-json-server.typicode.com/kioshi/thesis-mockup/times");
    if (response.statusCode == 200) {
      return response.body;
    }

    throw Exception("EasyTableBooking: Fetching times was unsucessfull -  code: ${response.statusCode}");
  }

  @override
  Future<List<int>> parseTimes(String times) {
    return json.decode(times).cast<int>();
  }
}
