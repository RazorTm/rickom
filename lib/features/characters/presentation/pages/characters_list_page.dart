import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations_ext.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/character.dart';
import '../bloc/characters_list_bloc.dart';
import '../bloc/characters_list_event.dart';
import '../bloc/characters_list_state.dart';
import '../widgets/character_list_card.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({super.key});

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage>
    with AutomaticKeepAliveClientMixin<CharactersListPage> {
  late final ScrollController _scrollController;
  final Random _random = Random();
  bool _showScrollToTopButton = false;
  String? _headerImageUrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<CharactersListBloc>().add(const CharactersListStarted());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<CharactersListBloc, CharactersListState>(
      listenWhen: (previous, current) =>
          (previous.paginationErrorKey != current.paginationErrorKey &&
              current.paginationErrorKey != null) ||
          current.page == 1,
      listener: (context, state) {
        if (state.paginationErrorKey != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  _localizedError(context, state.paginationErrorKey!),
                ),
              ),
            );
          context.read<CharactersListBloc>().add(
            const CharactersListPaginationErrorShown(),
          );
        }
        if (state.page == 1 && state.characters.isNotEmpty) {
          _headerImageUrl =
              state.characters[_random.nextInt(state.characters.length)].image;
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case CharactersListStatus.initial:
          case CharactersListStatus.loading:
            return const Center(child: AppLoader(size: 34));
          case CharactersListStatus.error:
            return _ErrorContent(
              message: _localizedError(
                context,
                state.errorKey ?? 'errorUnknown',
              ),
              onRetry: () => context.read<CharactersListBloc>().add(
                const CharactersListRetryRequested(),
              ),
            );
          case CharactersListStatus.success:
          case CharactersListStatus.paginationLoading:
            if (state.characters.isEmpty) {
              return AppEmptyView(message: context.l10n.emptyCharacters);
            }
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    context.read<CharactersListBloc>().add(
                      const CharactersListRetryRequested(),
                    );
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        primary: false,
                        pinned: true,
                        stretch: true,
                        toolbarHeight: 0,
                        collapsedHeight: 0,
                        expandedHeight: 240,
                        flexibleSpace: FlexibleSpaceBar(
                          stretchModes: const [
                            StretchMode.zoomBackground,
                            StretchMode.blurBackground,
                          ],
                          background: _SliverHeaderBackground(
                            imageUrl: _headerImageUrl,
                            fallbackImageUrl: state.characters.first.image,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 8)),
                      SliverList.builder(
                        itemCount: state.characters.length,
                        itemBuilder: (context, index) {
                          final character = state.characters[index];
                          return CharacterListCard(
                            character: character,
                            onTap: () =>
                                _showCharacterDialog(context, character),
                          );
                        },
                      ),
                      SliverToBoxAdapter(
                        child:
                            state.status ==
                                CharactersListStatus.paginationLoading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 18),
                                child: Center(
                                  child: AppLoader(size: 26, strokeWidth: 2.2),
                                ),
                              )
                            : const SizedBox(height: 20),
                      ),
                    ],
                  ),
                ),
                if (_showScrollToTopButton)
                  Positioned(
                    right: 18,
                    bottom: 18,
                    child: FloatingActionButton.small(
                      onPressed: () {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(0);
                        }
                      },
                      child: const Icon(Icons.keyboard_arrow_up_rounded),
                    ),
                  ),
              ],
            );
        }
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final shouldShowButton = _scrollController.offset > 220;
    if (shouldShowButton != _showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = shouldShowButton;
      });
    }

    final threshold = _scrollController.position.maxScrollExtent - 360;
    if (_scrollController.position.pixels >= threshold) {
      context.read<CharactersListBloc>().add(
        const CharactersListLoadNextPage(),
      );
    }
  }

  Future<void> _showCharacterDialog(BuildContext context, Character character) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.45,
                    child: CachedNetworkImage(
                      imageUrl: character.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        character.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _DetailRow(label: 'ID', value: character.id.toString()),
                      _DetailRow(label: 'Status', value: character.status),
                      _DetailRow(label: 'Species', value: character.species),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ),
                    ],
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

class _SliverHeaderBackground extends StatelessWidget {
  const _SliverHeaderBackground({
    required this.imageUrl,
    required this.fallbackImageUrl,
  });

  final String? imageUrl;
  final String fallbackImageUrl;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = imageUrl ?? fallbackImageUrl;
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: resolvedUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.55),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
