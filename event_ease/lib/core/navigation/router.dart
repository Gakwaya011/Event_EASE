// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/singl_event.dart';
import '../../features/auth/presentation/pages/otp.dart';
import '../../features/auth/presentation/pages/profile.dart';
import '../../features/auth/presentation/pages/dashboard.dart';
import '../../features/auth/presentation/pages/create_event.dart';
import '../../features/auth/presentation/pages/splash.dart';
import '../../features/auth/presentation/pages/onboarding.dart';

final GoRouter router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(path: '/splash',
      builder: (context, state) => const SplashPage()
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OTPConfirmationPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/create_event',
      builder: (context, state) => const CreateEventPage(),
    ),
    GoRoute(
      path: '/single_event',
      builder: (context, state) => const SinglEvent(),
    ),
    GoRoute(path: '/onboarding',
      builder: (context, state) => const OnboardingScreen()
    )
  ],
);
