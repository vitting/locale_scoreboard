// import 'dart:convert';

// import 'package:flutter/material.dart';

// class ConfigData {
//    static Future<ConfigData> getConfig(BuildContext context) async {
//     ConfigData config;

//     try {
//       String data = await DefaultAssetBundle.of(context).loadString("assets/files/config.json");

//       Map<String, dynamic> jsonDecoded = json.decode(data);
//       config = ConfigData.fromMap(jsonDecoded);
//     } catch (e) {
//       print(e);
//     }

//     return config;
//   }

//   factory ConfigData.fromMap(Map<String, dynamic> item) {
//     return ConfigData();
//   }
// }