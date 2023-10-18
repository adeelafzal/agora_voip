import 'package:agora_voip/utils/firebase_notifications.dart';
import 'package:agora_voip/view/call_screen.dart';
import 'package:agora_voip/view/home_screen.dart';
import 'package:agora_voip/view/signin_screen.dart';
import 'package:agora_voip/view/signup_screen.dart';
import 'package:agora_voip/view/splash_screen.dart';
import 'package:agora_voip/view_model/agora_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseNotifications().setupFirebaseCloudMessagingListeners();
  FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
    switch (event!.event) {
      case Event.actionCallIncoming:
        print("Event.actionCallIncoming");
        break;
      case Event.actionCallStart:
        print("Event.actionCallIncoming");
        break;
      case Event.actionCallAccept:
        print("Event.actionCallAccept");
        navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (_) => CallScreen(
                  callMode: event.body["type"],
                  name: event.body["nameCaller"],
                )));
        break;
      case Event.actionCallDecline:
        print("Event.actionCallDecline");
        break;
      case Event.actionCallEnded:
        print("Event.actionCallEnded");
        break;
      case Event.actionCallTimeout:
        print("Event.actionCallTimeout");
        break;
      case Event.actionCallCallback:
        print("Event.actionCallCallback");
        break;
      case Event.actionCallToggleHold:
        break;
      case Event.actionCallToggleMute:
        break;
      case Event.actionCallToggleDmtf:
        break;
      case Event.actionCallToggleGroup:
        break;
      case Event.actionCallToggleAudioSession:
        break;
      case Event.actionDidUpdateDevicePushTokenVoip:
        break;
      case Event.actionCallCustom:
        print("Event.actionCallCustom");
        break;
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AgoraViewModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: snackbarKey,
        title: 'Agora VOIP',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/SignInScreen': (context) => SignInScreen(),
          '/SignUpScreen': (context) => SignUpScreen(),
          '/HomeScreen': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
