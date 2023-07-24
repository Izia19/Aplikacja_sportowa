import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrugiWidok extends StatefulWidget {
  const DrugiWidok({Key? key}) : super(key: key);

  @override
  State<DrugiWidok> createState() => _DrugiWidokState();
}

class _DrugiWidokState extends State<DrugiWidok> {
  List<Map<String, dynamic>> daneZBazy = [];

  Future<void> odczytajDane() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('user').get();

      List<Map<String, dynamic>> dane = [];
      if (querySnapshot.size > 0) {
        // Iteracja przez wszystkie dokumenty
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          if (docSnapshot.exists) {
            // Dostęp do danych w dokumencie:
            Map<String, dynamic> data =
                docSnapshot.data() as Map<String, dynamic>;
            dane.add(data);
          }
        }
      } else {
        print('Brak dokumentów w kolekcji "user".');
      }

      setState(() {
        daneZBazy = dane;
      });
    } catch (e) {
      print('Wystąpił błąd: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    odczytajDane();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aplikacja sportowa',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Statystyki z miesiaca: ",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: daneZBazy.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> dane = daneZBazy[index];
                  int czas_trwania = dane['czas_trwania'] as int;
                  int dystans = dane['dystans'] as int;
                  Timestamp poczatek_treningu =
                      dane['poczatek_treningu'] as Timestamp;
                  String rodzaj_aktywnosci =
                      dane['rodzaj_aktywnosci'] as String;

                  DateTime dateTime = poczatek_treningu.toDate();
                  String formattedDate =
                      DateFormat('dd.MM.yyyy HH:mm').format(dateTime);

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
                                  title: Text('Szczegóły treningu'),
                                  content: Text(
                                    'Czas trwania: $czas_trwania minut\nDystans: $dystans metrów\nPoczątek treningu: $formattedDate',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Rozwiń szczegóły'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
