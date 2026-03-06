import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations_ext.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.onLogoutPressed});

  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final isRu = state.locale.languageCode == 'ru';
        final selectedTheme = switch (state.themeMode) {
          ThemeMode.light => {'light'},
          ThemeMode.dark => {'dark'},
          ThemeMode.system => <String>{},
        };

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.settingsTheme,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<String>(
                  emptySelectionAllowed: true,
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(
                      Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  segments: [
                    ButtonSegment(
                      value: 'light',
                      label: Text(l10n.settingsThemeLight),
                      icon: const Icon(Icons.light_mode_rounded),
                    ),
                    ButtonSegment(
                      value: 'dark',
                      label: Text(l10n.settingsThemeDark),
                      icon: const Icon(Icons.dark_mode_rounded),
                    ),
                  ],
                  selected: selectedTheme,
                  onSelectionChanged: (selection) {
                    if (selection.isEmpty) {
                      return;
                    }
                    final mode = selection.first == 'dark'
                        ? ThemeMode.dark
                        : ThemeMode.light;
                    context.read<SettingsBloc>().add(ThemeModeChanged(mode));
                  },
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              l10n.settingsLanguage,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<String>(
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(
                      Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  segments: [
                    ButtonSegment(
                      value: 'en',
                      label: Text(l10n.settingsLanguageEnglish),
                    ),
                    ButtonSegment(
                      value: 'ru',
                      label: Text(l10n.settingsLanguageRussian),
                    ),
                  ],
                  selected: {isRu ? 'ru' : 'en'},
                  onSelectionChanged: (selection) {
                    final value = selection.first;
                    context.read<SettingsBloc>().add(
                      LocaleChanged(Locale(value)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.tonalIcon(
              onPressed: onLogoutPressed,
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.logoutButton),
            ),
            if (state.errorKey != null) ...[
              const SizedBox(height: 14),
              Text(
                _localizedError(context, state.errorKey!),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  String _localizedError(BuildContext context, String key) {
    final l10n = context.l10n;
    switch (key) {
      case 'errorStorage':
        return l10n.errorStorage;
      case 'errorNetwork':
        return l10n.errorNetwork;
      case 'errorServer':
        return l10n.errorServer;
      default:
        return l10n.errorUnknown;
    }
  }
}
