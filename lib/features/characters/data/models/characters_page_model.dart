import 'character_model.dart';

class CharactersPageModel {
  const CharactersPageModel({
    required this.currentPage,
    required this.hasNext,
    required this.characters,
  });

  final int currentPage;
  final bool hasNext;
  final List<CharacterModel> characters;

  factory CharactersPageModel.fromJson({
    required Map<String, dynamic> json,
    required int page,
  }) {
    final info = json['info'] as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>;

    return CharactersPageModel(
      currentPage: page,
      hasNext: info['next'] != null,
      characters: results
          .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}
