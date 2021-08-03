import 'dart:convert';
import 'package:kaymarts/functions/show_notification.dart';
import 'package:kaymarts/services/data_app_api.dart';
// import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Channel _channel;

Future<void> initPusher() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('UID');
  // if (userId != null) {
  //   try {
  //     await Pusher.init(pusherKey, PusherOptions(cluster: "eu"),
  //         enableLogging: true);
  //   } catch (e) {
  //     print(e.message);
  //   }
  //   Pusher.connect(onConnectionStateChange: (val) {
  //     print(val.currentState);
  //   }, onError: (err) {
  //     print(err.message);
  //   });
  //   _channel = await Pusher.subscribe('sendMessageToUser.$userId');
  //   _channel.bind('App\\Events\\SendMessageToUser', (onEvent) {
  //     Map<String, dynamic> data = json.decode(onEvent.data);
  //     print(data);
  //     showNotification(
  //       id: data['id'],
  //       title: "Message from admin",
  //       body: data['message'],
  //     );
  //   });
  // }
}
