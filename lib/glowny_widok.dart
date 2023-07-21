import 'package:aplikacja_sportowa/routes.dart';
import 'package:flutter/material.dart';

//! Pierwszy widok
class GlownyWidok extends StatefulWidget {
  const GlownyWidok({super.key});

  @override
  State<GlownyWidok> createState() => _GlownyWidokState();
}

class _GlownyWidokState extends State<GlownyWidok> {
  //! Godziny
  TimeOfDay? godzina_rozpoczecia = TimeOfDay.now();
  TimeOfDay? godzina_zakonczenia = TimeOfDay.now();
  late final int id = 1;
  String rodzaj_aktywnosci = "chodzenie";
  int czas_trwania = 0;
  late final int pokonany_dystans;

  String czasTreningu(
      TimeOfDay? _godzina_rozpoczecia, TimeOfDay? _godzina_zakonczenia) {
    if (_godzina_rozpoczecia == null || _godzina_zakonczenia == null) {
      return "Brak danych";
    }

    final _godzina_rozpoczeniaTime = Duration(
      hours: _godzina_rozpoczecia.hour,
      minutes: _godzina_rozpoczecia.minute,
    );
    final godzina_zakonczeniaTime = Duration(
      hours: _godzina_zakonczenia.hour,
      minutes: _godzina_zakonczenia.minute,
    );

    final difference = godzina_zakonczeniaTime - _godzina_rozpoczeniaTime;

    czas_trwania = difference.inMinutes;

    if (czas_trwania < 0) {
      return "Godziny treningu sa nieprawidlowe!";
    }
    return "Czas treningu: $czas_trwania minut,";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikacja sportowa'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Dodaj nowa aktywnosc",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Rodzaj aktywności: ",
                  style: TextStyle(fontSize: 20),
                ),
                DropdownButton<String>(
                  value: rodzaj_aktywnosci,
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        rodzaj_aktywnosci = newValue!;
                      },
                    );
                  },
                  items: <String>['chodzenie', 'bieganie', 'rower', 'pływanie']
                      .map(
                    (String opcja) {
                      return DropdownMenuItem<String>(
                        value: opcja,
                        child: Text(opcja),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),

            // Wybór czasu trwania
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Godzina rozpoczecia i zakonczenia trenungu: ",
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                  onPressed: () {
                    _godzinaRozpoczecia(context);
                  },
                  child: Text(godzina_rozpoczecia != null
                      ? '${godzina_rozpoczecia!.hour}:${godzina_rozpoczecia!.minute}'
                      : 'Godzina rozpoczecia'),
                ),
                const Text(
                  " - ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    _godzinaZakonczenia(context);
                  },
                  child: Text(godzina_zakonczenia != null
                      ? '${godzina_zakonczenia!.hour}:${godzina_zakonczenia!.minute}'
                      : 'Godzina zakonczenia'),
                ),
              ],
            ),
            Text(
              czasTreningu(
                godzina_rozpoczecia,
                godzina_zakonczenia,
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const Text(
              "Rodzaj aktywnosci: ",
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, drugiWidok); // Przenosi na drugi widok
              },
              child: const Text('Dodaj trening'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _godzinaRozpoczecia(BuildContext context) async {
    final TimeOfDay? wybranaGodzinaTemp = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (wybranaGodzinaTemp != null &&
        wybranaGodzinaTemp != godzina_rozpoczecia) {
      setState(() {
        godzina_rozpoczecia = wybranaGodzinaTemp;
      });
    }
  }

  Future<void> _godzinaZakonczenia(BuildContext context) async {
    final TimeOfDay? wybranaGodzinaTemp = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (wybranaGodzinaTemp != null &&
        wybranaGodzinaTemp != godzina_zakonczenia) {
      setState(() {
        godzina_zakonczenia = wybranaGodzinaTemp;
      });
    }
  }
}
