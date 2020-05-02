import 'package:json_annotation/json_annotation.dart';

part 'Availability.g.dart';

enum AvailabilityState { Open, Closed, FullyBooked, TimeSlotAvailable, TimeSlotAlternativePossible, TimeSlotUnavailable }

@JsonSerializable()
class Availability {
  List<NormalDay> normalDays;
  List<SpecialDay> specialDays;

  Availability({this.normalDays, this.specialDays});

  factory Availability.fromJson(Map<String, dynamic> json) => _$AvailabilityFromJson(json);
  Map<String, dynamic> toJson() => _$AvailabilityToJson(this);
}

@JsonSerializable()
class NormalDay {
  int daysMask;
  int openFrom;
  int openTill;
  bool open;

  NormalDay({this.daysMask, this.openFrom, this.openTill, this.open});

  factory NormalDay.fromJson(Map<String, dynamic> json) => _$NormalDayFromJson(json);
  Map<String, dynamic> toJson() => _$NormalDayToJson(this);
}

@JsonSerializable()
class SpecialDay {
  List<String> dates;
  int openFrom;
  int openTill;
  bool open;

  SpecialDay({this.dates, this.openFrom, this.openTill, this.open});

  factory SpecialDay.fromJson(Map<String, dynamic> json) => _$SpecialDayFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialDayToJson(this);
}
