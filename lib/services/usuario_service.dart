import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/services/palavra_service.dart';

class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _usuariosCollection;
  late DocumentReference _documentReference;

  UsuarioService(String userId) {
    _usuariosCollection = _firestore.collection('usuarios').doc(userId).collection('dados');
    _documentReference = _firestore.collection('usuarios').doc(userId);
  }

  Future<void> adicionarFavorita(String palavra) async {
    await _documentReference.update({
      'favoritas': FieldValue.arrayUnion([palavra])
    });
    await _documentReference.collection("favoritas")
        .doc(palavra)
        .set(
        {
          'id': palavra
        }
    );
  }

  Future<void> removerFavorita(String palavra) async {
    await _documentReference.update({
      'palavras': FieldValue.arrayRemove([palavra]),
    });
    await _documentReference.collection("favoritas")
        .doc(palavra)
        .delete();
  }

  Future<void> adicionarHistorico(String palavra) async {
   /* await _usuariosCollection.doc('historico').update({
      'historico': FieldValue.arrayUnion([palavra]),
    });*/

    await _documentReference.collection("historico")
      .doc(palavra).set({
      'id': palavra
    });

    await _documentReference.update({
      'historico': FieldValue.arrayUnion([palavra])
    });
  }

  Future<bool> verificaPalavraFavorita(String palavra) async{

    DocumentSnapshot doc = await _documentReference.collection("favoritas")
        .doc(palavra).get().then(
          (DocumentSnapshot doc) {
        return doc;
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return doc.data() != null ? true : false;;
  }

}
