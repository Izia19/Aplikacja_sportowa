// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:aplikacja_sportowa/usun_modyfikuj_dane.dart';
import 'package:aplikacja_sportowa/wyswietlanie_z_bazy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrugiWidok extends StatefulWidget {
  final List<Map<String, dynamic>> daneZBazy;
  const DrugiWidok({Key? key, required this.daneZBazy}) : super(key: key);

  @override
  State<DrugiWidok> createState() => _DrugiWidokState();
}

class _DrugiWidokState extends State<DrugiWidok> {
  DateTime teraz = DateTime.now();
  List<Map<String, dynamic>> _zaktualizowaneDane = []; // Zmienna stanu

  @override
  void initState() {
    super.initState();
    teraz = DateTime.now();
    aktualizujDane();
  }

  Future<void> aktualizujDane() async {
    List<Map<String, dynamic>> zaktualizowaneDane = await odczytajDane();
    setState(() {
      _zaktualizowaneDane =
          zaktualizowaneDane; // Zaktualizowanie danych w widoku
    });
  }

  void _showEditDialog(
    BuildContext context,
    String documentId,
    int czas_trwania,
    int dystans,
    String rodzaj_aktywnosci,
    String formattedDate,
  ) async {
    // Pobierz dane do edycji z jakiegoś źródła (np. z bazy danych)
    String _rodzaj_aktywnosci = rodzaj_aktywnosci;
    String _czas_trwania = czas_trwania.toString();
    String _dystans = dystans.toString();
    String _formattedDate = formattedDate;

    // Kontroler pola tekstowego, aby umożliwić edycję danych
    TextEditingController pole_tekstowe1 =
        TextEditingController(text: _rodzaj_aktywnosci);
    TextEditingController pole_tekstowe2 =
        TextEditingController(text: _czas_trwania);
    TextEditingController pole_tekstowe3 =
        TextEditingController(text: _dystans);
    TextEditingController pole_tekstowe4 =
        TextEditingController(text: _formattedDate);

    // Wyświetl okno dialogowe
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edytuj dane'),
          content: Column(
            children: [
              TextFormField(
                controller: pole_tekstowe1,
              ),
              const Text(
                "Rodzaj aktywnosci",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: pole_tekstowe2,
              ),
              const Text(
                "Czas trwania",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: pole_tekstowe3,
              ),
              const Text(
                "Dystans (m)",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: pole_tekstowe4,
              ),
              const Text(
                "Data i czas rozpoczecia (min)",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Zamknij okno dialogowe bez zapisu zmian
                Navigator.of(context).pop();
              },
              child: const Text('ANULUJ'),
            ),
            TextButton(
              onPressed: () {
                // Tutaj możesz pobrać wartości z kontrolek (zmodyfikowane dane) i je zapisać
                String nowe_rodzaj_aktywnosci = pole_tekstowe1.text;
                String nowe_czas_trwania = pole_tekstowe2.text;
                String nowe_dystans = pole_tekstowe3.text;
                String nowe_formattedDate = pole_tekstowe4.text;

                Map<String, dynamic> noweDane = {
                  'rodzaj_aktywnosci': nowe_rodzaj_aktywnosci,
                  'czas_trwania': int.parse(nowe_czas_trwania),
                  'dystans': int.parse(nowe_dystans),
                  'formattedDate': nowe_formattedDate,
                  // Tutaj możesz dodać inne pola danych, jeśli są wymagane
                };

                // Wykonaj operacje zapisu danych do bazy danych lub gdziekolwiek indziej
                // np. za pomocą swojej funkcji 'edytujDane' z wcześniejszego przykładu
                // edytujDane(documentId, noweDane1, noweDane2, noweDane3);

                // Zamknij okno dialogowe po zapisie zmian
                edytujDane(documentId, noweDane).then((_) {
                  // Operacje po zaktualizowaniu danych (jeśli potrzebne)

                  // Zamknij okno dialogowe po zapisie zmian
                  Navigator.of(context).pop();
                }).catchError((error) {
                  // Obsługa błędów w przypadku niepowodzenia edycji danych
                  print('Wystąpił błąd podczas edycji danych: $error');
                  // Tu możesz wyświetlić komunikat o błędzie lub podjąć inne działania
                });
              },
              child: const Text('ZAPISZ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime teraz = DateTime.now();
    String miesiac = DateFormat('MMMM').format(teraz);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aplikacja sportowa',
        ),
      ),
      body: Column(
        children: [
          Text(
            "Statystyki z miesiąca: $miesiac",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Wystąpił błąd: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    itemCount: _zaktualizowaneDane.length,
                    itemBuilder: (BuildContext context, int index) {
                      String documentId =
                          _zaktualizowaneDane[index]['documentId'];
                      Map<String, dynamic> data =
                          _zaktualizowaneDane[index]['data'];
                      int czas_trwania = data['czas_trwania'] as int;
                      int dystans = data['dystans'] as int;
                      Timestamp poczatek_treningu =
                          data['poczatek_treningu'] as Timestamp;
                      String rodzaj_aktywnosci =
                          data['rodzaj_aktywnosci'] as String;
                      DateTime dateTime = poczatek_treningu.toDate();
                      String formattedDate =
                          DateFormat('dd.MM.yyyy HH:mm').format(dateTime);

                      DateTime now = DateTime.now();
                      if (dateTime.month == now.month) {
                        return ListTile(
                          title: Text('Rodzaj aktywności: $rodzaj_aktywnosci'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Szczegóły treningu'),
                                        content: Text(
                                          'Czas trwania: $czas_trwania minut\nDystans: $dystans metrów\nPoczątek treningu: $formattedDate\nID: $documentId',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              await usunDane(documentId);
                                              Navigator.of(context).pop();
                                              List<Map<String, dynamic>>
                                                  zaktualizowaneDane =
                                                  await odczytajDane();
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DrugiWidok(
                                                    daneZBazy:
                                                        zaktualizowaneDane,
                                                  ),
                                                ),
                                                (route) => route.isFirst,
                                              );
                                            },
                                            child: const Text('USUN'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              _showEditDialog(
                                                context,
                                                documentId,
                                                czas_trwania,
                                                dystans,
                                                rodzaj_aktywnosci,
                                                formattedDate,
                                              );
                                            },
                                            child: const Text('EDYTUJ'),
                                          ),
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
                                },
                                child: const Text('Rozwiń szczegóły'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              },
              future: null,
            ),
          ),
        ],
      ),
    );
  }
}
