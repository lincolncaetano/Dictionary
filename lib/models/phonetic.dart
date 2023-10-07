class Phonetic {
  final String? text;
  final String? audio;

  Phonetic({
    this.text,
    this.audio,
  });

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'],
      audio: json['audio'],
    );
  }
}