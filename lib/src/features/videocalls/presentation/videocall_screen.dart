import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/call_session.dart';
import '../../../routing/app_router.dart';
import '../application/videocall_controller.dart';

class VideoCallScreen extends StatefulWidget {
  final String token;
  final String channel;
  final String fullname;
  final int? idVideocall;

  const VideoCallScreen({
    super.key,
    required this.token,
    required this.channel,
    required this.fullname,
    required this.idVideocall,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late VideoCallController _controller;
  bool _isLoading = true;

  Timer? _timer;
  Duration _callDuration = Duration.zero;

  bool _isSwapped = false;

  @override
  void initState() {
    super.initState();
    CallSession.isInVideoCallScreen = true;
    WakelockPlus.enable();

    _controller = VideoCallController(
      token: widget.token,
      channelName: widget.channel,
    );

    _initialize();
  }

  Future<void> _initialize() async {
    debugPrint('🔐 Token: ${widget.token}');
    debugPrint('📡 Channel: ${widget.channel}');
    try {
      await _controller.initialize();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(LocaleKeys
                  .videocalls_videocall_screen_error_init_call
                  .tr(args: [e.toString()]))),
        );
        Navigator.of(context).pop();
      }
      return;
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _startCallTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.leave();
    WakelockPlus.disable();
    CallSession.isInVideoCallScreen = false;
    super.dispose();
  }

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDuration += const Duration(seconds: 1);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            LocaleKeys.videocalls_videocall_screen_title.tr(),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
      body: Stack(
        children: [
          Center(child: _isSwapped ? _buildLocalVideo() : _buildRemoteVideo()),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isSwapped = !_isSwapped;
                });
              },
              child: SizedBox(
                width: 120,
                height: 160,
                child: Center(
                    child:
                        _isSwapped ? _buildRemoteVideo() : _buildLocalVideo()),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.fullname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatDuration(_callDuration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.isLocalVideoMuted,
                    builder: (_, isMuted, __) {
                      return _buildControlButton(
                        icon: isMuted ? Icons.videocam_off : Icons.videocam,
                        color: Colors.blueGrey,
                        onPressed: () => _controller.toggleMuteVideo(),
                        heroTag: 'toggle-camera',
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.isLocalAudioMuted,
                    builder: (_, isMuted, __) {
                      return _buildControlButton(
                        icon: isMuted ? Icons.mic_off : Icons.mic,
                        color: Colors.blueGrey,
                        onPressed: () => _controller.toggleMuteAudio(),
                        heroTag: 'toggle-mic',
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildControlButton(
                    icon: Icons.cameraswitch,
                    color: Colors.blueGrey,
                    onPressed: () => _controller.switchCamera(),
                    heroTag: 'switch-camera',
                  ),
                  const SizedBox(width: 16),
                  _buildControlButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(LocaleKeys
                              .videocalls_videocall_screen_confirm_end_call_title
                              .tr()),
                          content: Text(LocaleKeys
                              .videocalls_videocall_screen_confirm_end_call_content
                              .tr()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(LocaleKeys
                                  .videocalls_videocall_screen_cancel
                                  .tr()),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(LocaleKeys
                                  .videocalls_videocall_screen_end_call
                                  .tr()),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await _controller.leave();

                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed(
                            AppRouter.reviewRoute,
                            arguments: widget.idVideocall,
                          );
                        }
                      }
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
      valueListenable: _controller.isLocalUserJoined,
      builder: (_, joined, __) {
        if (!joined) {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          );
        }
        return ValueListenableBuilder<bool>(
          valueListenable: _controller.isLocalVideoMuted,
          builder: (_, muted, __) {
            if (!muted) {
              return AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _controller.engine,
                  canvas: const VideoCanvas(
                    uid: 0,
                  ),
                ),
              );
            } else {
              return Container(
                color: Colors.grey.shade800,
                child: const Center(
                  child:
                      Icon(Icons.videocam_off, size: 48, color: Colors.white),
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
      valueListenable: _controller.remoteUserId,
      builder: (_, uid, __) {
        if (uid == null) {
          return _buildPlaceholderView(
              LocaleKeys.videocalls_videocall_screen_waiting_other_user.tr());
        }
        return ValueListenableBuilder<bool>(
          valueListenable: _controller.isRemoteVideoAvailable,
          builder: (_, available, __) {
            if (available) {
              return AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _controller.engine,
                  canvas: VideoCanvas(uid: uid),
                  connection: RtcConnection(channelId: widget.channel),
                ),
              );
            } else {
              return _buildPlaceholderView(LocaleKeys
                  .videocalls_videocall_screen_remote_camera_off
                  .tr());
            }
          },
        );
      },
    );
  }

  Widget _buildPlaceholderView(String message) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
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
