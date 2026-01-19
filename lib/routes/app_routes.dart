import 'package:BloomSpace/features/auth/pages/forgot_password_page.dart';
import 'package:BloomSpace/features/auth/pages/login_page.dart';
import 'package:BloomSpace/features/auth/pages/signup_page.dart';
import 'package:BloomSpace/features/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import '../features/home/pages/home_page.dart';
import '../features/community/pages/community_page.dart';
// DISABLED: 1-on-1 Chat Feature
// import '../features/chat1_1/pages/chat1_1_page.dart';
import '../features/counseling/pages/counseling_page.dart';
import '../features/resources/pages/resources_page.dart';

class AppRoutes {
  static const home = '/home';
  static const community = '/community';
  // DISABLED: 1-on-1 Chat Feature
  // static const chat1_1 = '/chat1_1';
  static const counseling = '/counseling';
  static const resources = '/resources';
  static const profile = '/profile';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomePage(),
        community: (context) => const CommunityPage(),
        // DISABLED: 1-on-1 Chat Feature
        // chat1_1: (context) => const Chat1_1Page(),
        counseling: (context) => const CounselingPage(),
        resources: (context) => const ResourcesPage(),
        profile: (context) => const ProfilePage(),
        login: (context) => const LoginPage(),
        signup: (context) => const SignupPage(),
        forgotPassword: (context) => const ForgotPasswordPage(),
      };
}
