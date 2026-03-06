import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/characters/presentation/bloc/characters_carousel_bloc.dart';
import '../../features/characters/presentation/bloc/characters_list_bloc.dart';
import '../../features/home/presentation/pages/main_shell_page.dart';
import '../di/injection_container.dart';

abstract final class AppRouter {
  static const String login = '/login';
  static const String main = '/main';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider<AuthBloc>(
            create: (_) => sl<AuthBloc>(),
            child: const LoginPage(),
          ),
          settings: settings,
        );
      case main:
        return MaterialPageRoute<void>(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<CharactersListBloc>(
                create: (_) => sl<CharactersListBloc>(),
              ),
              BlocProvider<CharactersCarouselBloc>(
                create: (_) => sl<CharactersCarouselBloc>(),
              ),
            ],
            child: const MainShellPage(),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider<AuthBloc>(
            create: (_) => sl<AuthBloc>(),
            child: const LoginPage(),
          ),
          settings: settings,
        );
    }
  }
}
