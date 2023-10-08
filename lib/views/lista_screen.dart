import 'package:dictionary/providers/palavras_provider.dart';
import 'package:dictionary/services/usuario_service.dart';
import 'package:dictionary/views/widget/dialog_palavra.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PalavrasListScreen extends StatefulWidget {
  UsuarioService _usuarioService;
  PalavrasListScreen(
      this._usuarioService
  );

  @override
  _PalavrasListScreenState createState() => _PalavrasListScreenState();
}

class _PalavrasListScreenState extends State<PalavrasListScreen> {
  late UsuarioService _usuarioService;
  int _indiceAtual = 0;

  @override
  void initState() {
    super.initState();
    _usuarioService = widget._usuarioService;
  }

  @override
  Widget build(BuildContext context) {
    final palavraProvider = Provider.of<PalavraProvider>(context);

    // Inicializando o carregamento de palavras iniciais
    if (palavraProvider.palavras.isEmpty) {
      palavraProvider.carregarPalavrasIniciais();
    }

    // Controlador de rolagem
    final ScrollController _scrollController = ScrollController();

    // Função para carregar mais palavras quando o usuário atingir o final
    void _carregarMaisPalavras() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        palavraProvider.carregarMaisPalavras();
      }
    }

    // Adicionando a função ao controlador de rolagem
    _scrollController.addListener(_carregarMaisPalavras);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: palavraProvider.palavras.length,
      itemBuilder: (context, index) {
        final palavra = palavraProvider.palavras[index];

        return GestureDetector(
          onTap: () {
            _indiceAtual = index;
            //_consultarDefinicao(palavra.id);

            showDialog(
                context: context,
                builder: (_) {
                  return DialogPalavra(
                      _usuarioService,
                      palavraProvider.palavras,
                      _indiceAtual,
                      palavra.id
                  );
                });

          },
          child: Center(
            child: Text(
              palavra.id,
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      },
      controller: _scrollController,
    );
  }
}
