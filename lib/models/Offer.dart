import 'package:json_annotation/json_annotation.dart';

part 'Offer.g.dart';

@JsonSerializable()
class Offer {
  final int id;
  final int daysMask;
  final int discount;

  Offer({/*required*/ this.id, /*required*/ this.daysMask, /*required*/ this.discount});

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
