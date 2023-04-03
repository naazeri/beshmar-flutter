import 'dart:convert';

class CounterModel {
  static List<CounterModel> list = List.empty(growable: true);

  String title;
  int count;

  CounterModel({required this.title, this.count = 0});

  Map<String, dynamic> toJson() => {
        'title': title,
        'count': count,
      };

  factory CounterModel.fromJson(Map<String, dynamic> json) => CounterModel(
        title: json['title'],
        count: json['count'],
      );

  static String encode(List<CounterModel> list) => json.encode(
        list.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
      );

  static List<CounterModel> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<CounterModel>((e) => CounterModel.fromJson(e))
          .toList();
}
