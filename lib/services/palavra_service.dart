import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/models/palavra.dart';

class PalavraService{
  late CollectionReference _lista;
  PalavraService(CollectionReference collectionReference){
    _lista = collectionReference;
  }

  Future<List<Palavra>> carregarPalavras(int pageSize, String id) async {
    List<Palavra> palavras = [];

    try {
      Query query = _lista
          .orderBy('id')
          .limit(pageSize);

      if (id != "") {
        query = query.startAfter([id]);
      }

      QuerySnapshot querySnapshot = await query.get();

      palavras = querySnapshot.docs.map((doc) {
        return Palavra.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return palavras;
    } catch (e) {
      print('Erro ao carregar palavras do Firestore: $e');
      return [];
    }
  }
}
