import '../../features/game/model/player_model.dart';
import '../../features/game/model/word_model.dart';
import 'random_utils.dart';

class GameAlgorithm {
  static WordModel assignImposterAndWord(
    List<PlayerModel> players,
    List<WordModel> words,
  ) {
    if (words.isEmpty) throw Exception("No words available");

    // 1. اختار كلمة عشوائية
    final WordModel chosen =
        words[RandomUtils.generateRandomIndex(words.length)];

    // 2. اختار امبوستر
    if (players.isNotEmpty) {
      final int imposterIndex = RandomUtils.generateRandomIndex(players.length);
      for (int i = 0; i < players.length; i++) {
        players[i].isImposter = (i == imposterIndex);
      }
    }

    return chosen;
  }

  static List<Map<String, PlayerModel>> generateQuestionPairs(
    List<PlayerModel> players,
  ) {
    if (players.isEmpty) return [];
    List<PlayerModel> shuffled = players.toList()..shuffle();
    List<Map<String, PlayerModel>> questionPairs = [];

    for (int i = 0; i < shuffled.length; i++) {
      final asker = shuffled[i];
      final asked = shuffled[(i + 1) % shuffled.length];

      questionPairs.add({"asker": asker, "asked": asked});
    }

    return questionPairs;
  }
}
