import 'package:elimapass/screens/loading_screen.dart';
import 'package:elimapass/services/notification_service.dart';
import 'package:elimapass/util/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0XFF223E68),
);
var darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0XFF223E68),
  brightness: Brightness.dark,
  surface: const Color.fromARGB(255, 31, 31, 44),
);

void main() async {
  AppNotifier().notified = false;
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eLimaPass',
      theme: ThemeData(
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
      ).copyWith(
        scaffoldBackgroundColor: darkColorScheme.surface,
      ),
      themeMode: ThemeMode.system,
      home: LoadingScreen(),
    );
  }
}
