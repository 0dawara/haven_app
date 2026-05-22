import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/core/utils/utils.dart';
import 'package:haven_app/features/wallpaper_search/cubit/search_cubit.dart';

class HomeColorsToneList extends StatelessWidget {
  const HomeColorsToneList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'The color tone',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.initial:
              case SearchStatus.loading:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case SearchStatus.success:
                return SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: state.colorsData.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final tooltipkey = GlobalKey<TooltipState>();

                      return Tooltip(
                        key: tooltipkey,
                        message:
                            'Color ${state.colorsData.keys.elementAt(index)}\ncopied to clipboard',
                        textAlign: TextAlign.center,
                        margin: const EdgeInsets.only(top: 8),
                        triggerMode: TooltipTriggerMode.tap,
                        child: GestureDetector(
                          onTap: () =>
                              Clipboard.setData(
                                ClipboardData(
                                  text: state.colorsData.keys.elementAt(index),
                                ),
                              ).whenComplete(
                                () => tooltipkey.currentState
                                    ?.ensureTooltipVisible(),
                              ),
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.only(right: 16),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: Container(
                                color: HexColor.fromHex(
                                  state.colorsData.keys.elementAt(index),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              case SearchStatus.failure:
                return const Center(child: Text('Failed to load colors'));
            }
          },
        ),
      ],
    );
  }
}
