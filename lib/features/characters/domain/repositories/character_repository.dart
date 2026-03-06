import '../../../../core/utils/result.dart';
import '../entities/paginated_characters.dart';

abstract interface class CharacterRepository {
  Future<Result<PaginatedCharacters>> getCharactersPage(int page);
}
