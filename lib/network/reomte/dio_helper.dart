import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
        BaseOptions(
            baseUrl: 'https://fcm.googleapis.com',
            receiveDataWhenStatusError: true,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': "AAAAUtKUpUE:APA91bECTszgemQtRfXeEmjOxtZVha-3_Qij5IGRymlDsd9l5raf__1w3H9rHUeTrKj7TWs6vn9ZMrzmLFCP9y3hyP0aHGFPZQt-DT_1P2SLZraxqltFCDI3zmSb6PPIHVzwNfZH00EE",
            }
        )
    );
  }


  // Map<String, dynamic> data = {
  //   "to": "dKmcBbaBRUC4lhPY1JWYjl:APA91bHiqlttAa9NJ9sRpyxnuT4McwyBSMcgeBNQ80qMFz-nFsPGRn4Oxx4mW1bZfKFASO0QUkt4nh13CyBzf5gcnGd3Yx97RHaoIfWxkx8RW-Vgu16KEwLkVxXF9VHj88waIUH6T8H_",
  //   "notification": {
  //     "title": "you have received a message from Ahmed Khater",
  //     "body": "testing body from postman",
  //     "sound": "default"
  //   },
  //   "android": {
  //     "priority": "HIGH",
  //     "notification": {
  //       "notification_priority": "PRIORITY_MAX",
  //       "sound": "default",
  //       "default_sound": true,
  //       "default_vibrate_timings": true,
  //       "default_light_settings": true
  //     },
  //     "data": {
  //       "type": "order",
  //       "id": 87,
  //       "click_action": "FLUTTER_NOTIFICATION_CLICK"
  //     }
  //   }
  // };

  static Future<Response> postData({
    @required String? url,
    @required Map<String, dynamic>? data,
  }) async {
    return await dio!.post(url!, data: data!);
  }
}