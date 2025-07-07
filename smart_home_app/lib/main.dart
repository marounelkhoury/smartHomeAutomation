import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth_provider.dart';
import 'providers/smart_plug_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'core/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();
    print("Firebase Initialized"); // This will print if Firebase is initialized successfully
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  final authProvider = AuthProvider();
  await authProvider.checkLoginStatus();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => SmartPlugProvider()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: true);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home Automation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      ),
      home: auth.isLoading
          ? Center(child: CircularProgressIndicator())
          : auth.isAuthenticated
          ? DashboardScreen()
          : LoginScreen(),
    );
  }
}
