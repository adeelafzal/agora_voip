import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:agora_voip/utils/constants.dart';
import 'package:agora_voip/view_model/agora_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key, required this.callMode, required this.name})
      : super(key: key);
  final int callMode;
  final String name;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late AgoraViewModel agoraViewModel;

  @override
  void initState() {
    super.initState();
    agoraViewModel = Provider.of<AgoraViewModel>(context, listen: false);
    agoraViewModel.initAgora(widget.callMode);
  }

  @override
  void dispose() {
    super.dispose();
    agoraViewModel.clearData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.callMode == 0 ? Colors.white : Colors.black,
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: widget.callMode == 0 ? buildAudio() : buildVideo(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.call_end,
          color: Colors.white,
        ),
        onPressed: () async {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildAudio() {
    return Center(
      child: Column(children: [
        const SizedBox(height: 50),
        const CircleAvatar(
          backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
          radius: 50,
        ),
        const SizedBox(height: 20),
        Text(
          widget.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 50),
        Selector<AgoraViewModel, int?>(
            selector: (_, provider) => provider.remoteUid,
            builder: (context, remoteUid, child) {
              return Text(
                remoteUid == null
                    ? 'Please wait for remote user to join'
                    : "Call Started",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: widget.callMode == 0 ? Colors.black : Colors.white),
              );
            }),
      ]),
    );
  }

  Stack buildVideo() {
    return Stack(
      children: [
        Center(
          child: _remoteVideo(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            width: 100,
            height: 150,
            child: Center(
              child: Selector<AgoraViewModel, bool>(
                  selector: (_, provider) => provider.localUserJoined,
                  builder: (context, localUserJoined, child) {
                    return localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: agoraViewModel.engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : const CircularProgressIndicator();
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _remoteVideo() {
    return Selector<AgoraViewModel, int?>(
        selector: (_, provider) => provider.remoteUid,
        builder: (context, remoteUid, child) {
          return remoteUid != null
              ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: agoraViewModel.engine,
                    canvas: VideoCanvas(uid: remoteUid),
                    connection:
                        const RtcConnection(channelId: Constants.channel),
                  ),
                )
              : Text(
                  'Please wait for remote user to join',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color:
                          widget.callMode == 0 ? Colors.black : Colors.white),
                );
        });
  }
}
