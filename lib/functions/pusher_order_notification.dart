import 'dart:convert';
import 'package:kaymarts/functions/show_notification.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/services/data_app_api.dart';
// import 'package:pusher_websocket_flutter/pusher.dart';

// Channel _channel;

Future<void> initPusherOrder(BuildContext context) async {
  // try {
  //   await Pusher.init(pusherKey, PusherOptions(cluster: "eu"),
  //       enableLogging: true);
  // } catch (e) {
  //   print(e.message);
  // }
  // Pusher.connect(onConnectionStateChange: (val) {
  //   print(val.currentState);
  // }, onError: (err) {
  //   print(err.message);
  // });
  // _channel = await Pusher.subscribe('SendNotificationToUser.16');
  // _channel
  //     .bind('lluminate\\Notifications\\Events\\BroadcastNotificationCreated',
  //         (onEvent) {
  //   Map<String, dynamic> data = json.decode(onEvent.data);
  //   print(data);
  //   showNotification(
  //     id: 1,
  //     title: "Message from admins",
  //     body: "ygtyfyu",
  //   );
  // });
}
