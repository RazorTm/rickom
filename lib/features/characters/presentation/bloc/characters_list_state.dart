import 'package:equatable/equatable.dart';

import '../../domain/entities/character.dart';

enum CharactersListStatus {
  initial,
  loading,
  success,
  paginationLoading,
  error,
}

class CharactersListState extends Equatable {
  const CharactersListState({
    this.status = CharactersListStatus.initial,
    this.characters = const [],
    this.page = 0,
    this.hasNext = true,
    this.errorKey,
    this.paginationErrorKey,
  });

  final CharactersListStatus status;
  final List<Character> characters;
  final int page;
  final bool hasNext;
  final String? errorKey;
  final String? paginationErrorKey;

  CharactersListState copyWith({
    CharactersListStatus? status,
    List<Character>? characters,
    int? page,
    bool? hasNext,
    String? errorKey,
    bool clearErrorKey = false,
    String? paginationErrorKey,
    bool clearPaginationErrorKey = false,
  }) {
    return CharactersListState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      page: page ?? this.page,
      hasNext: hasNext ?? this.hasNext,
      errorKey: clearErrorKey ? null : (errorKey ?? this.errorKey),
      paginationErrorKey: clearPaginationErrorKey
          ? null
          : (paginationErrorKey ?? this.paginationErrorKey),
    );
  }

  @override
  List<Object?> get props => [
    status,
    characters,
    page,
    hasNext,
    errorKey,
    paginationErrorKey,
  ];
}
