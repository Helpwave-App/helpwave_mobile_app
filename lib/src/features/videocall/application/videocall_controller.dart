import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/agora_api.dart';

class VideoCallController {
  final String token;
  final String channelName;
  late RtcEngine _engine;

  final ValueNotifier<bool> localUserJoined = ValueNotifier(false);
  final ValueNotifier<int?> remoteUid = ValueNotifier(null);

  final ValueNotifier<bool> isMuted = ValueNotifier(false);
  final ValueNotifier<bool> isCameraMuted =
      ValueNotifier(false); // Local camara. false = cámara encendida
  final ValueNotifier<bool> isRemoteCameraOn =
      ValueNotifier(true); // Remote camara (simulated)

  VideoCallController({
    required this.token,
    required this.channelName,
  });

  RtcEngine get engine => _engine;

  Future<void> initialize() async {
    await _initAgoraEngine();
    _setupEventHandlers();
    await _startPreview();
    isCameraMuted.value = false;
    await _joinChannel();
  }

  Future<void> _initAgoraEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
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
        // Función temporal para el manejo de encendido y apagado de cámara remota sin backend
        onRemoteVideoStateChanged: (
          RtcConnection connection,
          int uid,
          RemoteVideoState state,
          RemoteVideoStateReason reason,
          int elapsed,
        ) {
          debugPrint(
              'Remote video state changed: uid=$uid, state=$state, reason=$reason');

          // Guarda el UID si aún no se había capturado
          remoteUid.value ??= uid;

          if (state == RemoteVideoState.remoteVideoStateStopped &&
              reason ==
                  RemoteVideoStateReason.remoteVideoStateReasonRemoteMuted) {
            isRemoteCameraOn.value = false;
          } else if (state == RemoteVideoState.remoteVideoStateDecoding) {
            isRemoteCameraOn.value = true;
          }
        },

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

  Future<void> switchCamera() async {
    await engine.switchCamera();
  }

  Future<void> toggleMute() async {
    isMuted.value = !isMuted.value;
    await engine.muteLocalAudioStream(isMuted.value);
  }

  Future<void> toggleCamera() async {
    isCameraMuted.value = !isCameraMuted.value;
    await engine.muteLocalVideoStream(isCameraMuted.value);
  }
}
