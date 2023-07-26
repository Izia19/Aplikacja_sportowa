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
            ),
          ),
        ],
      ),
    );
  }
}
