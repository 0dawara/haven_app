import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/core/utils/app_theme.dart';
import 'package:haven/l10n/l10n.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        theme: AppTheme.themeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}
