import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dictionary/models/definicao_palavra.dart';
import 'package:dictionary/models/palavra.dart';
import 'package:dictionary/services/usuario_service.dart';
import 'package:dictionary/views/components/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class DialogPalavra extends StatefulWidget {
  UsuarioService _usuarioService;
  List<Palavra> _palavras;
  int _indiceAtual;
  String _palavra;

  DialogPalavra(
      this._usuarioService,
      this._palavras,
      this._indiceAtual,
      this._palavra
      );

  @override
  State<DialogPalavra> createState() => _DialogPalavraState();
}

class _DialogPalavraState extends State<DialogPalavra> {

  late DefinicaoPalavra definicao;
  late bool isFavorita;
  final player = AudioPlayer();
  late UsuarioService usuarioService;
  late List<Palavra> palavras;
  late int _indiceAtual;
  late String palavra;
  late bool error = true;
  bool _servicosCarregados = false;

  @override
  void initState() {
    super.initState();
    usuarioService = widget._usuarioService;
    palavras = widget._palavras;
    _indiceAtual = widget._indiceAtual;
    palavra = widget._palavra;
    _consultarDefinicao();
  }

  play(String url) async {
    await player.play(UrlSource(url));
  }

  void _exibirPalavra(int novoIndice) {
    if (novoIndice >= 0 && novoIndice < palavras.length) {
      setState(() {
        _indiceAtual = novoIndice;
        palavra = palavras[_indiceAtual].id;
        _consultarDefinicao();
      });
    }
  }

  Future<void> _consultarDefinicao() async {

    String cacheKey = 'definicao_$palavra';

    // Tenta obter os dados do cache
    FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(cacheKey);

    if(fileInfo != null){
      definicao = DefinicaoPalavra.fromJson(
        json.decode(await fileInfo.file.readAsString()),
      );
      isFavorita = await usuarioService.verificaPalavraFavorita(definicao.word!);
      error = false;
    }else{
      try {
        // Monta a URL da API externa
        String apiUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/${palavra}';
        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          // Parseia os dados da resposta
          List<dynamic> responseData = json.decode(response.body);
          if (responseData.isNotEmpty) {
            definicao = DefinicaoPalavra.fromJson(responseData[0]);
            usuarioService.adicionarHistorico(palavra!);
            isFavorita = await usuarioService.verificaPalavraFavorita(definicao.word!);

            // Salva os dados em cache para futuras consultas
            await DefaultCacheManager().putFile(
              cacheKey,
              Uint8List.fromList(utf8.encode(json.encode(responseData[0]))),
            );
            error = false;
          } else {
            error = true;
          }
        } else {
          error = true;
        }
      } catch (e) {
        error = true;
      }
    }

    setState(() {
      _servicosCarregados = true;
    });

  }

  AlertDialog _mostrarErro() {
    return AlertDialog(
      title: Text('Definição de ${palavra}'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Definição não encontrada para $palavra'),
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
  }

  AlertDialog alertEncontrada(){

    String? audio = definicao.obterAudio();
    if(audio != null){
      player.setSourceUrl(audio!);
    }

    return AlertDialog(
      title: Text('Definição de ${definicao.word}'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.2,
            color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('${definicao.word}', style: TextStyle( fontSize: 20)),
                Text(definicao.phonetic == null ? "Fonética não encontrada!" : '${definicao.phonetic}', style: TextStyle( fontSize: 20)),
              ],
            ),
          ),
          //Text('${definicao.word}'),
          //Text(definicao.phonetic == null ? "Fonética não encontrada!" : '${definicao.phonetic}') ,
          IconButton(
              onPressed: (){
                !isFavorita ?
                usuarioService.adicionarFavorita(definicao.word!) :
                usuarioService.removerFavorita(definicao.word!);
                isFavorita = !isFavorita;
                setState(() {});
              },
              icon: isFavorita ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border)
          ),
          audio != null ? PlayerWidget(player: player) : Container(),
          Text("Meanings", style: TextStyle( fontSize: 20)),
          for (var meaning in definicao.meanings!)
            Text('${meaning.partOfSpeech}: ${meaning.definitions![0].definition}'),

        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: ()=> _exibirPalavra(_indiceAtual - 1),
          child: Text('Anterior'),
        ),
        ElevatedButton(
          onPressed: () => _exibirPalavra(_indiceAtual + 1),
          child: Text('Proximo'),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return  _servicosCarregados ? ( error ? _mostrarErro() : alertEncontrada() ) : CircularProgressIndicator();
  }
}
