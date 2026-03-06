import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/characters_page_model.dart';

abstract interface class CharactersRemoteDataSource {
  Future<CharactersPageModel> getCharactersPage(int page);
}

class CharactersRemoteDataSourceImpl implements CharactersRemoteDataSource {
  CharactersRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<CharactersPageModel> getCharactersPage(int page) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiConstants.charactersEndpoint,
        queryParameters: {'page': page},
      );

      final data = response.data;
      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        return CharactersPageModel.fromJson(json: data, page: page);
      }
      throw const ServerException();
    } on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        throw const ServerException();
      }
      throw const NetworkException();
    } on FormatException {
      throw const ServerException();
    }
  }
}
