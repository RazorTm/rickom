import 'package:equatable/equatable.dart';

import 'character.dart';

class PaginatedCharacters extends Equatable {
  const PaginatedCharacters({
    required this.characters,
    required this.page,
    required this.hasNext,
  });

  final List<Character> characters;
  final int page;
  final bool hasNext;

  @override
  List<Object?> get props => [characters, page, hasNext];
}
