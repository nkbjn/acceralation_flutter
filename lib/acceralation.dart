import 'package:json_annotation/json_annotation.dart';

part 'acceralation.g.dart';

@JsonSerializable()
class Acceralation {
  Acceralation(this.x, this.y, this.z);

  double x;
  double y;
  double z;

  factory Acceralation.fromJson(Map<String, double> json) => _$AcceralationFromJson(json);
  Map<String, double> toJson() => _$AcceralationToJson(this);
}

//import 'package:json_annotation/json_annotation.dart';
//
//part 'acceralation.g.dart';
//
//
//class Acceralation {
//  Acceralation(this.x, this.y, this.z);
//  double x;
//  double y;
//  double z;
//}
//
//@JsonSerializable()
//class Acceralations {
//  Acceralations(this.acceralation);
//
//  List<Acceralation> acceralation;
//
//  factory Acceralations.fromJson(Map<String, double> json) => _$AcceralationsFromJson(json);
//  Map<String, double> toJson() => _$AcceralationsToJson(this);
//}
