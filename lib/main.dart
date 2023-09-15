import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'features/homepage/presentation/pages/home_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the default Firebase options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the Flutter app by creating an instance of `MyApp`.
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts', // The title displayed in the app's title bar.
      debugShowCheckedModeBanner: false, // Hide the debug banner in release mode.
      theme: ThemeData(
        fontFamily: 'QuickSand', // Set the default font family.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple, // Primary color seed.
          brightness: Brightness.dark, // Use a dark theme.
        ),
        useMaterial3: true, // Enable Material 3 design features.
      ),
      home: const HomePage(), // Set the initial page of the app to `HomePage`.
    );
  }
}
