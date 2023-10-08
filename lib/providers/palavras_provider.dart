import 'package:dictionary/models/palavra.dart';
import 'package:dictionary/services/palavra_service.dart';
import 'package:flutter/material.dart';

class PalavraProvider extends ChangeNotifier {
  List<Palavra> _palavras = [];
  int _pageSize = 20;
  List<Palavra> get palavras => _palavras;

  Future<void> carregarPalavrasIniciais() async {
    _palavras = await PalavraService.obterPalavras(_pageSize);
    notifyListeners();
  }

  Future<void> carregarMaisPalavras() async {
    List<Palavra> novasPalavras = await PalavraService.obterPalavras(_pageSize, _palavras.last.id);
    _palavras.addAll(novasPalavras);
    notifyListeners();
  }
}