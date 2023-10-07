class Definition {
  final String? definition;
  final String? example;
  final List<String>? synonyms;
  final List<String>? antonyms;

  Definition({
    this.definition,
    this.example,
    this.synonyms,
    this.antonyms,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'],
      example: json['example'],
      synonyms: (json['synonyms'] as List<dynamic>?)
          ?.cast<String>(),
      antonyms: (json['antonyms'] as List<dynamic>?)
          ?.cast<String>(),
    );
  }
}