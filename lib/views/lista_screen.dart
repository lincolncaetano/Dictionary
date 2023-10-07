import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/models/definicao_palavra.dart';
import 'package:dictionary/models/palavra.dart';
import 'package:dictionary/services/auth_service.dart';
import 'package:dictionary/services/palavra_service.dart';
import 'package:dictionary/services/usuario_service.dart';
import 'package:dictionary/views/widget/dialog_palavra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class PalavrasListScreen extends StatefulWidget {
  PalavraService _palavraService;

  PalavrasListScreen(
      this._palavraService
  );

  @override
  _PalavrasListScreenState createState() => _PalavrasListScreenState();
}

class _PalavrasListScreenState extends State<PalavrasListScreen> {
  late PalavraService _palavraService;
  late UsuarioService _usuarioService;
  final AuthService _authService = AuthService();

  final ScrollController _scrollController = ScrollController();
  List<Palavra> _palavras = [];
  bool _loading = false;
  int _pageSize = 20;
  int _indiceAtual = 0;

  @override
  void initState() {
    super.initState();
    _carregaUsuario();
    _carregarPalavras();
    _scrollController.addListener(_scrollListener);
  }

  void _carregaUsuario() async{
    String? uid = await _authService.obterIdUsuarioLogado();
    _usuarioService = UsuarioService(uid!);
  }

  void _carregarPalavras() async {
    _palavraService = widget._palavraService;
     if (_loading) return;
    setState(() {
      _loading = true;
    });
    List<Palavra> novasPalavras = await _palavraService.carregarPalavras(_pageSize, _palavras.isNotEmpty ? _palavras.last.id : "");
    setState(() {
      _palavras.addAll(novasPalavras);
      _loading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _carregarPalavras();
    }
  }

  void _abrirModal(DefinicaoPalavra definicao, bool isFavorita){
    showDialog(
        context: context,
        builder: (_) {
          return DialogPalavra(
              definicao,
              isFavorita,
              _usuarioService,
              () => _exibirPalavra(_indiceAtual + 1),
              () => _exibirPalavra(_indiceAtual - 1));
        });
  }

  void _exibirPalavra(int novoIndice) {
    if (novoIndice >= 0 && novoIndice < _palavras.length) {
      setState(() {
        _indiceAtual = novoIndice;
      });
      Navigator.pop(context);
      _consultarDefinicao(_palavras[_indiceAtual].id);
    }
  }

  Future<void> _consultarDefinicao(String? palavra) async {

    String cacheKey = 'definicao_$palavra';

    // Tenta obter os dados do cache
    FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(cacheKey);

   if(fileInfo != null){
     DefinicaoPalavra definicao = DefinicaoPalavra.fromJson(
       json.decode(await fileInfo.file.readAsString()),
     );
     bool isFavorita = await _usuarioService.verificaPalavraFavorita(definicao.word!);
     _abrirModal(definicao, isFavorita);
   }else{
     try {
       // Monta a URL da API externa
       String apiUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/${palavra}';
       final response = await http.get(Uri.parse(apiUrl));
       if (response.statusCode == 200) {
         // Parseia os dados da resposta
         List<dynamic> responseData = json.decode(response.body);
         if (responseData.isNotEmpty) {
           DefinicaoPalavra definicao = DefinicaoPalavra.fromJson(responseData[0]);
           _usuarioService.adicionarHistorico(palavra!);
           bool isFavorita = await _usuarioService.verificaPalavraFavorita(definicao.word!);
           _abrirModal(definicao, isFavorita);
         } else {
           _mostrarErro('Definição não encontrada para $palavra', palavra!);
         }
       } else {
         _mostrarErro('Definição não encontrada para $palavra', palavra!);
       }
     } catch (e) {
       _mostrarErro('Erro: $e', "Error");
     }
   }
  }

  void _mostrarErro(String mensagem, String palavra) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Definição de ${palavra}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${mensagem}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _exibirPalavra(_indiceAtual - 1);
              },
              child: Text('Anterior'),
            ),
            ElevatedButton(
              onPressed: () {
                _exibirPalavra(_indiceAtual + 1);
              },
              child: Text('Proximo'),
            ),
          ],
        );
      },
    );
  }

  /*



  * */


  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _palavras.length,
      itemBuilder: (context, index) {
        final palavra = _palavras[index];
        return GestureDetector(
          onTap: (){
            _indiceAtual = index;
            _consultarDefinicao(palavra.id);
          },
          child: Center(
            child: Text(
              palavra.id,
              style: TextStyle(
                fontSize: 20
              ),
            ),
          ),
        );
      },
      controller: _scrollController,
    );
  }
}
