import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' hide RefreshCallback;
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

  @override
  void dispose() {
    super.dispose();
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
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 20),
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
                                wallpaper.thumbs.original.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: wallpaper.thumbs.original,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              color: AppTheme.cardColor,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
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
                                      )
                                    : Container(
                                        color: AppTheme.cardColor,
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.white24,
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: _PageNavigation(
                        currentPage: state.wallpaperList.meta.currentPage,
                        lastPage: state.wallpaperList.meta.lastPage,
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

class _PageNavigation extends StatelessWidget {
  const _PageNavigation({
    required this.currentPage,
    required this.lastPage,
  });

  final int currentPage;
  final int lastPage;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: currentPage > 1
              ? () {
                  cubit.fetchWallpaper(
                    wallQuery: cubit.state.wallQuery.copyWith(
                      page: currentPage - 1,
                    ),
                  );
                }
              : null,
        ),
        const SizedBox(width: 16),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            final page = await showDialog<int>(
              context: context,
              builder: (context) {
                int selectedPage = currentPage;
                return AlertDialog(
                  backgroundColor: AppTheme.cardColor,
                  title: const Text('Go to page', style: TextStyle(color: Colors.white)),
                  content: SizedBox(
                    height: 200,
                    child: CupertinoPicker.builder(
                      scrollController: FixedExtentScrollController(
                        initialItem: currentPage - 1,
                      ),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        selectedPage = index + 1;
                      },
                      childCount: lastPage,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(selectedPage),
                      child: const Text('Go', style: TextStyle(color: AppTheme.primaryPurple)),
                    ),
                  ],
                );
              },
            );

            if (page != null && page != currentPage && context.mounted) {
              cubit.fetchWallpaper(
                wallQuery: cubit.state.wallQuery.copyWith(page: page),
              );
            }
          },
          child: Text(
            'Page $currentPage of $lastPage',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: currentPage < lastPage
              ? () {
                  cubit.fetchWallpaper(
                    wallQuery: cubit.state.wallQuery.copyWith(
                      page: currentPage + 1,
                    ),
                  );
                }
              : null,
        ),
      ],
    );
  }
}
