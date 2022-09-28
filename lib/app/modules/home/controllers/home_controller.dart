import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomeController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final messagingStyleInformation = MessagingStyleInformation(
    const Person(
      important: true,
      name: "title",
    ),
    conversationTitle: "title",
    groupConversation: true,
    messages: [
      Message(
        "msg.content",
        DateTime.now().toLocal(),
        const Person(
          important: true,
          name: "msg.senderName",
        ),
      ),
    ],
  );

  @override
  void onInit() async {
    super.onInit();
    initOneSignal();
    await initLocalNotifi();
  }

  void initOneSignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.error, OSLogLevel.error);
    OneSignal.shared.setAppId("97bc823f-9603-4fb2-ba28-88186b87d9bf");
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      sendNotif();
      event.complete(null);
    });

  }

  Future initLocalNotifi() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwom =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwom,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      if (details.payload != null) {}
    });
  }

  void sendNotif() async {
    final androidNotificationDetails = AndroidNotificationDetails(
      "weellu_msg_notification", "Message_notification",
      channelDescription: "weellu_msg_notification_d",
      importance: Importance.max,
      priority: Priority.max,
      ticker: "title",
      styleInformation: messagingStyleInformation,
      groupKey: "roomId",
      setAsGroupSummary: true,
      actions: [
        const AndroidNotificationAction(
          "1",
          "Make as read",
        ),
        const AndroidNotificationAction(
          "2",
          "Reply",
          allowGeneratedReplies: true,
          inputs: [
            AndroidNotificationActionInput(
              label: "you",
            )
          ],
        ),
      ],
      // subText: AppConstants.appName,
    );
    const iosDetails = DarwinNotificationDetails(
      badgeNumber: 1,
      presentSound: true,
      threadIdentifier: "msg.roomId",
      presentBadge: true,
      //subtitle: AppConstants.appName,
    );
    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      123,
      "msg.senderName",
      "msg.content",
      notificationDetails,
      payload: "msg.roomId",
    );
  }
}
