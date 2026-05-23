import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/core/core.dart';
import 'package:haven_app/data/models/models.dart';
import 'package:haven_app/features/wallpaper_details/view/wallpaper_details_page.dart';
import 'package:haven_app/features/wallpaper_search/cubit/search_cubit.dart';

class WallpaperListPage extends StatelessWidget {
  const WallpaperListPage({
    required this.titleModel,
    required this.ctx,
    super.key,
  });

  final BuildContext ctx;
  final HomeSearchTitleModel titleModel;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final cubit = ctx.read<SearchCubit>();

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade50, Colors.cyan.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          forceMaterialTransparency: true,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(titleModel.icon, color: titleModel.iconColor, size: 32),
              const SizedBox(width: 8),
              Text(
                titleModel.searchTitle,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          bloc: cubit,
          builder: (context, state) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _subTitle(length: state.wallpaperList.meta.total),
                    _pageCounter(
                      currentPage: state.wallpaperList.meta.currentPage,
                      lastPage: state.wallpaperList.meta.lastPage,
                      onBackPressed: () async {
                        cubit.updateStatus(SearchStatus.loading);
                        await cubit.fetchWallpaper(
                          wallQuery: cubit.state.wallQuery.copyWith(
                            page: state.wallpaperList.meta.currentPage > 1
                                ? state.wallpaperList.meta.currentPage - 1
                                : state.wallpaperList.meta.currentPage,
                          ),
                        );
                      },
                      onForwardPressed: () async {
                        cubit.updateStatus(SearchStatus.loading);
                        await cubit.fetchWallpaper(
                          wallQuery: cubit.state.wallQuery.copyWith(
                            page:
                                state.wallpaperList.meta.currentPage <
                                    state.wallpaperList.meta.lastPage
                                ? state.wallpaperList.meta.currentPage + 1
                                : state.wallpaperList.meta.currentPage,
                          ),
                        );
                      },
                    ),
                    switch (state.status) {
                      SearchStatus.initial => const Expanded(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      SearchStatus.loading => const Expanded(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      SearchStatus.success => _wallpaperList(
                        mediaSize: mediaSize,
                        data: state.wallpaperList.data,
                      ),
                      SearchStatus.failure => const Center(
                        child: Text('Failed to load wallpapers'),
                      ),
                    },
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _subTitle({required int length}) => Padding(
    padding: const EdgeInsets.all(8),
    child: Center(
      child: Text(
        length > 0
            ? '$length ${length > 1 ? 'wallpapers' : 'wallpaper'} available'
            : 'No wallpaper available',
        style: const TextStyle(fontSize: 20, color: Colors.grey),
      ),
    ),
  );

  Widget _pageCounter({
    required int currentPage,
    required int lastPage,
    required VoidCallback onBackPressed,
    required VoidCallback onForwardPressed,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(CupertinoIcons.chevron_left),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        disabledColor: Colors.transparent,
        color: currentPage > 1 ? null : Colors.transparent,
        onPressed: currentPage > 1 ? onBackPressed : null,
      ),
      const SizedBox(width: 8),
      Text('Page $currentPage of $lastPage'),
      const SizedBox(width: 8),
      IconButton(
        icon: const Icon(CupertinoIcons.chevron_right),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        disabledColor: Colors.transparent,
        color: currentPage < lastPage ? null : Colors.transparent,
        onPressed: currentPage < lastPage ? onForwardPressed : null,
      ),
    ],
  );

  Widget _wallpaperList({
    required Size mediaSize,
    required List<Wallpaper> data,
  }) => Expanded(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GridView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Container(
            width: mediaSize.width * 0.4,
            decoration: data[index].purity.contains('sketchy')
                ? BoxDecoration(
                    border: Border.all(width: 3, color: Colors.yellow),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  )
                : data[index].purity.contains('nsfw')
                ? BoxDecoration(
                    border: Border.all(width: 3, color: Colors.red),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  )
                : null,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: GestureDetector(
                child: data[index].thumbs.original.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: data[index].thumbs.original,
                        filterQuality: FilterQuality.high,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator.adaptive(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.broken_image,
                        color: Colors.white24, size: 32),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => WallpaperDetailsPage(
                      id: data[index].id,
                      url: data[index].path,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: mediaSize.width > 1200
              ? 5
              : mediaSize.width > 800
              ? 4
              : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: mediaSize.height / 3.0,
        ),
      ),
    ),
  );
}
