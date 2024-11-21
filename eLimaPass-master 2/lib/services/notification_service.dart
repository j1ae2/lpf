import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  PermissionStatus status = await Permission.notification.status;

  if (!status.isGranted) {
    status = await Permission.notification.request();
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('noti_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'your channel id', // ID del canal
    'your channel name', // Nombre del canal
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  // Mostrar notificación con título y cuerpo personalizados
  await flutterLocalNotificationsPlugin.show(
    0, // ID de la notificación
    title, // Título de la notificación (pasado como parámetro)
    body, // Cuerpo de la notificación (pasado como parámetro)
    notificationDetails,
  );
}
