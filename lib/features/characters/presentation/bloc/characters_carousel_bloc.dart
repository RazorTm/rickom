import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_characters_page_usecase.dart';
import 'characters_carousel_event.dart';
import 'characters_carousel_state.dart';

class CharactersCarouselBloc
    extends Bloc<CharactersCarouselEvent, CharactersCarouselState> {
  CharactersCarouselBloc({
    required GetCharactersPageUseCase getCharactersPageUseCase,
  }) : _getCharactersPageUseCase = getCharactersPageUseCase,
       super(const CharactersCarouselState()) {
    on<CharactersCarouselStarted>(_onStarted);
    on<CharactersCarouselLoadNextPage>(_onLoadNextPage);
    on<CharactersCarouselRetryRequested>(_onRetryRequested);
    on<CharactersCarouselPaginationErrorShown>(_onPaginationErrorShown);
  }

  final GetCharactersPageUseCase _getCharactersPageUseCase;

  Future<void> _onStarted(
    CharactersCarouselStarted event,
    Emitter<CharactersCarouselState> emit,
  ) async {
    if (state.status != CharactersCarouselStatus.initial) {
      return;
    }
    await _loadFirstPage(emit);
  }

  Future<void> _onRetryRequested(
    CharactersCarouselRetryRequested event,
    Emitter<CharactersCarouselState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onLoadNextPage(
    CharactersCarouselLoadNextPage event,
    Emitter<CharactersCarouselState> emit,
  ) async {
    if (!state.hasNext ||
        state.status == CharactersCarouselStatus.loading ||
        state.status == CharactersCarouselStatus.paginationLoading ||
        state.status == CharactersCarouselStatus.error) {
      return;
    }

    emit(
      state.copyWith(
        status: CharactersCarouselStatus.paginationLoading,
        clearPaginationErrorKey: true,
      ),
    );

    final result = await _getCharactersPageUseCase(state.page + 1);

    result.when(
      success: (pageData) {
        emit(
          state.copyWith(
            status: CharactersCarouselStatus.success,
            characters: [...state.characters, ...pageData.characters],
            page: pageData.page,
            hasNext: pageData.hasNext,
            clearErrorKey: true,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: CharactersCarouselStatus.success,
            paginationErrorKey: failure.messageKey,
          ),
        );
      },
    );
  }

  Future<void> _loadFirstPage(Emitter<CharactersCarouselState> emit) async {
    emit(
      state.copyWith(
        status: CharactersCarouselStatus.loading,
        characters: const [],
        page: 0,
        hasNext: true,
        clearErrorKey: true,
        clearPaginationErrorKey: true,
      ),
    );

    final result = await _getCharactersPageUseCase(1);

    result.when(
      success: (pageData) {
        emit(
          state.copyWith(
            status: CharactersCarouselStatus.success,
            characters: pageData.characters,
            page: pageData.page,
            hasNext: pageData.hasNext,
            clearErrorKey: true,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: CharactersCarouselStatus.error,
            errorKey: failure.messageKey,
            characters: const [],
            page: 0,
            hasNext: true,
          ),
        );
      },
    );
  }

  void _onPaginationErrorShown(
    CharactersCarouselPaginationErrorShown event,
    Emitter<CharactersCarouselState> emit,
  ) {
    emit(state.copyWith(clearPaginationErrorKey: true));
  }
}
