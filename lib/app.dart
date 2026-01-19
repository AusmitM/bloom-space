import 'package:BloomSpace/features/home/pages/home_page.dart';
import 'package:BloomSpace/routes/app_routes.dart';
import 'package:flutter/material.dart';
// import 'routes/app_routes.dart';

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom Space',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {AppRoutes.home: (context) => const HomePage()},
    );
  }
}
