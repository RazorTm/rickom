import 'package:flutter/material.dart';
import 'package:rickom/l10n/app_localizations.dart';

import '../../../../core/localization/app_localizations_ext.dart';
import '../../../../core/router/app_router.dart';
import '../../../characters/presentation/pages/characters_carousel_page.dart';
import '../../../characters/presentation/pages/characters_list_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const CharactersListPage(),
      const CharactersCarouselPage(),
      SettingsPage(onLogoutPressed: _onLogoutPressed),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_titleByIndex(l10n, _selectedIndex)),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.groups_outlined),
              selectedIcon: const Icon(Icons.groups_rounded),
              label: l10n.navCharacters,
            ),
            NavigationDestination(
              icon: const Icon(Icons.view_carousel_outlined),
              selectedIcon: const Icon(Icons.view_carousel_rounded),
              label: l10n.navCarousel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.tune_outlined),
              selectedIcon: const Icon(Icons.tune_rounded),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }

  String _titleByIndex(AppLocalizations l10n, int index) {
    return switch (index) {
      0 => l10n.charactersListTitle,
      1 => l10n.carouselScreenTitle,
      _ => l10n.settingsScreenTitle,
    };
  }

  void _onLogoutPressed() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
  }
}
