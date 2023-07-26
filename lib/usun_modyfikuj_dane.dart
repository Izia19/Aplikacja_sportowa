import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> usunDane(String documentId) {
  Completer<void> completer = Completer<void>();

  FirebaseFirestore.instance
      .collection('user')
      .doc(documentId)
      .delete()
      .then((value) {
    print('Dokument został pomyślnie usunięty.');
    completer.complete(); // Oznaczamy Future jako zakończony sukcesem
  }).catchError((error) {
    print('Wystąpił błąd podczas usuwania dokumentu: $error');
    completer.completeError(error); // Oznaczamy Future jako zakończony z błędem
  });

  return completer
      .future; // Zwracamy Future, który będzie wypełniony sukcesem lub błędem
}
