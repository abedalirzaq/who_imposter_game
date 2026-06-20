class WordModel {
  final int id;
  final String word;
  final String category;
  final bool isUsed;

  WordModel({
    required this.id,
    required this.word,
    required this.category,
    this.isUsed = false,
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'],
      word: map['word'],
      category: map['category'],
      isUsed: map['is_used'] == 1,
    );
  }
}
