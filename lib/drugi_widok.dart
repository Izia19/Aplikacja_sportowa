import 'package:flutter/material.dart';

//! Pierwszy widok
class DrugiWidok extends StatelessWidget {
  const DrugiWidok({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aplikacja sportowa',
        ), //? napis na górnym panelu (app bar)
      ),
      body: const Center(
        //? pozwala na układanie elementów w kolumnie
        child: Column(
          children: [
            Text(
              "Cos tu bedzie",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            //? przycisk który przekierowuje do drugiego widoku
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const DrugiWidok(),
            //       ),
            //     );
            //   },
            //   child: const Text(
            //     'Przejdź do drugiego widoku', //? napis na przycisku
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
