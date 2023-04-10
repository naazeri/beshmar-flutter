import 'dart:convert';

class CounterModel {
  static List<CounterModel> list = List.empty(growable: true);

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
