import 'package:aplikacja_sportowa/drugi_widok.dart';
import 'package:aplikacja_sportowa/glowny_widok.dart';
import 'package:aplikacja_sportowa/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDjjJkmkHWF_CJanf4QTiMKY_0pCgmiUyI",
      appId: "1:525336553036:android:614bead43c8c7efae576e9",
      messagingSenderId: "525336553036",
      projectId: "aplikacja-sportowa-ac07c",
      databaseURL:
          "https://aplikacja-sportowa-ac07c-default-rtdb.europe-west1.firebasedatabase.app/",
      storageBucket: "gs://aplikacja-sportowa-ac07c.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GlownyWidok(),
      routes: {
        drugiWidok: (context) => const DrugiWidok(),
        glownyWidok: (context) => const GlownyWidok(),
      },
    );
  }
}
