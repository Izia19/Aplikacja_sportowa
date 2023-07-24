import 'package:aplikacja_sportowa/dodawanie_do_bazy.dart';
import 'package:aplikacja_sportowa/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int pokonany_dystans = 0;

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Dodaj nowa aktywnosc",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              //* Linia 1
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Rodzaj aktywności: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  DropdownButton<String>(
                    value: rodzaj_aktywnosci,
                    onChanged: (String? nowaWartosc) {
                      setState(
                        () {
                          rodzaj_aktywnosci = nowaWartosc!;
                        },
                      );
                    },
                    items: <String>[
                      'chodzenie',
                      'bieganie',
                      'rower',
                      'pływanie'
                    ].map(
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
              //* Linia 2
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Godzina rozpoczecia i zakonczenia treningu: ",
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
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Row(
                  children: [
                    const Text(
                      "Przebyty dystans: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            pokonany_dystans = int.tryParse(value)!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Dystans',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Text(
                      " metrów ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (godzina_rozpoczecia == null ||
                      godzina_zakonczenia == null ||
                      pokonany_dystans == 0 ||
                      czas_trwania < 0 ||
                      rodzaj_aktywnosci.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Błąd'),
                          content:
                              const Text('Uzupełnij wszystkie wymagane pola.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Timestamp timestamp = timeOfDayToTimestamp(
                      godzina_rozpoczecia!,
                    );
                    dodajDane(
                      czas_trwania,
                      pokonany_dystans,
                      timestamp,
                      rodzaj_aktywnosci,
                    );
                    Navigator.pushNamed(
                      context,
                      drugiWidok,
                    );
                  }
                },
                child: const Text('Dodaj trening'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Timestamp timeOfDayToTimestamp(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return Timestamp.fromDate(dateTime);
  }

  //! Metoda do wybierania godziny rozpoczecia
  Future<void> _godzinaRozpoczecia(BuildContext context) async {
    final TimeOfDay? wybranaGodzinaTemp = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (wybranaGodzinaTemp != null &&
        wybranaGodzinaTemp != godzina_rozpoczecia) {
      setState(
        () {
          godzina_rozpoczecia = wybranaGodzinaTemp;
        },
      );
    }
  }

  //! Metoda do wybierania godziny zakonczenia
  Future<void> _godzinaZakonczenia(BuildContext context) async {
    final TimeOfDay? wybranaGodzinaTemp = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (wybranaGodzinaTemp != null &&
        wybranaGodzinaTemp != godzina_zakonczenia) {
      setState(
        () {
          godzina_zakonczenia = wybranaGodzinaTemp;
        },
      );
    }
  }
}
