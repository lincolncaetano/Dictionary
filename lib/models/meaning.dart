import 'package:dictionary/models/definition.dart';

class Meaning {
  final String? partOfSpeech;
  final List<Definition>? definitions;

  Meaning({
    this.partOfSpeech,
    this.definitions,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'],
      definitions: (json['definitions'] as List<dynamic>?)
          ?.map((def) => Definition.fromJson(def))
          .toList(),
    );
  }
}