import 'dart:async';

import 'package:flutter/services.dart';

class AwsAnalytics {
  static const MethodChannel _channel =
      const MethodChannel('aws_analytics');

  static Future<void> registerGlobalProperties(Map<String,dynamic> properties) async {
    try {
      _channel.invokeMethod("registerGlobalProperties", properties);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> unregisterGlobalProperties({List<String> keys}) async {
    try {
      _channel.invokeMethod("unregisterGlobalProperties", keys);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> record(String event, Map<String,dynamic> properties) async {
    try {
      _channel.invokeMethod("record", {
        'event': event,
        'properties': properties,
      });
    } catch (e) {
      print(e);
    }
  }
}
