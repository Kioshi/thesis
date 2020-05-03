import 'package:json_annotation/json_annotation.dart';

part 'Availability.g.dart';

enum AvailabilityState { Open, Closed, FullyBooked, TimeSlotAvailable, TimeSlotAlternativePossible, TimeSlotUnavailable }

@JsonSerializable()
class Availability {
  Availability({/*required*/ this.normalDays, /*required*/ this.specialDays});

  factory Availability.fromJson(Map<String, dynamic> json) => _$AvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$AvailabilityToJson(this);

  List<NormalDay> normalDays;
  List<SpecialDay> specialDays;
}

@JsonSerializable()
class NormalDay {
  NormalDay({/*required*/ this.daysMask, /*required*/ this.openFrom, /*required*/ this.openTill, /*required*/ this.open});

  factory NormalDay.fromJson(Map<String, dynamic> json) => _$NormalDayFromJson(json);

  Map<String, dynamic> toJson() => _$NormalDayToJson(this);

  int daysMask;
  int openFrom;
  int openTill;
  bool open;
}

@JsonSerializable()
class SpecialDay {
  SpecialDay({/*required*/ this.dates, /*required*/ this.openFrom, /*required*/ this.openTill, /*required*/ this.open});

  factory SpecialDay.fromJson(Map<String, dynamic> json) => _$SpecialDayFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialDayToJson(this);

  List<String> dates;
  int openFrom;
  int openTill;
  bool open;
}
