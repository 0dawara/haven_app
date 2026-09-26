import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven/core/core.dart';
import 'package:haven/data/models/models.dart';
import 'package:haven/features/settings/cubit/settings_cubit.dart';
import 'package:haven/features/wallpaper_search/cubit/search_cubit.dart';
import 'package:haven/l10n/l10n.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SearchCubit get cubit => context.read<SearchCubit>();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = cubit.state.wallQuery.query;
    cubit.fetchWallpaper();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocConsumer<SearchCubit, SearchState>(
          listenWhen: (previous, current) =>
              previous.wallQuery.query != current.wallQuery.query,
          listener: (context, state) {
            if (_textController.text != state.wallQuery.query) {
              _textController.text = state.wallQuery.query;
            }
          },
          builder: (context, state) {
            final activeSort = state.wallQuery.sorting;
            final categories = state.wallQuery.category;
            final purity = state.wallQuery.purity;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  HomeSearchBar(
                    textController: _textController,
                    onSearchPressed: () => cubit.search(_textController.text),
                  ),
                  const SizedBox(height: 24),
                  // Primary Filters (Toplist, Hot, Latest, Random)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterTab(
                          label: context.l10n.sortToplist,
                          isSelected: activeSort == WallpaperSorting.toplist,
                          onTap: () => cubit.setSorting(
                            WallpaperSorting.toplist,
                            query: _textController.text,
                          ),
                        ),
                        _FilterTab(
                          label: context.l10n.sortHot,
                          isSelected: activeSort == WallpaperSorting.hot,
                          onTap: () => cubit.setSorting(
                            WallpaperSorting.hot,
                            query: _textController.text,
                          ),
                        ),
                        _FilterTab(
                          label: context.l10n.sortLatest,
                          isSelected: activeSort == WallpaperSorting.latest,
                          onTap: () => cubit.setSorting(
                            WallpaperSorting.latest,
                            query: _textController.text,
                          ),
                        ),
                        _FilterTab(
                          label: context.l10n.sortRandom,
                          isSelected: activeSort == WallpaperSorting.random,
                          onTap: () => cubit.setSorting(
                            WallpaperSorting.random,
                            query: _textController.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Secondary Filters (Categories & Purity)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryPill(
                          label: context.l10n.categoryGeneral,
                          isSelected: categories[0],
                          color: const Color(0xFF3B3542),
                          onTap: () => cubit.toggleCategory(
                            0,
                            query: _textController.text,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _CategoryPill(
                          label: context.l10n.categoryAnime,
                          isSelected: categories[1],
                          color: const Color(0xFF3B3542),
                          onTap: () => cubit.toggleCategory(
                            1,
                            query: _textController.text,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _CategoryPill(
                          label: context.l10n.categoryPeople,
                          isSelected: categories[2],
                          color: const Color(0xFF3B3542),
                          onTap: () => cubit.toggleCategory(
                            2,
                            query: _textController.text,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _CategoryPill(
                          label: context.l10n.puritySfw,
                          isSelected: purity[0],
                          color: AppTheme.accentGreen,
                          onTap: () =>
                              cubit.togglePurity(0, query: _textController.text),
                        ),
                        const SizedBox(width: 8),
                        _CategoryPill(
                          label: context.l10n.puritySketchy,
                          isSelected: purity[1],
                          color: AppTheme.accentOrange,
                          onTap: () =>
                              cubit.togglePurity(1, query: _textController.text),
                        ),
                        BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (context, settingsState) {
                            if (settingsState.userStatus ==
                                UserStatus.success) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: _CategoryPill(
                                  label: context.l10n.purityNsfw,
                                  isSelected: purity[2],
                                  color: AppTheme.accentRed,
                                  onTap: () => cubit.togglePurity(
                                    2,
                                    query: _textController.text,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Wallpaper Grid
                  Expanded(
                    child: HomeWallpaperList(
                      onRefresh: () =>
                          cubit.refresh(query: _textController.text),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback? onTap;

  const _CategoryPill({
    required this.label,
    required this.isSelected,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isSelected ? 1.0 : 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.5),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
