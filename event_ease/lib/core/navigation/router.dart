import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import the pages
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/singl_event.dart';
import '../../features/auth/presentation/pages/otp.dart';
import '../../features/auth/presentation/pages/profile.dart';
import '../../features/auth/presentation/pages/dashboard.dart';
import '../../features/auth/presentation/pages/create_event.dart';
import '../../features/auth/presentation/pages/splash.dart';
import '../../features/auth/presentation/pages/onboarding.dart';
import '../../features/auth/presentation/pages/edit_event.dart';
import '../../features/auth/presentation/pages/all_events.dart';
import '../../features/auth/presentation/pages/reset_password.dart';
import '../../features/auth/presentation/pages/otp.dart';


// import the providers
import 'package:provider/provider.dart';
import '../../../../core/providers/event_provider.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash',
      builder: (context, state) => const SplashPage()
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) =>  OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/reset',
      builder: (context,state) =>  ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
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
      path: '/single_event/:eventId',
      builder: (context, state) {
        String eventId = state.pathParameters['eventId']!;
        return SinglEvent(eventId: eventId);
      },
    ),
    GoRoute(
      path: '/all_events',
      builder: (context, state) => const AllEventsPage(),
    ),
    GoRoute(
      path: '/edit_event/:eventId',
      builder: (context, state) {
        String eventId = state.pathParameters['eventId']!;

        // Fetch the event by ID
        final eventProvider = Provider.of<EventProvider>(context, listen: false);
        final event = eventProvider.getEventById(eventId);

        if (event == null) {
          // You can show a loading spinner or error screen if the event is not found
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return EditEventPage(event: event); // Pass the fetched event
      },
    ),
    GoRoute(path: '/onboarding',
      builder: (context, state) => const OnboardingScreen()
    )
  ],
);
