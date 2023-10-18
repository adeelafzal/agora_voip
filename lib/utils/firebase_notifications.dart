import 'package:agora_voip/main.dart';
import 'package:agora_voip/model/CallModel.dart';
import 'package:agora_voip/model/users.dart';
import 'package:agora_voip/repository/call_kit_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FirebaseNotifications._instance.setupFlutterNotifications();
  showFlutterNotification(message);
  CallModel callData = CallModel(
      email: message.data["email"],
      userId: message.data["userId"],
      callMode: int.parse(message.data["callMode"]));
  CallKitRepository().displayIncomingCall(callData);
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'app_icon',
        ),
      ),
    );
  }
}

class FirebaseNotifications {
  static final FirebaseNotifications _instance =
      FirebaseNotifications._internal();
  final CallKitRepository callKitRepository = CallKitRepository();
  bool isFlutterLocalNotificationsInitialized = false;

  FirebaseNotifications._internal();

  factory FirebaseNotifications() => _instance;

  RemoteMessage? displayMessage;

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  int count = 0;

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description:
          'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void setupFirebaseCloudMessagingListeners() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      print("Message received");

      CallModel callData = CallModel(
          email: message.data["email"],
          userId: message.data["userId"],
          callMode: int.parse(message.data["callMode"]));
      callKitRepository.displayIncomingCall(callData);
    });
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      const SnackBar snackBar = SnackBar(content: Text("Hello"));
      snackbarKey.currentState?.showSnackBar(snackBar);
    });
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print("Notification Clicked");
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future<String?> getDeviceToken() async {
    String? deviceToken = await _messaging.getToken();
    print('Device Token: $deviceToken');
    return deviceToken;
  }
}
