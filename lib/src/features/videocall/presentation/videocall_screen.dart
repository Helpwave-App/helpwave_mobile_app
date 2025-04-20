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
          // Hang Up Button
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () async {
                await _controller.leave();
                if (context.mounted) Navigator.pop(context);
              },
              child: const Icon(Icons.call_end, color: Colors.white),
            ),
          ),
          // Camera switch button
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'switch-camera',
              backgroundColor: Colors.blueGrey,
              onPressed: () => _controller.switchCamera(),
              child: const Icon(Icons.cameraswitch, color: Colors.white),
            ),
          ),
          // Mute and unmute button
          Positioned(
            bottom: 40,
            left: 20,
            child: ValueListenableBuilder<bool>(
              valueListenable: _controller.isMuted,
              builder: (_, muted, __) {
                return FloatingActionButton(
                  heroTag: 'mute-audio',
                  backgroundColor: muted ? Colors.orange : Colors.green,
                  onPressed: _controller.toggleMute,
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                );
              },
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
}
