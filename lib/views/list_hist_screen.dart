import 'package:dictionary/models/palavra.dart';
import 'package:dictionary/services/auth_service.dart';
import 'package:dictionary/services/palavra_service.dart';
import 'package:dictionary/services/usuario_service.dart';
import 'package:dictionary/views/widget/dialog_palavra.dart';
import 'package:flutter/material.dart';

class HistListScreen extends StatefulWidget {
  PalavraService _palavraService;

  HistListScreen(
      this._palavraService
      );

  @override
  _HistListScreenScreenState createState() => _HistListScreenScreenState();
}

class _HistListScreenScreenState extends State<HistListScreen> {
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
            showDialog(
                context: context,
                builder: (_) {
                  return DialogPalavra(
                      _usuarioService,
                      _palavras,
                      _indiceAtual,
                      palavra.id
                  );
                });
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
