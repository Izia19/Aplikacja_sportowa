import 'package:aplikacja_sportowa/wyswietlanie_z_bazy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference user = FirebaseFirestore.instance.collection('user');

Future<void> dodajDane(int czas_trwania, int pokonany_dystans,
    Timestamp godzina_rozpoczecia, String rodzaj_aktywnosci) async {
  await user.add(
    {
      'czas_trwania': czas_trwania,
      'dystans': pokonany_dystans,
      'poczatek_treningu': godzina_rozpoczecia,
      'rodzaj_aktywnosci': rodzaj_aktywnosci,
    },
  );

  // Po dodaniu danych odświeżamy dane z bazy
  await odczytajDane();

  print("Aktywność została dodana.");
}
