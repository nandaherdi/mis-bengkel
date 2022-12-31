import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/login/login_page.dart';
import 'auth/reset_password/new_password_page.dart';
import 'bottom_navigation_bar.dart';
import 'mra_bottom_navigation_bar.dart';
import 'pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Supabase.initialize(
    url: 'url',
    anonKey:
        'anonKey',
  );

  AwesomeNotifications().initialize(
    'resource://drawable/logo2',
    [
      NotificationChannel(
        channelKey: 'scheduled_reminder_channel',
        channelName: 'Scheduled Reminder Service Notifications',
        defaultColor: Colors.teal,
        locked: true,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        channelDescription:
            'Reminder ke pelanggan untuk servis lagi yang datanya diambil dari database',
      ),
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginPage(),
        '/navbar': (_) => BottNavBar(),
        '/mranavbar': (_) => MRABottNavBar(),
        '/newpassword': (_) => NewPasswordPage(),
      },
    );
  }
}
