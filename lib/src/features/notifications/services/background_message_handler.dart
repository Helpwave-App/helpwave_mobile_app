import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../common/utils/firebase/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('📩 Background Notification received: ${message.data}');

  final data = message.data;
  final type = data['type'];

  switch (type) {
    case 'help_request':
      await _handleBackgroundHelpRequest(data, message);
      break;
    case 'videocall_start':
      await _handleBackgroundVideocallStart(data, message);
      break;
    case 'videocall_end':
      await _handleBackgroundVideocallEnd(data, message);
      break;
    default:
      print('🔔 Unknown background notification type: $type');
      await _showGenericNotification(message);
  }
}

Future<void> _handleBackgroundHelpRequest(
  Map<String, dynamic> data,
  RemoteMessage message,
) async {
  print('🤝 Handling background help request');

  final skill = data['skill'] ?? 'Unknown Skill';
  final name = data['name'] ?? 'Unknown';
  final lastname = data['lastname'] ?? '';
  final fullname = '$name $lastname'.trim();

  await _showLocalNotification(
    id: 1,
    title: 'Help Request',
    body: '$fullname needs help with $skill',
    payload: 'help_request',
  );
}

Future<void> _handleBackgroundVideocallStart(
  Map<String, dynamic> data,
  RemoteMessage message,
) async {
  print('📞 Handling background videocall start');

  final name = data['name'] ?? 'Unknown';
  final lastname = data['lastname'] ?? '';
  final fullname = '$name $lastname'.trim();

  await _showLocalNotification(
    id: 2,
    title: 'Video Call Started',
    body: 'Video call with $fullname has started',
    payload: 'videocall_start',
  );
}

Future<void> _handleBackgroundVideocallEnd(
  Map<String, dynamic> data,
  RemoteMessage message,
) async {
  print('📴 Handling background videocall end');

  await _showLocalNotification(
    id: 3,
    title: 'Video Call Ended',
    body: 'The video call has ended',
    payload: 'videocall_end',
  );
}

Future<void> _showGenericNotification(RemoteMessage message) async {
  print('🔔 Showing generic background notification');

  await _showLocalNotification(
    id: 0,
    title: message.notification?.title ?? 'HelpWave',
    body: message.notification?.body ?? 'You have a new notification',
    payload: 'generic',
  );
}

Future<void> _showLocalNotification({
  required int id,
  required String title,
  required String body,
  String? payload,
}) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'helpwave_channel_id',
    'HelpWave Notifications',
    channelDescription: 'Notifications for HelpWave app',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  try {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
    print('✅ Local notification shown successfully');
  } catch (e) {
    print('❌ Error showing local notification: $e');
  }
}
