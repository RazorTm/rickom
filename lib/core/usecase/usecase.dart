import 'package:equatable/equatable.dart';

import '../utils/result.dart';

abstract class UseCase<Output, Params> {
  Future<Result<Output>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
