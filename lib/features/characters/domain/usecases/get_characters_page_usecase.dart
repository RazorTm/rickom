import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/paginated_characters.dart';
import '../repositories/character_repository.dart';

class GetCharactersPageUseCase extends UseCase<PaginatedCharacters, int> {
  GetCharactersPageUseCase(this._repository);

  final CharacterRepository _repository;

  @override
  Future<Result<PaginatedCharacters>> call(int params) {
    return _repository.getCharactersPage(params);
  }
}
