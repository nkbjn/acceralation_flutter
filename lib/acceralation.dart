//import 'package:json_annotation/json_annotation.dart';
//
//part 'acceralation.g.dart';
//
//@JsonSerializable()
//class Acceralation {
//  Acceralation(this.x, this.y, this.z);
//
//  double x;
//  double y;
//  double z;
//
//  factory Acceralation.fromJson(Map<String, double> json) => _$AcceralationFromJson(json);
//  Map<String, double> toJson() => _$AcceralationToJson(this);
//}

import 'package:json_annotation/json_annotation.dart';
import 'dart:math';

part 'acceralation.g.dart';

List<int> putTogether = [];
List<int> organizeList = [];
 
final double upper = 1;
final double downer = -1;
int step = 0;


@JsonSerializable()
class Acceralation {
  Acceralation(this.x, this.y, this.z);
  double x;
  double y;
  double z;

  factory Acceralation.fromJson(Map<String, double> json) => _$AcceralationFromJson(json);
  Map<String, double> toJson() => _$AcceralationToJson(this);
  
}

void print_Acceralation(Acceralation acc){
  print("x : ${acc.x}, y : ${acc.y}, z : ${acc.z}\n");
}

void getStep(List<Acceralation> acc){
  makeList(acc);
  orgList(putTogether);
  checkStep(organizeList);

  print(putTogether);
  print(organizeList);
  print("step = ${step}");

  putTogether.clear();
  organizeList.clear();

}

void makeList(List<Acceralation> acc){
  double now;
  acc.forEach((e){
    now = get_Acceralation(e);
    if (now < downer) putTogether.add(-1);
    else if (downer <= now && now < upper) putTogether.add(0);
    else if (upper < now) putTogether.add(1);
    });
}

void orgList(List<int> org){
  int len = org.length;
  if (len == 0) return;
  organizeList.add(org[0]);
  org.forEach((e){
    if(organizeList.last != e) organizeList.add(e);
  });
}

void checkStep(List<int> check){
  int len = check.length;
  if (len < 3) return ;
  for(int i = 0; i < len-3 ; i++){
    if (check[i] == 0 && check[i+2] == 0){
//      if ((check[i+1] == 1 && check[i+3] == -1) || (check[i+1] == -1 && check[i+3] == 1)){
      if (check[i+1] == 1 && check[i+3] == -1){
        step++;
        i += 3;
      }
    }
  }
}


double get_Acceralation(Acceralation acc) {
//  return sqrt(pow(acc.x, 2) + pow(acc.y, 2) + pow(acc.z, 2)) - 9.85;
  return sqrt(pow(acc.y, 2) + pow(acc.z, 2)) - 9.85;

}
