import 'package:aplikacja_sportowa/dodawanie_do_bazy.dart';
import 'package:aplikacja_sportowa/drugi_widok.dart';
import 'package:aplikacja_sportowa/wyswietlanie_z_bazy.dart';
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
  List<Map<String, dynamic>> daneZBazy = [];
  //! Godziny
  TimeOfDay? godzina_rozpoczecia = TimeOfDay.now();
  TimeOfDay? godzina_zakonczenia = TimeOfDay.now();

  //! Reszta wartosci
  String rodzaj_aktywnosci = "chodzenie";
  int czas_trwania = 0;
  int pokonany_dystans = 0;

  //! Metoda obliczajaca czas treningu
  String czasTreningu(
    TimeOfDay? _godzina_rozpoczecia,
    TimeOfDay? _godzina_zakonczenia,
  ) {
    if (_godzina_rozpoczecia == null || _godzina_zakonczenia == null) {
      return "Brak danych";
    }

    //? Godzina rozpoczecia (godziny i minuty)
    final _godzina_rozpoczeniaTime = Duration(
      hours: _godzina_rozpoczecia.hour,
      minutes: _godzina_rozpoczecia.minute,
    );

    //? Godzina zakonczenia (godziny i minuty)
    final godzina_zakonczeniaTime = Duration(
      hours: _godzina_zakonczenia.hour,
      minutes: _godzina_zakonczenia.minute,
    );

    final difference = godzina_zakonczeniaTime - _godzina_rozpoczeniaTime;
    czas_trwania = difference.inMinutes; //? obliczanie czasu trwania treningu

    if (czas_trwania < 0) {
      //? Jesli czas treningu jest mniejszy od zera jest nieprawidlowy
      return "Godziny treningu sa nieprawidlowe!";
    }
    return "Czas treningu: $czas_trwania minut,";
  }

  Future<void> aktualizacjaDanych(BuildContext context) async {
    daneZBazy = await odczytajDane();
    print(daneZBazy);
    setState(
        () {}); // Wywołanie setState spowoduje ponowną budowę widoku z nowymi danymi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikacja sportowa'), //? Tytuł
      ),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(16.0), //? Margines o wartosci 16 pikseli
          child: Column(
            children: [
              const Text(
                "Dodaj nowa aktywnosc",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              //* Linia 1
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, //? wyśrodkowane wzdłuż osi poziomej
                children: [
                  const Text(
                    "Rodzaj aktywności: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  //! Lista z wybranymi itemami
                  DropdownButton<String>(
                    value:
                        rodzaj_aktywnosci, //? Wybrana wartosc bedzie podpisana pod rodzaj_aktywnosci
                    onChanged: (String? nowaWartosc) {
                      setState(
                        () {
                          rodzaj_aktywnosci = nowaWartosc!;
                        },
                      );
                    },
                    //? itemy
                    items: <String>[
                      'chodzenie',
                      'bieganie',
                      'rower',
                      'pływanie',
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
                mainAxisAlignment: MainAxisAlignment
                    .center, //? wyśrodkowane wzdłuż osi poziomej
                children: [
                  const Text(
                    "Godzina rozpoczecia i zakonczenia treningu: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  //! Przycisk
                  ElevatedButton(
                    onPressed: () {
                      //? Wywoluje metode
                      _godzinaRozpoczecia(context);
                    },
                    //? Wyswietla godzine
                    child: Text(godzina_rozpoczecia != null
                        ? '${godzina_rozpoczecia!.hour}:${godzina_rozpoczecia!.minute}'
                        : 'Godzina rozpoczecia'),
                  ),
                  const Text(
                    " - ",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  //! Przycisk
                  ElevatedButton(
                    onPressed: () {
                      //? Wywoluje metode
                      _godzinaZakonczenia(context);
                    },
                    //? Wyswietla godzine
                    child: Text(godzina_zakonczenia != null
                        ? '${godzina_zakonczenia!.hour}:${godzina_zakonczenia!.minute}'
                        : 'Godzina zakonczenia'),
                  ),
                ],
              ),
              Text(
                //? Wywoluje metode
                czasTreningu(
                  godzina_rozpoczecia,
                  godzina_zakonczenia,
                ),
                style: const TextStyle(fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0), //? Marginesy
                //* Linia 3
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
                            pokonany_dystans =
                                int.tryParse(value)!; //? Konwertowanie na int
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Dystans', //? Napis na polu
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
              //! Przycisk
              ElevatedButton(
                onPressed: () {
                  //? Wrunki
                  if (godzina_rozpoczecia == null ||
                      godzina_zakonczenia == null ||
                      pokonany_dystans == 0 ||
                      czas_trwania < 0 ||
                      rodzaj_aktywnosci.isEmpty) {
                    //? To co zostanie wyswietlone jesli warunki beda spelnione (okno)
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Błąd'),
                          content:
                              const Text('Uzupełnij wszystkie wymagane pola.'),
                          actions: [
                            //! Przycisk
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
                    //? jesli warunki nie beda spelnione wywoluje metode
                    Timestamp timestamp = timeOfDayToTimestamp(
                      godzina_rozpoczecia!,
                    );
                    //? wywoluje metode ktora dodaje dan do bazy danych
                    dodajDane(
                      czas_trwania,
                      pokonany_dystans,
                      timestamp,
                      rodzaj_aktywnosci,
                    );
                    aktualizacjaDanych(context);
                    //? przechodzi do drugiego widoku
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DrugiWidok(
                          daneZBazy: daneZBazy,
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                    print(daneZBazy);
                  }
                },
                child: const Text('Dodaj trening'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: () {
            aktualizacjaDanych(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => DrugiWidok(
                  daneZBazy: daneZBazy,
                ),
              ),
              (route) => route.isFirst,
            );
          },
          child: const Text("Przejdz do statystyk"),
        ),
      ),
    );
  }

  //! Metoda konwertujaca TimeOdDay na Timestamp
  Timestamp timeOfDayToTimestamp(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
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
