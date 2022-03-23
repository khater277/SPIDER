import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SendNotification {
  static HttpClient httpClient = HttpClient();
  static String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  static const fcmKey = "AAAAUtKUpUE:APA91bECTszgemQtRfXeEmjOxtZVha-3_Qij5IGRymlDsd9l5raf__1w3H9rHUeTrKj7TWs6vn9ZMrzmLFCP9y3hyP0aHGFPZQt-DT_1P2SLZraxqltFCDI3zmSb6PPIHVzwNfZH00EE";

 static void sendFcm(String title, String body, String fcmToken,String id,
     {String? message, String? senderID}) async {

    var headers = {'Content-Type': 'application/json', 'Authorization': 'key=$fcmKey'};
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body = '''{
    "to":"$fcmToken",
    "priority":"high",
    "notification":{
    "title":"$title",
    "body":"$body","sound": "default"
    },
    "data":{
        "type":"order",
        "id":"$id",
        "lastMessage":"$message",
        "senderID":"$senderID",
        "click_action":"FLUTTER_NOTIFICATION_CLICK"
    }
    }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint(response.reasonPhrase);
    }
    print("NOTIFICATION SENT");
  }
}