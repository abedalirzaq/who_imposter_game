import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> savePlayers(List<String> playerNames) async {
    await _prefs.setStringList('cached_players', playerNames);
  }

  static List<String> getPlayers() {
    return _prefs.getStringList('cached_players') ?? [];
  }

  static Future<void> saveUsedWordId(int id) async {
    final usedWords = getUsedWordIds().toList();
    if (!usedWords.contains(id.toString())) {
      usedWords.add(id.toString());
      await _prefs.setStringList('used_words', usedWords);
    }
  }

  static List<String> getUsedWordIds() {
    return _prefs.getStringList('used_words') ?? [];
  }

  static Future<void> clearUsedWords() async {
    await _prefs.remove('used_words');
  }
}
