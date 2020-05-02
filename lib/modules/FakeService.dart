import 'dart:convert';
import 'dart:math';

import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/modules/BaseService.dart';

class FakeService extends BaseService {
  FakeService() : super(null);

  final _random = Random();

  @override
  Future<String> fetchTimes(DateTime dateTime, int nrOfPeople, Restaurant restaurant) async {
    List<int> times = [];
    for (int i = 0; i < 20; i++) {
      times.add(next(600, 1200));
    }
    times.sort();
    return Future.delayed(Duration(milliseconds: next(500, 5000)), () {
      return jsonEncode(times);
    });
  }

  @override
  Future<List<int>> parseTimes(String times) {
    return json.decode(times).cast<int>();
  }

  int next(int min, int max) => min + _random.nextInt(max - min);
}
