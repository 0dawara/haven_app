import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/core/core.dart';
import 'package:haven_app/data/models/models.dart';
import 'package:haven_app/features/settings/cubit/settings_cubit.dart';
import 'package:haven_app/features/wallpaper_search/cubit/search_cubit.dart';

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
    _textController.text = cubit.state.wallQuery.query ?? '';
    cubit.fetchWallpaper();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateCategory(int index, SearchState state) {
    final currentCategories = List<bool>.from(
      state.wallQuery.category ?? [true, true, false],
    );
    currentCategories[index] = !currentCategories[index];

    cubit.fetchWallpaper(
      wallQuery: state.wallQuery.copyWith(
        category: currentCategories,
        query: _textController.text,
        page: 1,
      ),
    );
  }

  void _updatePurity(int index, SearchState state) {
    final currentPurity =
        state.wallQuery.purity?.map((e) => e ?? false).toList() ??
        [true, false, false];
    currentPurity[index] = !currentPurity[index];

    cubit.fetchWallpaper(
      wallQuery: state.wallQuery.copyWith(
        purity: currentPurity.map((e) => e as bool?).toList(),
        query: _textController.text,
        page: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocConsumer<SearchCubit, SearchState>(
          listenWhen: (previous, current) => previous.wallQuery.query != current.wallQuery.query,
          listener: (context, state) {
            if (_textController.text != (state.wallQuery.query ?? '')) {
              _textController.text = state.wallQuery.query ?? '';
            }
          },
          builder: (context, state) {
            final activeSort =
                state.wallQuery.sorting ?? WallpaperSorting.toplist;
            final categories = state.wallQuery.category ?? [true, true, false];
            final purity =
                state.wallQuery.purity?.map((e) => e ?? false).toList() ??
                [true, false, false];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  HomeSearchBar(
                    textController: _textController,
                    onSearchPressed: () {
                      cubit.fetchWallpaper(
                        wallQuery: state.wallQuery.copyWith(
                          query: _textController.text,
                          page: 1,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Primary Filters (Toplist, Hot, Latest, Random)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterTab(
                          label: 'Toplist',
                          isSelected: activeSort == WallpaperSorting.toplist,
                          onTap: () {
                            cubit.fetchWallpaper(
                              wallQuery: state.wallQuery.copyWith(
                                sorting: WallpaperSorting.toplist,
                                query: _textController.text,
                                page: 1,
                              ),
                            );
                          },
                        ),
                        _FilterTab(
                          label: 'Hot',
                          isSelected: activeSort == WallpaperSorting.hot,
                          onTap: () {
                            cubit.fetchWallpaper(
                              wallQuery: state.wallQuery.copyWith(
                                sorting: WallpaperSorting.hot,
                                query: _textController.text,
                                page: 1,
                              ),
                            );
                          },
                        ),
                        _FilterTab(
                          label: 'Latest',
                          isSelected: activeSort == WallpaperSorting.latest,
                          onTap: () {
                            cubit.fetchWallpaper(
                              wallQuery: state.wallQuery.copyWith(
                                sorting: WallpaperSorting.latest,
                                query: _textController.text,
                                page: 1,
                              ),
                            );
                          },
                        ),
                        _FilterTab(
                          label: 'Random',
                          isSelected: activeSort == WallpaperSorting.random,
                          onTap: () {
                            cubit.fetchWallpaper(
                              wallQuery: state.wallQuery.copyWith(
                                sorting: WallpaperSorting.random,
                                query: _textController.text,
                                page: 1,
                              ),
                            );
                          },
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
                          label: 'General',
                          isSelected: categories[0],
                          color: const Color(0xFF3B3542),
                          onTap: () => _updateCategory(0, state),
                        ),
                        const SizedBox(width: 8),
                        _CategoryPill(
                          label: 'Anime',
                          isSelected: categories[1],
                          color: const Color(0xFF3B3542),
                          onTap: () => _updateCategory(1, state),
                        ),
                        const SizedBox(width: 8),
                        _CategoryPill(
                          label: 'People',
                          isSelected: categories[2],
                          color: const Color(0xFF3B3542),
                          onTap: () => _updateCategory(2, state),
                        ),
                        const SizedBox(width: 16),
                        _CategoryPill(
                          label: 'SFW',
                          isSelected: purity[0],
                          color: AppTheme.accentGreen,
                          onTap: () => _updatePurity(0, state),
                        ),
                        const SizedBox(width: 8),
                        _CategoryPill(
                          label: 'Sketchy',
                          isSelected: purity[1],
                          color: AppTheme.accentOrange,
                          onTap: () => _updatePurity(1, state),
                        ),
                        BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (context, settingsState) {
                            if (settingsState.userStatus ==
                                UserStatus.success) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: _CategoryPill(
                                  label: 'NSFW',
                                  isSelected: purity[2],
                                  color: AppTheme.accentRed,
                                  onTap: () => _updatePurity(2, state),
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
                      onRefresh: () async {
                        cubit.fetchWallpaper(
                          wallQuery: state.wallQuery.copyWith(
                            query: _textController.text,
                            page: 1,
                          ),
                        );
                      },
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
