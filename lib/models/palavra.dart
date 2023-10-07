class Palavra {
  final String id;

  Palavra({
    required this.id
  });

  factory Palavra.fromJson(Map<String, dynamic> json) {
    return Palavra(
      id: json['id'],
    );
  }
}