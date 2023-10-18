import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_voip/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_voip/main.dart';

class AgoraViewModel extends ChangeNotifier {
  int? remoteUid;
  bool localUserJoined = false;
  late RtcEngine engine;

  Future<void> initAgora(int callMode) async {
    await [Permission.microphone, Permission.camera].request();

    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: Constants.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteId, int elapsed) {
          remoteUid = remoteId;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          navigatorKey.currentState!.pop();
          const SnackBar snackBar = SnackBar(content: Text("Call Ended"));
          snackbarKey.currentState?.showSnackBar(snackBar);
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          navigatorKey.currentState!.pop();
          SnackBar snackBar = SnackBar(
              content: Text(
                  '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token'));
          snackbarKey.currentState?.showSnackBar(snackBar);
        },
      ),
    );

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    if (callMode == 0) {
      await engine.enableAudio();
    } else {
      await engine.enableVideo();
    }

    await engine.startPreview();

    await engine.joinChannel(
      token: Constants.token,
      channelId: Constants.channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
    notifyListeners();
  }

  Future<void> clearData() async {
    remoteUid = null;
    localUserJoined = false;
    await engine.leaveChannel();
    await engine.release();
  }
}
