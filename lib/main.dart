import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url:
        'https://emmrljybzwllxoiatfiy.supabase.co', // Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVtbXJsanliendsbHhvaWF0Zml5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5ODc2NjgsImV4cCI6MjA3OTU2MzY2OH0.blUDDD1jRzsowcdaSX8dqLMu044vrwiZEY3yDxTS9J8', // Replace with your Supabase anon key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAMUBloomSpace',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login, // Start at login page
      routes: AppRoutes.routes,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter', // Optional: Add a nice font
      ),
    );
  }
}
