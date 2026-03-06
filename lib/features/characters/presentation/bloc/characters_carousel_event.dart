import 'package:equatable/equatable.dart';

sealed class CharactersCarouselEvent extends Equatable {
  const CharactersCarouselEvent();

  @override
  List<Object?> get props => [];
}

class CharactersCarouselStarted extends CharactersCarouselEvent {
  const CharactersCarouselStarted();
}

class CharactersCarouselLoadNextPage extends CharactersCarouselEvent {
  const CharactersCarouselLoadNextPage();
}

class CharactersCarouselRetryRequested extends CharactersCarouselEvent {
  const CharactersCarouselRetryRequested();
}

class CharactersCarouselPaginationErrorShown extends CharactersCarouselEvent {
  const CharactersCarouselPaginationErrorShown();
}
