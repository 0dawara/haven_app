import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven/features/settings/cubit/settings_cubit.dart';
import 'package:haven/l10n/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsCubit get settingsCubit => context.read<SettingsCubit>();

  final _textController = TextEditingController();
  bool _obscureKey = true;


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
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 64),
              child: Text(
                context.l10n.settingsTitle,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                context.l10n.settingsSubtitle,
                style: const TextStyle(fontSize: 20, color: Colors.grey),
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
                            decoration: InputDecoration(
                              hintText: context.l10n.settingsApiKeyHint,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                tooltip: _obscureKey
                                    ? context.l10n.tooltipShowKey
                                    : context.l10n.tooltipHideKey,
                                icon: Icon(
                                  _obscureKey
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureKey = !_obscureKey;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureKey,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        IconButton(
                          tooltip: context.l10n.tooltipPaste,
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
                        IconButton(
                          tooltip: context.l10n.tooltipClear,
                          onPressed: () {
                            _textController.clear();
                            settingsCubit.clearApikey();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () =>
                            settingsCubit.validateApikey(_textController.text),
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
                        child: Text(context.l10n.settingsValidate),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        switch (state.userStatus) {
                          case UserStatus.initial:
                            return const SizedBox.shrink();
                          case UserStatus.loading:
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          case UserStatus.failure:
                            return Center(
                              child: Text(
                                context.l10n.settingsKeyInvalid,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          case UserStatus.unavailable:
                            return Center(
                              child: Text(
                                context.l10n.settingsUnavailable,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          case UserStatus.success:
                            return Center(
                              child: Text(
                                context.l10n.settingsKeyValid,
                                style: const TextStyle(
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
