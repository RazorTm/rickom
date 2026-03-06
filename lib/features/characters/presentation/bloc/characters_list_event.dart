import 'package:equatable/equatable.dart';

sealed class CharactersListEvent extends Equatable {
  const CharactersListEvent();

  @override
  List<Object?> get props => [];
}

class CharactersListStarted extends CharactersListEvent {
  const CharactersListStarted();
}

class CharactersListLoadNextPage extends CharactersListEvent {
  const CharactersListLoadNextPage();
}

class CharactersListRetryRequested extends CharactersListEvent {
  const CharactersListRetryRequested();
}

class CharactersListPaginationErrorShown extends CharactersListEvent {
  const CharactersListPaginationErrorShown();
}
