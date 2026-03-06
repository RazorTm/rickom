import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations_ext.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/character.dart';
import '../bloc/characters_carousel_bloc.dart';
import '../bloc/characters_carousel_event.dart';
import '../bloc/characters_carousel_state.dart';
import '../widgets/carousel_character_card.dart';

class CharactersCarouselPage extends StatefulWidget {
  const CharactersCarouselPage({super.key});

  @override
  State<CharactersCarouselPage> createState() => _CharactersCarouselPageState();
}

class _CharactersCarouselPageState extends State<CharactersCarouselPage>
    with AutomaticKeepAliveClientMixin<CharactersCarouselPage> {
  late final PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.78)
      ..addListener(_onPageChanged);
    context.read<CharactersCarouselBloc>().add(
      const CharactersCarouselStarted(),
    );
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final l10n = context.l10n;
    return BlocConsumer<CharactersCarouselBloc, CharactersCarouselState>(
      listenWhen: (previous, current) =>
          previous.paginationErrorKey != current.paginationErrorKey &&
          current.paginationErrorKey != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                _localizedError(context, state.paginationErrorKey!),
              ),
            ),
          );
        context.read<CharactersCarouselBloc>().add(
          const CharactersCarouselPaginationErrorShown(),
        );
      },
      builder: (context, state) {
        switch (state.status) {
          case CharactersCarouselStatus.initial:
          case CharactersCarouselStatus.loading:
            return const Center(child: AppLoader(size: 34));
          case CharactersCarouselStatus.error:
            return _ErrorContent(
              message: _localizedError(
                context,
                state.errorKey ?? 'errorUnknown',
              ),
              onRetry: () => context.read<CharactersCarouselBloc>().add(
                const CharactersCarouselRetryRequested(),
              ),
            );
          case CharactersCarouselStatus.success:
          case CharactersCarouselStatus.paginationLoading:
            if (state.characters.isEmpty) {
              return AppEmptyView(message: l10n.emptyCharacters);
            }
            return Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 16),
              child: Column(
                children: [
                  Text(
                    l10n.carouselTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.carouselSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.characters.length,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            final current = _pageController.hasClients
                                ? (_pageController.page ??
                                      _pageController.initialPage.toDouble())
                                : _pageController.initialPage.toDouble();
                            final distance = (current - index).abs();
                            final scale = (1 - (distance * 0.12)).clamp(
                              0.84,
                              1.0,
                            );
                            return Transform.scale(scale: scale, child: child);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CarouselCharacterCard(
                              character: state.characters[index],
                              onTap: () => _showCharacterBottomSheet(
                                context,
                                state.characters[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.status ==
                      CharactersCarouselStatus.paginationLoading)
                    const AppLoader(size: 24, strokeWidth: 2.2)
                  else
                    const SizedBox(height: 24),
                ],
              ),
            );
        }
      },
    );
  }

  void _onPageChanged() {
    if (!_pageController.hasClients) {
      return;
    }
    final page = _pageController.page?.round() ?? 0;
    final state = context.read<CharactersCarouselBloc>().state;
    if (state.hasNext && page >= state.characters.length - 3) {
      context.read<CharactersCarouselBloc>().add(
        const CharactersCarouselLoadNextPage(),
      );
    }
  }

  Future<void> _showCharacterBottomSheet(
    BuildContext context,
    Character character,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                _DetailRow(label: 'ID', value: character.id.toString()),
                _DetailRow(label: 'Status', value: character.status),
                _DetailRow(label: 'Species', value: character.species),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _localizedError(BuildContext context, String key) {
    final l10n = context.l10n;
    switch (key) {
      case 'errorNetwork':
        return l10n.errorNetwork;
      case 'errorServer':
        return l10n.errorServer;
      case 'errorStorage':
        return l10n.errorStorage;
      case 'errorEmptyFields':
        return l10n.errorEmptyFields;
      case 'errorInvalidCredentials':
        return l10n.errorInvalidCredentials;
      default:
        return l10n.errorUnknown;
    }
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: Text(context.l10n.retryButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
