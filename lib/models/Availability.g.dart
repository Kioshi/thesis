// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Availability _$AvailabilityFromJson(Map<String, dynamic> json) {
  return Availability(
    normalDays: (json['normalDays'] as List)
        ?.map((e) =>
            e == null ? null : NormalDay.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    specialDays: (json['specialDays'] as List)
        ?.map((e) =>
            e == null ? null : SpecialDay.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AvailabilityToJson(Availability instance) =>
    <String, dynamic>{
      'normalDays': instance.normalDays,
      'specialDays': instance.specialDays,
    };

NormalDay _$NormalDayFromJson(Map<String, dynamic> json) {
  return NormalDay(
    daysMask: json['daysMask'] as int,
    openFrom: json['openFrom'] as int,
    openTill: json['openTill'] as int,
    open: json['open'] as bool,
  );
}

Map<String, dynamic> _$NormalDayToJson(NormalDay instance) => <String, dynamic>{
      'daysMask': instance.daysMask,
      'openFrom': instance.openFrom,
      'openTill': instance.openTill,
      'open': instance.open,
    };

SpecialDay _$SpecialDayFromJson(Map<String, dynamic> json) {
  return SpecialDay(
    dates: (json['dates'] as List)?.map((e) => e as String)?.toList(),
    openFrom: json['openFrom'] as int,
    openTill: json['openTill'] as int,
    open: json['open'] as bool,
  );
}

Map<String, dynamic> _$SpecialDayToJson(SpecialDay instance) =>
    <String, dynamic>{
      'dates': instance.dates,
      'openFrom': instance.openFrom,
      'openTill': instance.openTill,
      'open': instance.open,
    };
