import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/core/utils/app_theme.dart';
import 'package:haven_app/features/wallpaper_details/view/wallpaper_details_page.dart';
import 'package:haven_app/features/wallpaper_search/cubit/search_cubit.dart';

class HomeWallpaperList extends StatefulWidget {
  const HomeWallpaperList({required this.onRefresh, super.key});

  final RefreshCallback onRefresh;

  @override
  State<HomeWallpaperList> createState() => _HomeWallpaperListState();
}

class _HomeWallpaperListState extends State<HomeWallpaperList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      context.read<SearchCubit>().fetchMoreWallpapers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      backgroundColor: AppTheme.cardColor,
      color: AppTheme.primaryPurple,
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          switch (state.status) {
            case SearchStatus.initial:
            case SearchStatus.loading:
              return const Center(child: CircularProgressIndicator.adaptive());
            case SearchStatus.success:
              if (state.wallpaperList.data.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: const Center(
                        child: Text(
                          'No wallpapers found',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 80),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final wallpaper = state.wallpaperList.data[index];
                        final purity = wallpaper.purity.toLowerCase();

                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => WallpaperDetailsPage(
                                id: wallpaper.id,
                                url: wallpaper.path,
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: wallpaper.thumbs.original,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: AppTheme.cardColor,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: AppTheme.cardColor,
                                        child: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      ),
                                ),
                                if (purity == 'nsfw' || purity == 'sketchy')
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: purity == 'nsfw'
                                            ? AppTheme.accentRed
                                            : AppTheme.accentOrange,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                if (wallpaper.colors.isNotEmpty)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: wallpaper.colors.take(5).map((
                                          colorHex,
                                        ) {
                                          final hexCode = colorHex.replaceAll(
                                            '#',
                                            '',
                                          );
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 2,
                                            ),
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                int.parse('0xFF$hexCode'),
                                              ),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white24,
                                                width: 1,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }, childCount: state.wallpaperList.data.length),
                    ),
                  ),
                  if (state.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ),
                ],
              );
            case SearchStatus.failure:
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: const Center(
                      child: Text(
                        'Failed to load wallpaper',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
