// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return Booking(
    id: json['id'] as int,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    nrOfPeople: json['nrOfPeople'] as int,
    discount: json['discount'] as int,
    name: json['name'] as String,
    phoneNr: json['phoneNr'] as String,
    state: _$enumDecodeNullable(_$BookingStateEnumMap, json['state']),
  );
}

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'nrOfPeople': instance.nrOfPeople,
      'discount': instance.discount,
      'name': instance.name,
      'phoneNr': instance.phoneNr,
      'state': _$BookingStateEnumMap[instance.state],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$BookingStateEnumMap = {
  BookingState.requested: 'requested',
  BookingState.confirmed: 'confirmed',
  BookingState.canceled_by_user: 'canceled_by_user',
  BookingState.canceled_by_restaurant: 'canceled_by_restaurant',
  BookingState.no_show: 'no_show',
};
