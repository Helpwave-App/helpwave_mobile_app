import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/agora_api.dart';

class VideoCallController {
  final String token;
  final String channelName;
  late RtcEngine _engine;

  final ValueNotifier<bool> localUserJoined = ValueNotifier(false);
  final ValueNotifier<int?> remoteUid = ValueNotifier(null);

  VideoCallController({
    required this.token,
    required this.channelName,
  });

  RtcEngine get engine => _engine;

  Future<void> initialize() async {
    await _requestPermissions();
    await _initAgoraEngine();
    _setupEventHandlers();
    await _startPreview();
    await _joinChannel();
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  Future<void> _initAgoraEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: AgoraConstants.appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
  }

  Future<void> _startPreview() async {
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint('Local user joined');
          localUserJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('Remote user $remoteUid joined');
          this.remoteUid.value = remoteUid;
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint('Remote user $remoteUid left');
          this.remoteUid.value = null;
        },
      ),
    );
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  Future<void> leave() async {
    await _engine.leaveChannel();
    await _engine.release();
  }
}
