import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_characters_page_usecase.dart';
import 'characters_list_event.dart';
import 'characters_list_state.dart';

class CharactersListBloc
    extends Bloc<CharactersListEvent, CharactersListState> {
  CharactersListBloc({
    required GetCharactersPageUseCase getCharactersPageUseCase,
  }) : _getCharactersPageUseCase = getCharactersPageUseCase,
       super(const CharactersListState()) {
    on<CharactersListStarted>(_onStarted);
    on<CharactersListLoadNextPage>(_onLoadNextPage);
    on<CharactersListRetryRequested>(_onRetryRequested);
    on<CharactersListPaginationErrorShown>(_onPaginationErrorShown);
  }

  final GetCharactersPageUseCase _getCharactersPageUseCase;

  Future<void> _onStarted(
    CharactersListStarted event,
    Emitter<CharactersListState> emit,
  ) async {
    if (state.status != CharactersListStatus.initial) {
      return;
    }
    await _loadFirstPage(emit);
  }

  Future<void> _onRetryRequested(
    CharactersListRetryRequested event,
    Emitter<CharactersListState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onLoadNextPage(
    CharactersListLoadNextPage event,
    Emitter<CharactersListState> emit,
  ) async {
    if (!state.hasNext ||
        state.status == CharactersListStatus.loading ||
        state.status == CharactersListStatus.paginationLoading ||
        state.status == CharactersListStatus.error) {
      return;
    }

    emit(
      state.copyWith(
        status: CharactersListStatus.paginationLoading,
        clearPaginationErrorKey: true,
      ),
    );

    final result = await _getCharactersPageUseCase(state.page + 1);

    result.when(
      success: (pageData) {
        emit(
          state.copyWith(
            status: CharactersListStatus.success,
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
            status: CharactersListStatus.success,
            paginationErrorKey: failure.messageKey,
          ),
        );
      },
    );
  }

  Future<void> _loadFirstPage(Emitter<CharactersListState> emit) async {
    emit(
      state.copyWith(
        status: CharactersListStatus.loading,
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
            status: CharactersListStatus.success,
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
            status: CharactersListStatus.error,
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
    CharactersListPaginationErrorShown event,
    Emitter<CharactersListState> emit,
  ) {
    emit(state.copyWith(clearPaginationErrorKey: true));
  }
}
