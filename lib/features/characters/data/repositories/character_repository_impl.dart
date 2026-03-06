import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/paginated_characters.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/characters_remote_data_source.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl(this._remoteDataSource);

  final CharactersRemoteDataSource _remoteDataSource;

  @override
  Future<Result<PaginatedCharacters>> getCharactersPage(int page) async {
    try {
      final response = await _remoteDataSource.getCharactersPage(page);
      return Success(
        PaginatedCharacters(
          characters: response.characters
              .map((character) => character.toEntity())
              .toList(growable: false),
          page: response.currentPage,
          hasNext: response.hasNext,
        ),
      );
    } on NetworkException {
      return const FailureResult<PaginatedCharacters>(NetworkFailure());
    } on ServerException {
      return const FailureResult<PaginatedCharacters>(ServerFailure());
    } catch (_) {
      return const FailureResult<PaginatedCharacters>(UnknownFailure());
    }
  }
}
