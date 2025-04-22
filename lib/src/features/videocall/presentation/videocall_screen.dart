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
                  // Botón de cámara ON/OFF
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.isCameraMuted,
                    builder: (_, cameraOff, __) {
                      return _buildControlButton(
                        icon: cameraOff ? Icons.videocam_off : Icons.videocam,
                        color: cameraOff ? Colors.blueGrey : Colors.blueGrey,
                        onPressed: _controller.toggleCamera,
                        heroTag: 'toggle-camera',
                      );
                    },
                  ),
                  const SizedBox(width: 16),

                  // Botón de mute/unmute micrófono
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.isMuted,
                    builder: (_, muted, __) {
                      return _buildControlButton(
                        icon: muted ? Icons.mic_off : Icons.mic,
                        color: muted ? Colors.blueGrey : Colors.blueGrey,
                        onPressed: _controller.toggleMute,
                        heroTag: 'toggle-mic',
                      );
                    },
                  ),
                  const SizedBox(width: 16),

                  // Botón para cambiar cámara
                  _buildControlButton(
                    icon: Icons.cameraswitch,
                    color: Colors.blueGrey,
                    onPressed: _controller.switchCamera,
                    heroTag: 'switch-camera',
                  ),
                  const SizedBox(width: 16),

                  // Botón para colgar videollamada
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
        if (!joined) return const CircularProgressIndicator();

        return ValueListenableBuilder<bool>(
          valueListenable: _controller.isCameraMuted,
          builder: (_, muted, __) {
            if (!muted) {
              return AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _controller.engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              );
            } else {
              return Container(
                color: Colors.grey.shade800,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        padding: const EdgeInsets.all(24),
                        child: const Icon(Icons.person,
                            size: 48, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Test User",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildRemoteVideo() {
    return ValueListenableBuilder<int?>(
      valueListenable: _controller.remoteUid,
      builder: (_, uid, __) {
        if (uid != null) {
          return ValueListenableBuilder<bool>(
            valueListenable: _controller.isRemoteCameraOn,
            builder: (_, isOn, __) {
              if (isOn) {
                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: _controller.engine,
                    canvas: VideoCanvas(uid: uid),
                    connection: RtcConnection(channelId: widget.channelName),
                  ),
                );
              } else {
                // Cámara del usuario remoto está apagada
                return _buildPlaceholderView();
              }
            },
          );
        } else {
          return const Text('Esperando a otro usuario...');
        }
      },
    );
  }

  Widget _buildPlaceholderView() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Test User',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
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
