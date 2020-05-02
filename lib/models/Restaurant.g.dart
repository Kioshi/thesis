// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) {
  return Restaurant(
    id: json['id'] as int,
    name: json['name'] as String,
    address: json['address'] as String,
    type: json['type'] as String,
    postalCode: json['postalCode'] as int,
    website: json['website'] as String,
    menuURL: json['menuURL'] as String,
    description: json['description'] as String,
    publicEmail: json['publicEmail'] as String,
    publicPhone: json['publicPhone'] as int,
    publicPhoneCountryCode: json['publicPhoneCountryCode'] as int,
    city: json['city'] as String,
    latitude: json['latitude'] as int,
    longitude: json['longitude'] as int,
    capacity: json['capacity'] as int,
    foodCategories:
        (json['foodCategories'] as List)?.map((e) => e as String)?.toList(),
    bookingType:
        _$enumDecodeNullable(_$BookingTypesEnumMap, json['bookingType']),
    availability: json['availability'] == null
        ? null
        : Availability.fromJson(json['availability'] as Map<String, dynamic>),
  )
    ..availabilityState = _$enumDecodeNullable(
        _$AvailabilityStateEnumMap, json['availabilityState'])
    ..availableTimes =
        (json['availableTimes'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'type': instance.type,
      'postalCode': instance.postalCode,
      'website': instance.website,
      'menuURL': instance.menuURL,
      'description': instance.description,
      'publicEmail': instance.publicEmail,
      'publicPhone': instance.publicPhone,
      'publicPhoneCountryCode': instance.publicPhoneCountryCode,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'capacity': instance.capacity,
      'foodCategories': instance.foodCategories,
      'bookingType': _$BookingTypesEnumMap[instance.bookingType],
      'availability': instance.availability,
      'availabilityState':
          _$AvailabilityStateEnumMap[instance.availabilityState],
      'availableTimes': instance.availableTimes,
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

const _$BookingTypesEnumMap = {
  BookingTypes.DineEasyCallBooking: 'DineEasyCallBooking',
  BookingTypes.NoBooking: 'NoBooking',
  BookingTypes.EasyTableBooking: 'EasyTableBooking',
};

const _$AvailabilityStateEnumMap = {
  AvailabilityState.Open: 'Open',
  AvailabilityState.Closed: 'Closed',
  AvailabilityState.FullyBooked: 'FullyBooked',
  AvailabilityState.TimeSlotAvailable: 'TimeSlotAvailable',
  AvailabilityState.TimeSlotAlternativePossible: 'TimeSlotAlternativePossible',
  AvailabilityState.TimeSlotUnavailable: 'TimeSlotUnavailable',
};
