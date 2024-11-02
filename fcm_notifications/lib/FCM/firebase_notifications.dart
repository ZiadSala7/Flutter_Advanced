import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<int> requestPermissions() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return 1;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      return 2;
    } else {
      return 3;
    }
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print(fcmToken.toString());
    }
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMsg);
  }

  Future<void> handleBackgroundMsg(RemoteMessage msg) async {
    if (kDebugMode) {
      print("Title : ${msg.notification?.title}");
      print("Body : ${msg.notification?.body}");
      print("Payload : ${msg.data}");
    }
  }
}
