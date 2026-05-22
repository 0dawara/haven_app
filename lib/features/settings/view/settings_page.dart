import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/features/settings/cubit/settings_cubit.dart';
import 'package:haven_app/features/wallpaper_search/cubit/search_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsCubit get settingsCubit => context.read<SettingsCubit>();
  SearchCubit get searchCubit => context.read<SearchCubit>();

  final _textController = TextEditingController();

  Future<void> apikeyValidation() async {
    final value = _textController.text;

    await settingsCubit.validateApikey(value);

    if (settingsCubit.state.userStatus == UserStatus.success) {
      final purity =
          searchCubit.state.wallQuery.purity?.toList() ?? [true, false, null];

      if (purity.last == null) {
        purity.last = false;
      }

      searchCubit.updateWallpaperQuery(
        searchCubit.state.wallQuery.copyWith(purity: purity, apikey: value),
      );
    } else {
      final purity =
          searchCubit.state.wallQuery.purity?.toList() ?? [true, false, null];

      if (purity.last != null) {
        purity.last = null;
      }

      searchCubit.updateWallpaperQuery(
        searchCubit.state.wallQuery.copyWith(purity: purity, apikey: ''),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _textController.text = settingsCubit.state.apikey;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 64),
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Text(
                'Insert your API key here',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: const InputDecoration(
                              hintText: 'API key',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final data = await Clipboard.getData('text/plain');
                            if (data != null && data.text != null) {
                              setState(() {
                                _textController.text = data.text!;
                              });
                            }
                          },
                          icon: const Icon(Icons.paste_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async => apikeyValidation(),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(16),
                          ),
                        ),
                        child: const Text('Validate'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        switch (state.userStatus) {
                          case UserStatus.initial:
                            return Container();
                          case UserStatus.loading:
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          case UserStatus.failure:
                            return const Center(
                              child: Text(
                                'Apikey is not valid',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          case UserStatus.success:
                            return const Center(
                              child: Text(
                                "You're good to go!",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
