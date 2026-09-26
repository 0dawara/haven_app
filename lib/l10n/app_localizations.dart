import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Haven App'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @sortToplist.
  ///
  /// In en, this message translates to:
  /// **'Toplist'**
  String get sortToplist;

  /// No description provided for @sortHot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get sortHot;

  /// No description provided for @sortLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get sortLatest;

  /// No description provided for @sortRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get sortRandom;

  /// No description provided for @categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get categoryGeneral;

  /// No description provided for @categoryAnime.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get categoryAnime;

  /// No description provided for @categoryPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get categoryPeople;

  /// No description provided for @puritySfw.
  ///
  /// In en, this message translates to:
  /// **'SFW'**
  String get puritySfw;

  /// No description provided for @puritySketchy.
  ///
  /// In en, this message translates to:
  /// **'Sketchy'**
  String get puritySketchy;

  /// No description provided for @purityNsfw.
  ///
  /// In en, this message translates to:
  /// **'NSFW'**
  String get purityNsfw;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search wallpapers, tags...'**
  String get searchHint;

  /// No description provided for @noWallpapersFound.
  ///
  /// In en, this message translates to:
  /// **'Wallhaven is having a moment'**
  String get noWallpapersFound;

  /// No description provided for @goToPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Go to page'**
  String get goToPageTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {last}'**
  String pageOf(int current, int last);

  /// No description provided for @apiErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallhaven is having a moment'**
  String get apiErrorTitle;

  /// No description provided for @apiErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'re having trouble reaching the servers right now. Check your connection or try again shortly.'**
  String get apiErrorMessage;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @detailsUploader.
  ///
  /// In en, this message translates to:
  /// **'Uploader'**
  String get detailsUploader;

  /// No description provided for @detailsSaveWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Save Wallpaper'**
  String get detailsSaveWallpaper;

  /// No description provided for @detailsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load wallpaper details'**
  String get detailsLoadFailed;

  /// No description provided for @actionInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get actionInfo;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTitle;

  /// No description provided for @shareQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do you want to share the image?'**
  String get shareQuestion;

  /// No description provided for @shareFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get shareFile;

  /// No description provided for @shareLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get shareLink;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t share the wallpaper'**
  String get shareFailed;

  /// No description provided for @saveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveTitle;

  /// No description provided for @downloadPreparing.
  ///
  /// In en, this message translates to:
  /// **'Getting pictures folder...'**
  String get downloadPreparing;

  /// No description provided for @downloadProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading image... {percent}%'**
  String downloadProgress(int percent);

  /// No description provided for @downloadIndeterminate.
  ///
  /// In en, this message translates to:
  /// **'Downloading image...'**
  String get downloadIndeterminate;

  /// No description provided for @downloadAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Image already downloaded!'**
  String get downloadAlreadyExists;

  /// No description provided for @downloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Image downloaded at Pictures/wallhaven/'**
  String get downloadSuccess;

  /// No description provided for @downloadPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied'**
  String get downloadPermissionDenied;

  /// No description provided for @downloadUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Please use the Share button!'**
  String get downloadUnsupported;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{A wallpaper you saved} other{{count} wallpapers that you saved}}'**
  String savedCount(int count);

  /// No description provided for @savedLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading wallpapers...'**
  String get savedLoading;

  /// No description provided for @savedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find any saved wallpaper'**
  String get savedEmpty;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your API key below'**
  String get settingsSubtitle;

  /// No description provided for @settingsApiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Wallhaven API Key'**
  String get settingsApiKeyHint;

  /// No description provided for @settingsValidate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get settingsValidate;

  /// No description provided for @settingsKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'API key is not valid'**
  String get settingsKeyInvalid;

  /// No description provided for @settingsKeyValid.
  ///
  /// In en, this message translates to:
  /// **'You\'re good to go!'**
  String get settingsKeyValid;

  /// No description provided for @settingsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach Wallhaven. Try again later.'**
  String get settingsUnavailable;

  /// No description provided for @infoId.
  ///
  /// In en, this message translates to:
  /// **'id'**
  String get infoId;

  /// No description provided for @infoUploader.
  ///
  /// In en, this message translates to:
  /// **'uploader'**
  String get infoUploader;

  /// No description provided for @infoCategory.
  ///
  /// In en, this message translates to:
  /// **'category'**
  String get infoCategory;

  /// No description provided for @infoResolution.
  ///
  /// In en, this message translates to:
  /// **'resolution'**
  String get infoResolution;

  /// No description provided for @infoType.
  ///
  /// In en, this message translates to:
  /// **'type'**
  String get infoType;

  /// No description provided for @infoSize.
  ///
  /// In en, this message translates to:
  /// **'size'**
  String get infoSize;

  /// No description provided for @infoViews.
  ///
  /// In en, this message translates to:
  /// **'views'**
  String get infoViews;

  /// No description provided for @infoFavorites.
  ///
  /// In en, this message translates to:
  /// **'favorites'**
  String get infoFavorites;

  /// No description provided for @infoLink.
  ///
  /// In en, this message translates to:
  /// **'link'**
  String get infoLink;

  /// No description provided for @infoDateAdded.
  ///
  /// In en, this message translates to:
  /// **'date added'**
  String get infoDateAdded;

  /// No description provided for @infoColors.
  ///
  /// In en, this message translates to:
  /// **'colors'**
  String get infoColors;

  /// No description provided for @infoTags.
  ///
  /// In en, this message translates to:
  /// **'tags'**
  String get infoTags;

  /// No description provided for @colorCopied.
  ///
  /// In en, this message translates to:
  /// **'Color {color} copied to clipboard'**
  String colorCopied(String color);

  /// No description provided for @tooltipBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tooltipBack;

  /// No description provided for @tooltipToggleFit.
  ///
  /// In en, this message translates to:
  /// **'Toggle fit'**
  String get tooltipToggleFit;

  /// No description provided for @tooltipShowKey.
  ///
  /// In en, this message translates to:
  /// **'Show API key'**
  String get tooltipShowKey;

  /// No description provided for @tooltipHideKey.
  ///
  /// In en, this message translates to:
  /// **'Hide API key'**
  String get tooltipHideKey;

  /// No description provided for @tooltipPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get tooltipPaste;

  /// No description provided for @tooltipClear.
  ///
  /// In en, this message translates to:
  /// **'Clear API key'**
  String get tooltipClear;

  /// No description provided for @tooltipSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tooltipSearch;

  /// No description provided for @tooltipClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get tooltipClearSearch;

  /// No description provided for @tooltipPreviousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get tooltipPreviousPage;

  /// No description provided for @tooltipNextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get tooltipNextPage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
