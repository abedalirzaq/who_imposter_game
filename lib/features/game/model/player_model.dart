class PlayerModel {
  final String id;
  String name;
  bool isImposter;

  PlayerModel({required this.id, required this.name, this.isImposter = false});
}
