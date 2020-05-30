// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) {
  return Offer(
    id: json['id'] as int,
    daysMask: json['days'] as int,
    discount: json['discount'] as int,
  );
}

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'id': instance.id,
      'days': instance.daysMask,
      'discount': instance.discount,
    };
