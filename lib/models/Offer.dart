import 'package:json_annotation/json_annotation.dart';

part 'Offer.g.dart';

@JsonSerializable()
class Offer {
  final int id;
  final int days;
  final int discount;

  Offer({this.id, this.days, this.discount});

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
