import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(const AuthState()) {
    on<AuthLoginChanged>(_onLoginChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthSubmitted>(_onSubmitted);
  }

  final LoginUseCase _loginUseCase;

  void _onLoginChanged(AuthLoginChanged event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        login: event.value,
        status: AuthStatus.initial,
        clearErrorKey: true,
      ),
    );
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        password: event.value,
        status: AuthStatus.initial,
        clearErrorKey: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    AuthSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorKey: 'errorEmptyFields',
          hasAttemptedSubmit: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.inProgress,
        clearErrorKey: true,
        hasAttemptedSubmit: true,
      ),
    );

    final result = await _loginUseCase(
      LoginParams(login: state.login.trim(), password: state.password),
    );

    result.when(
      success: (_) {
        emit(state.copyWith(status: AuthStatus.success, clearErrorKey: true));
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorKey: failure.messageKey,
          ),
        );
      },
    );
  }
}
