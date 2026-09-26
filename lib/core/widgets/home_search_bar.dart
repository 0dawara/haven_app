import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({
    required this.textController,
    required this.onSearchPressed,
    super.key,
  });

  final TextEditingController textController;
  final VoidCallback onSearchPressed;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  bool showClearButton = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF25222A), // Dark card color
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.textController,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search wallpapers, tags...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: widget.textController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: () {
                            widget.textController.clear();
                            setState(() => showClearButton = false);
                            widget.onSearchPressed();
                          },
                        ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => widget.onSearchPressed(),
                onChanged: (text) =>
                    setState(() => showClearButton = text.isNotEmpty),
              ),
            ),
            const VerticalDivider(width: 1, color: Colors.white24),
            IconButton(
              icon: const Icon(CupertinoIcons.search),
              color: Colors.grey,
              onPressed: widget.onSearchPressed,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
      ),
    );
  }
}
