import 'dart:convert';

class CounterModel {
  static List<CounterModel> list = List.empty(growable: true);
  // static List<CounterModel> list = [
  //   CounterModel(
  //       title: "کی پنیر مرا جابجا کرد فصل ۱", count: 3, color: 4290190364),
  //   CounterModel(title: "امتیاز پینگ پنگ الهام", count: 4, color: 4293880832),
  //   CounterModel(title: "امتیاز پینگ پنگ رضا", count: 2, color: 4281236786),
  //   CounterModel(title: "درس فیزیک", count: 1, color: 4294918273),
  //   CounterModel(title: "ریاضی", count: 2, color: 4294953512),
  // ];

  String title;
  int count;
  int? color;

  CounterModel({required this.title, this.count = 0, this.color});

  Map<String, dynamic> toJson() => {
        'title': title,
        'count': count,
        'color': color,
      };

  factory CounterModel.fromJson(Map<String, dynamic> json) => CounterModel(
        title: json['title'],
        count: json['count'],
        color: json['color'],
      );

  static String encode(List<CounterModel> list) => json.encode(
        list.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
      );

  static List<CounterModel> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<CounterModel>((e) => CounterModel.fromJson(e))
          .toList();
}
