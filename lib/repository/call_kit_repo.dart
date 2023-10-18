import 'dart:convert';
import 'package:agora_voip/model/users.dart';
import 'package:agora_voip/utils/constants.dart';
import 'package:agora_voip/view/call_screen.dart';
import 'package:agora_voip/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:agora_voip/main.dart';
import 'package:agora_voip/model/CallModel.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

class CallKitRepository {
  displayIncomingCall(CallModel callModel) async {
    CallKitParams callKitParams = CallKitParams(
      id: const Uuid().v4(),
      nameCaller: callModel.email,
      appName: 'Callkit',
      avatar: 'https://i.pravatar.cc/100',
      handle: callModel.userId,
      type: callModel.callMode,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      duration: 30000,
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: 'https://i.pravatar.cc/500',
          actionColor: '#4CAF50',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call"),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }

  sendCallNotification({required Users user, required int callMode}) async {
    loadingDialog();
    try {
      Uri url = Uri.parse(Constants.fcmBaseUrl);
      var header = {
        "Content-Type": "application/json",
        "Authorization": Constants.serverKey,
      };
      var request = {
        'notification': {
          "title": "Incoming call",
          "body": "Tap to pick the call"
        },
        'data': {
          'email': user.email,
          'userId': user.userId,
          'callMode': callMode
        },
        'to': user.token
      };

      var client = http.Client();
      var response =
          await client.post(url, headers: header, body: json.encode(request));
      navigatorKey.currentState!.pop();
      if (response.statusCode == 200) {
        navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (_) => CallScreen(callMode: callMode, name: user.email)));
      } else {
        const SnackBar snackBar = SnackBar(content: Text("You can't call"));
        snackbarKey.currentState?.showSnackBar(snackBar);
      }
    } catch (e) {
      navigatorKey.currentState!.pop();
      SnackBar snackBar = SnackBar(content: Text(e.toString()));
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }
}
