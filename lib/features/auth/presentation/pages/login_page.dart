import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations_ext.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.2),
              theme.colorScheme.secondary.withValues(alpha: 0.13),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status &&
                      current.status == AuthStatus.success,
                  listener: (context, state) {
                    Navigator.of(context).pushReplacementNamed(AppRouter.main);
                  },
                  builder: (context, state) {
                    final l10n = context.l10n;
                    return Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoginHeader(
                              title: l10n.loginTitle,
                              subtitle: l10n.loginSubtitle,
                            ),
                            const SizedBox(height: 28),
                            TextField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => context
                                  .read<AuthBloc>()
                                  .add(AuthLoginChanged(value)),
                              decoration: InputDecoration(
                                labelText: l10n.loginFieldLabel,
                                hintText: l10n.loginFieldHint,
                                errorText:
                                    state.hasAttemptedSubmit &&
                                        !state.isLoginValid
                                    ? l10n.validationRequired
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => context.read<AuthBloc>().add(
                                const AuthSubmitted(),
                              ),
                              onChanged: (value) => context
                                  .read<AuthBloc>()
                                  .add(AuthPasswordChanged(value)),
                              decoration: InputDecoration(
                                labelText: l10n.passwordFieldLabel,
                                hintText: l10n.passwordFieldHint,
                                errorText:
                                    state.hasAttemptedSubmit &&
                                        !state.isPasswordValid
                                    ? l10n.validationRequired
                                    : null,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: state.errorKey == null
                                  ? const SizedBox(height: 18)
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text(
                                        _localizedError(
                                          context,
                                          state.errorKey!,
                                        ),
                                        key: ValueKey(state.errorKey),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.error,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: state.status == AuthStatus.inProgress
                                    ? null
                                    : () => context.read<AuthBloc>().add(
                                        const AuthSubmitted(),
                                      ),
                                child: state.status == AuthStatus.inProgress
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                        ),
                                      )
                                    : Text(l10n.loginButton),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _localizedError(BuildContext context, String key) {
    final l10n = context.l10n;
    switch (key) {
      case 'errorInvalidCredentials':
        return l10n.errorInvalidCredentials;
      case 'errorEmptyFields':
        return l10n.errorEmptyFields;
      case 'errorNetwork':
        return l10n.errorNetwork;
      case 'errorServer':
        return l10n.errorServer;
      case 'errorStorage':
        return l10n.errorStorage;
      default:
        return l10n.errorUnknown;
    }
  }
}
