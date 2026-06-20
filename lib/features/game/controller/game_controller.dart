import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../model/player_model.dart';
import '../model/game_state_model.dart';
import '../model/word_model.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/game_algorithm.dart';
import '../../ads_manager/controller/ads_manager_controller.dart';

class GameController extends GetxController {
  RxList<PlayerModel> players = <PlayerModel>[].obs;
  Rx<GamePhase> phase = GamePhase.categorySelection.obs;

  String secretWord = "";
  var revealIndex = 0.obs;
  var votes = <String, int>{}.obs;
  var votedPlayers = <String>{}.obs;
  var playerVotes = <String, String>{}.obs; // voterId -> votedForId

  RxList<WordModel> words = <WordModel>[].obs;
  RxList<String> categoriesList = <String>[].obs;
  List<Map<String, PlayerModel>> questionPairs = [];
  var currentQuestionIndex = 0.obs;

  String? currentTurnPlayerId;
  String? currentTurnAskedPlayerId;
  String? previousAskerId;

  String selectedCategory = "";

  final Map<String, int> selectedVotesCount = {};

  /// هل تم تخطي التصويت؟
  bool skippedVoting = false;

  final uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    _loadCachedPlayers();
    _loadData();
  }

  void _loadCachedPlayers() {
    final cached = LocalStorageService.getPlayers();
    if (cached.isNotEmpty) {
      players.value = cached
          .map((name) => PlayerModel(id: uuid.v4(), name: name))
          .toList();
    }
  }

  Future<void> _loadData() async {
    final loadedWords = await DatabaseService.getWords();
    words.assignAll(loadedWords);

    final loadedCats = await DatabaseService.getCategories();
    categoriesList.assignAll(loadedCats);
  }

  List<String> get categories {
    final cats = categoriesList.toList();
    if (cats.isNotEmpty && !cats.contains('عشوائي')) {
      cats.insert(0, 'عشوائي');
    }
    return cats;
  }

  void selectCategory(String category) {
    selectedCategory = category;
    phase.value = GamePhase.setup;
  }

  void savePlayersToCache() {
    final names = players.map((p) => p.name).toList();
    LocalStorageService.savePlayers(names);
  }

  bool get canStart => players.length >= 3;

  void addPlayer(String name) {
    if (name.trim().isNotEmpty) {
      players.add(PlayerModel(id: uuid.v4(), name: name.trim()));
      savePlayersToCache();
    }
  }

  void removePlayer(String id) {
    players.removeWhere((p) => p.id == id);
    savePlayersToCache();
  }

  void updatePlayerName(String id, String newName) {
    final index = players.indexWhere((p) => p.id == id);
    if (index != -1 && newName.trim().isNotEmpty) {
      players[index].name = newName.trim();
      players.refresh();
      savePlayersToCache();
    }
  }

  Future<void> startGame() async {
    if (!canStart) return;

    // Fetch unused words directly from database with rotation logic
    final unusedWords = await DatabaseService.getWords(
      category: selectedCategory,
    );

    if (unusedWords.isEmpty) return;

    final chosenWord = GameAlgorithm.assignImposterAndWord(
      players,
      unusedWords,
    );

    secretWord = chosenWord.word;

    // Mark as used in database
    await DatabaseService.markWordAsUsed(chosenWord.id);

    questionPairs = GameAlgorithm.generateQuestionPairs(players);
    currentQuestionIndex.value = 0;

    revealIndex.value = 0;
    votes.clear();
    votedPlayers.clear();
    playerVotes.clear();
    selectedVotesCount.clear();
    previousAskerId = null;

    phase.value = GamePhase.reveal;
  }

  PlayerModel get currentPlayer => players[revealIndex.value];

  void nextReveal() {
    if (revealIndex.value < players.length - 1) {
      revealIndex.value++;
    } else {
      phase.value = GamePhase.questionRound;
    }
  }

  Map<String, PlayerModel> get currentQuestionPair =>
      questionPairs[currentQuestionIndex.value];

  void nextQuestion() {
    if (currentQuestionIndex.value < questionPairs.length - 1) {
      currentQuestionIndex.value++;
    } else {
      startFreeRound(questionPairs.last["asked"]!.id);
    }
  }

  void startFreeRound(String lastAskedId) {
    currentTurnPlayerId = lastAskedId;
    currentTurnAskedPlayerId = null;
    previousAskerId = questionPairs.last["asker"]?.id;
    phase.value = GamePhase.freeRound;
  }

  void checkSelectNextPlayer(String selectedId) {
    if (selectedId == currentTurnPlayerId || selectedId == previousAskerId)
      return;
    currentTurnAskedPlayerId = selectedId;
    update();
  }

  void confirmSelectNextPlayer() {
    if (currentTurnAskedPlayerId != null) {
      previousAskerId = currentTurnPlayerId;
      currentTurnPlayerId = currentTurnAskedPlayerId;
      currentTurnAskedPlayerId = null;
      update();
    }
  }

  void startVoting() {
    phase.value = GamePhase.voting;
    votes.clear();
    votedPlayers.clear();
    playerVotes.clear();
    selectedVotesCount.clear();
    for (var player in players) {
      selectedVotesCount[player.id] = 0;
    }
  }

  void vote(String voterId, String votedForId) {
    if (voterId == votedForId) return;

    // Change vote logic
    playerVotes[voterId] = votedForId;
    votedPlayers.add(voterId);

    // Recalculate counts
    votes.clear();
    selectedVotesCount.clear();
    for (var player in players) {
      selectedVotesCount[player.id] = 0;
    }

    playerVotes.forEach((voter, votedFor) {
      votes[votedFor] = (votes[votedFor] ?? 0) + 1;
      selectedVotesCount[votedFor] = (selectedVotesCount[votedFor] ?? 0) + 1;
    });

    update();
  }

  void showResultWithAd() {
    try {
      Get.find<AdsManagerController>().showInterstitialAd(
        onAdDismissed: () {
          phase.value = GamePhase.result;
        },
      );
    } catch (_) {
      phase.value = GamePhase.result;
    }
  }

  String get imposterName => players.firstWhere((p) => p.isImposter).name;

  PlayerModel? get mostVotedPlayer {
    if (votes.isEmpty) return null;

    int maxVotes = 0;
    String mostVotedId = "";

    votes.forEach((id, count) {
      if (count > maxVotes) {
        maxVotes = count;
        mostVotedId = id;
      }
    });

    int tieCount = 0;
    votes.forEach((id, count) {
      if (count == maxVotes) tieCount++;
    });

    if (tieCount > 1) return null;

    try {
      return players.firstWhere((p) => p.id == mostVotedId);
    } catch (_) {
      return null;
    }
  }

  bool get didPlayersWin {
    final _mostVoted = mostVotedPlayer;
    if (_mostVoted == null) return false;
    return _mostVoted.isImposter;
  }

  void restartGame() {
    for (var p in players) {
      p.isImposter = false;
    }
    previousAskerId = null;
    skippedVoting = false;
    phase.value = GamePhase.categorySelection;
  }
}
