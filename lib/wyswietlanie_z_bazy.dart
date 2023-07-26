import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> odczytajDane() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('user').get();

  List<Map<String, dynamic>> daneZBazy = [];

  snapshot.docs.forEach(
    (document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String documentId = document.id;

      daneZBazy.add(
        {
          'documentId': documentId,
          'data': data,
        },
      );
    },
  );

  return daneZBazy;
}
