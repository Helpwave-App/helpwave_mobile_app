import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../application/videocall_controller.dart';

class VideoCallScreen extends StatefulWidget {
  final String token;
  final String channelName;

  const VideoCallScreen({
    super.key,
    required this.token,
    required this.channelName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late VideoCallController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoCallController(
      token: widget.token,
      channelName: widget.channelName,
    );
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Videollamada')),
      body: Stack(
        children: [
          Center(child: _buildRemoteVideo()),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(child: _buildLocalVideo()),
            ),
          ),
          // Botones de control centrados en la parte inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Turn On/OFF camara button
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.isCameraOff,
                    builder: (_, cameraOff, __) {
                      return _buildControlButton(
                        icon: cameraOff ? Icons.videocam_off : Icons.videocam,
                        color: cameraOff ? Colors.orange : Colors.green,
                        onPressed: _controller.toggleCamera,
                        heroTag: 'toggle-camera',
                      );
                    },
                  ),
                  const SizedBox(width: 16),

                  // Mute and unmute button
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.isMuted,
                    builder: (_, muted, __) {
                      return _buildControlButton(
                        icon: muted ? Icons.mic_off : Icons.mic,
                        color: muted ? Colors.orange : Colors.green,
                        onPressed: _controller.toggleMute,
                        heroTag: 'toggle-mic',
                      );
                    },
                  ),
                  const SizedBox(width: 16),

                  // Camera switch button
                  _buildControlButton(
                    icon: Icons.cameraswitch,
                    color: Colors.blueGrey,
                    onPressed: _controller.switchCamera,
                    heroTag: 'switch-camera',
                  ),
                  const SizedBox(width: 16),

                  // Hang Up Button
                  _buildControlButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    onPressed: () async {
                      await _controller.leave();
                      if (context.mounted) Navigator.pop(context);
                    },
                    heroTag: 'hangup',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalVideo() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.localUserJoined,
      builder: (_, joined, __) {
        return joined
            ? AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _controller.engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              )
            : const CircularProgressIndicator();
      },
    );
  }

  Widget _buildRemoteVideo() {
    return ValueListenableBuilder<int?>(
      valueListenable: _controller.remoteUid,
      builder: (_, uid, __) {
        if (uid != null) {
          return AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _controller.engine,
              canvas: VideoCanvas(uid: uid),
              connection: RtcConnection(channelId: widget.channelName),
            ),
          );
        } else {
          return const Text('Esperando a otro usuario...');
        }
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String heroTag,
  }) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: color,
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }
}
