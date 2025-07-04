import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/utils/constants/agora_api.dart';
import '../../../common/utils/constants/call_session.dart';
import '../data/videocall_service.dart';

class VideoCallController {
  final String token;
  final String channelName;

  late final RtcEngine _engine;
  final VideocallService _service = VideocallService();

  final ValueNotifier<bool> isLocalUserJoined = ValueNotifier(false);
  final ValueNotifier<int?> remoteUserId = ValueNotifier(null);
  final ValueNotifier<bool> isLocalAudioMuted = ValueNotifier(false);
  final ValueNotifier<bool> isLocalVideoMuted = ValueNotifier(false);
  final ValueNotifier<bool> isRemoteVideoAvailable = ValueNotifier(false);

  VideoCallController({
    required this.token,
    required this.channelName,
  });

  RtcEngine get engine => _engine;

  Future<void> initialize() async {
    await _requestPermissions();
    await _initEngine();
    _registerEventHandlers();
    await _engine.enableVideo();
    await _engine.startPreview();
    await _joinChannel();
    CallSession.currentChannel = channelName;
  }

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (!cameraStatus.isGranted || !micStatus.isGranted) {
      throw Exception(
          'Permisos de cámara y micrófono son necesarios para la videollamada.');
    }
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: AgoraConstants.appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
        orientationMode: OrientationMode.orientationModeAdaptive,
        degradationPreference: DegradationPreference.maintainQuality,
      ),
    );
  }

  void _registerEventHandlers() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print('✅ Local user joined channel: ${connection.channelId}');
        isLocalUserJoined.value = true;
      },
      onUserJoined: (RtcConnection connection, int uid, int elapsed) {
        debugPrint('👤 Remote user joined: $uid');
        remoteUserId.value = uid;
        isRemoteVideoAvailable.value = true;
      },
      onUserOffline:
          (RtcConnection connection, int uid, UserOfflineReasonType reason) {
        debugPrint('👤 Remote user left: $uid');
        if (remoteUserId.value == uid) {
          remoteUserId.value = null;
          isRemoteVideoAvailable.value = false;
        }
      },
      onRemoteVideoStateChanged: (RtcConnection connection, int uid,
          RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
        debugPrint(
            '🎥 Remote video state changed: uid=$uid, state=$state, reason=$reason');
        if (uid == remoteUserId.value) {
          isRemoteVideoAvailable.value =
              (state == RemoteVideoState.remoteVideoStateDecoding);
        }
      },
      onError: (ErrorCodeType code, String msg) {
        debugPrint('❌ Agora error: $code - $msg');
      },
      onConnectionStateChanged: (RtcConnection connection,
          ConnectionStateType state, ConnectionChangedReasonType reason) {
        debugPrint('🔄 Conexión Agora cambió: $state, razón: $reason');
      },
    ));
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
    try {
      if (CallSession.currentChannel != null) {
        await _service.endVideocall(CallSession.currentChannel!);
      }
    } catch (e) {
      debugPrint('❌ Error al notificar fin de videollamada: $e');
    }

    await _engine.leaveChannel();
    await _engine.stopPreview();
    await Future.delayed(const Duration(seconds: 1));
    await _engine.release();

    CallSession.currentChannel = null;
  }

  Future<void> toggleMuteAudio() async {
    isLocalAudioMuted.value = !isLocalAudioMuted.value;
    await _engine.muteLocalAudioStream(isLocalAudioMuted.value);
  }

  Future<void> toggleMuteVideo() async {
    isLocalVideoMuted.value = !isLocalVideoMuted.value;
    await _engine.muteLocalVideoStream(isLocalVideoMuted.value);

    if (isLocalVideoMuted.value) {
      await _engine.stopPreview();
    } else {
      await _engine.startPreview();
    }
  }

  Future<void> switchCamera() async {
    await _engine.switchCamera();
  }
}
