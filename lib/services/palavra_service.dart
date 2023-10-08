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

  static Future<List<Palavra>> obterPalavras(int pageSize, [String? lastId]) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection("listadepalavras");

      Query query = collection.orderBy('id').limit(pageSize);

      if (lastId != null) {
        query = query.startAfterDocument(await collection.doc(lastId).get());
      }

      QuerySnapshot querySnapshot = await query.get();

      List<Palavra> palavras = querySnapshot.docs.map((doc) {
        return Palavra.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return palavras;
    } catch (e) {
      print('Erro ao obter palavras: $e');
      throw e;
    }
  }

}
