import 'package:flutter/material.dart';
import 'package:club8/screens/Home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:club8/screens/Second.dart';


void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ExperienceScreen(),
      routes: {
        '/home': (context) => const ExperienceScreen(),
        '/second': (context) => const Second(),
      }
    );
  }
}
