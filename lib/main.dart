import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Import local files
import 'providers/auth_provider.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/onboarding_page.dart';
import 'screens/public_profile_page.dart';
import 'screens/profile_editor_page.dart';
import 'screens/share_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (User will need to provide their own URL and Key later)
  await Supabase.initialize(
    url: 'https://your-project-url.supabase.co',
    anonKey: 'your-anon-key',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
      ],
      child: const ECardApp(),
    ),
  );
}

class ECardApp extends StatelessWidget {
  const ECardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LandingPage()),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
        GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingPage()),
        GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),
        GoRoute(path: '/edit', builder: (context, state) => const ProfileEditorPage()),
        GoRoute(path: '/share', builder: (context, state) => const ShareProfilePage()),
        GoRoute(path: '/:username', builder: (context, state) => PublicProfilePage(username: state.pathParameters['username']!)),
      ],
      redirect: (context, state) {
        final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
        final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
        
        if (!authProvider.isAuthenticated && !loggingIn && state.matchedLocation != '/' && !state.matchedLocation.startsWith('/@')) {
          // Allow public profile access without auth
          if (state.pathParameters.containsKey('username')) return null;
          return '/login';
        }
        
        if (authProvider.isAuthenticated && loggingIn) {
          return '/dashboard';
        }
        
        return null;
      },
    );

    return MaterialApp.router(
      title: 'E-Card App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFFA855F7),
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
