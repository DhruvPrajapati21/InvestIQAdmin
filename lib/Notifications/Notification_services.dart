import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Notification.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("Permission granted");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('Permission granted.');
      }
    } else {
      if (kDebugMode) {
        print("Permission denied");
      }
    }
  }

  void initLocalNotifications() async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("Received FCM message:");
        print("Title: ${message.notification!.title}");
        print("Body: ${message.notification!.body}");
      }

      // Check if the message contains data payload
      if (message.data.isNotEmpty) {
        if (kDebugMode) {
          print("Data payload: ${message.data}");
        }

        // Process the data payload
        handleMessage(context, message.data);
      }
    });
  }

  void showNotification(String title, String body) async {
    AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel(
      'your_channel_id', // Provide a unique channel ID here
      'High importance notification',
      'Channel Description!',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      androidNotificationChannel.id!,
      androidNotificationChannel.name!,
      androidNotificationChannel.description!,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
    if (kDebugMode) {
      print("Notification shown: Title: $title, Body: $body");
    }
  }

  void handleMessage(BuildContext context, Map<String, dynamic> data) {
    // Check if the data contains the necessary fields for your notification
    if (data.containsKey('type') &&
        data['type'] == 'intraday' &&
        data.containsKey('id')) {
      // Show notification
      showNotification(data['title'], data['body']);

      // Navigate to relevant screen if needed
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Notifications(id: data['id'])),
      );
      if (kDebugMode) {
        print("Notification triggered for intraday data. ID: ${data['id']}");
      }
    }
  }
}

