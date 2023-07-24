import 'package:cloud_firestore/cloud_firestore.dart';

void odczytDanych() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('user').get();

    if (querySnapshot.size > 0) {
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          int czas_trwania = data['czas_trwania'];
          int dystans = data['dystans'];
          Timestamp poczatek_treningu = data['poczatek_treningu'];
          String rodzaj_aktywnosci = data['rodzaj_aktywnosci'];
        }
      }
    } else {
      print('Brak dokumentów w kolekcji "user".');
    }
  } catch (e) {
    print('Wystąpił błąd: $e');
  }
}
