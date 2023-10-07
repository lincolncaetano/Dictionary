import 'package:audioplayers/audioplayers.dart';
import 'package:dictionary/models/definicao_palavra.dart';
import 'package:dictionary/services/usuario_service.dart';
import 'package:dictionary/views/components/player_widget.dart';
import 'package:flutter/material.dart';

class DialogPalavra extends StatefulWidget {
  DefinicaoPalavra _definicao;
  bool _isFavorita;
  UsuarioService _usuarioService;
  Function()? _proximo;
  Function()? _anterior;

  DialogPalavra(
      this._definicao,
      this._isFavorita,
      this._usuarioService,
      this._proximo,
      this._anterior
  );

  @override
  State<DialogPalavra> createState() => _DialogPalavraState();
}

class _DialogPalavraState extends State<DialogPalavra> {

  late DefinicaoPalavra definicao;
  late bool isFavorita;
  final player = AudioPlayer();
  late UsuarioService usuarioService;

  @override
  void initState() {
    super.initState();
    definicao = widget._definicao;
    isFavorita = widget._isFavorita;
    usuarioService = widget._usuarioService;
  }

  play(String url) async {
    await player.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {

    String? audio = definicao.obterAudio();
    if(audio != null){
      player.setSourceUrl(audio!);
    }


    return  AlertDialog(
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
          onPressed: widget._anterior,
          child: Text('Anterior'),
        ),
        ElevatedButton(
          onPressed: widget._proximo,
          child: Text('Proximo'),
        ),
      ],
    );
  }
}
