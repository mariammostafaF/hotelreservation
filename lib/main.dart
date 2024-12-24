import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import Firebase options
import 'signup.dart';
import 'login.dart';
import 'dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Firebase is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Use platform-specific Firebase options
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripAdvisor Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Set initial screen as login
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments
              as Map<String, dynamic>?; // Cast to Map<String, dynamic>

          if (args != null) {
            final username = args['username']; // Get username
            final reservationDetails = args['reservationDetails'] ??
                {}; // Get reservation details or empty map

            return MaterialPageRoute(
              builder: (context) => DashboardScreen(
                username: username,
                reservationDetails: reservationDetails,
              ),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => DashboardScreen(
                username:
                    'Guest', // Default to 'Guest' if no username is passed
                reservationDetails: {},
              ),
            );
          }
        }
        return null; // Default route handling
      },
    );
  }
}
