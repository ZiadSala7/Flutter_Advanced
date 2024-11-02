import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterPushNotificationApp());
}

class FlutterPushNotificationApp extends StatelessWidget {
  const FlutterPushNotificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}
