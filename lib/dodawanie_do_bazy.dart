import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference user = FirebaseFirestore.instance.collection('user');

void dodajDane(int czas_trwania, int pokonany_dystans,
    Timestamp godzina_rozpoczecia, String rodzaj_aktywnosci) {
  user.add(
    {
      'czas_trwania': czas_trwania,
      'dystans': pokonany_dystans,
      'poczatek_treningu': godzina_rozpoczecia,
      'rodzaj_aktywnosci': rodzaj_aktywnosci,
    },
  ).then((value) => print("Aktywnosc zostala dodana. ID: ${value.id}"));
}
