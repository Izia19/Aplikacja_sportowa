import 'package:aplikacja_sportowa/drugi_widok.dart';
import 'package:aplikacja_sportowa/glowny_widok.dart';
import 'package:aplikacja_sportowa/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GlownyWidok(),
      routes: {
        drugiWidok: (context) => const DrugiWidok(),
        glownyWidok: (context) => const GlownyWidok(),
      },
    );
  }
}
