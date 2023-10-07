import 'package:dictionary/models/meaning.dart';
import 'package:dictionary/models/phonetic.dart';

class DefinicaoPalavra {
  final String? word;
  final String? phonetic;
  final List<Phonetic>? phonetics;
  final String? origin;
  final List<Meaning>? meanings;

  DefinicaoPalavra({
    this.word,
    this.phonetic,
    this.phonetics,
    this.origin,
    this.meanings,
  });

  factory DefinicaoPalavra.fromJson(Map<String, dynamic> json) {
    return DefinicaoPalavra(
      word: json['word'],
      phonetic: json['phonetic'],
      phonetics: (json['phonetics'] as List<dynamic>?)
          ?.map((ph) => Phonetic.fromJson(ph))
          .toList(),
      origin: json['origin'],
      meanings: (json['meanings'] as List<dynamic>?)
          ?.map((meaning) => Meaning.fromJson(meaning))
          .toList(),
    );
  }

  String? obterAudio() {
    for (var phonetic in phonetics!) {
      if (phonetic.audio?.compareTo("") != 0) {
        return phonetic.audio;
      }
    }
    return null; // Retorna nulo se nenhum áudio for encontrado
  }

}