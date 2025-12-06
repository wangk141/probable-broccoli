import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/message.dart';
import 'screens/messages_screen.dart';
import 'screens/internal_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Message>('messages');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Support Chat',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MessagesScreen(),
        '/dashboard': (context) => const InternalDashboardScreen(),
      },
    );
  }
}