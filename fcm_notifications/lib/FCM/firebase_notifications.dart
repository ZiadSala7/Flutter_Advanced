import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fcm_notifications/FCM/notification_models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class FirebaseNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // TODO: To check Authorization
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

  // TODO: to initialization firebaseMessaging
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    await getAccessToken();
    log(fcmToken.toString());
  }

  //TODO: to send notification
  Future<void> sendNotification({required NotificationModel model}) async {
    try {
      var serverKeyAuthorization = await getAccessToken();
      var token = await _firebaseMessaging.getToken();
      const String endPoint = "";
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = '';
      // ignore: unnecessary_brace_in_string_interps
      dio.options.headers['Authorization'] = 'Bearer ${serverKeyAuthorization}';

      var response = await dio.post(endPoint,
          data: NotificationPayload(
              fcmToken: token!,
              data: NotificationData(
                type: "type",
                id: "userId",
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
              ),
              notification: NotificationContent(
                title: model.title,
                body: model.notificationBody,
              )).toMap());

      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');
    } catch (e) {
      log("Error Sending Notifications : $e");
    }
  }

  //TODO: to get accessToken
  Future<String?> getAccessToken() async {
    final serviceAccountJson = {
      "type": "",
      "project_id": "advanced-projs",
      "private_key_id": "",
      "private_key": "",
      "client_email": "",
      "client_id": "",
      "auth_uri": "",
      "token_uri": "",
      "auth_provider_x509_cert_url": "",
      "client_x509_cert_url": "",
      "universe_domain": ""
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      client.close();
      log("Access Token: ${credentials.accessToken.data}"); // Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      log("Error getting access token: $e");
      return null;
    }
  }
}
