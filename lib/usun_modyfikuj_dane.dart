// ignore_for_file: avoid_print

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

Future<void> edytujDane(String documentId, Map<String, dynamic> noweDane) {
  Completer<void> completer = Completer<void>();

  FirebaseFirestore.instance
      .collection('user')
      .doc(documentId)
      .update(
          noweDane) // Użyj metody 'update' z nowymi danymi do modyfikacji dokumentu
      .then((value) {
    print('Dokument został pomyślnie zaktualizowany.');
    completer.complete(); // Oznacz Future jako zakończony sukcesem
  }).catchError((error) {
    print('Wystąpił błąd podczas aktualizowania dokumentu: $error');
    completer.completeError(error); // Oznacz Future jako zakończony z błędem
  });

  return completer
      .future; // Zwróć Future, który będzie wypełniony sukcesem lub błędem
}
