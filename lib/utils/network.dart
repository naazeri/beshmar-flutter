// import 'dart:convert';
// import 'package:beshmar/data/app_config.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Network {
//   static Future<String?> getDailyImage() async {
//     try {
//       final response = await http.get(Uri.parse(AppConfig.dailyImageApiUrl));

//       debugPrint('*** Status Code: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         Map<String, dynamic> result = jsonDecode(response.body);
//         debugPrint('*** Result: ${result}');

//         if (result['url'] != null) {
//           return result['url'];
//         }
//       }
//     } catch (e) {
//       debugPrint("*** can't send request: $e");
//     }

//     return null;
//   }
// }
