// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Haven App';

  @override
  String get navHome => 'Home';

  @override
  String get navSaved => 'Saved';

  @override
  String get navProfile => 'Profile';

  @override
  String get sortToplist => 'Toplist';

  @override
  String get sortHot => 'Hot';

  @override
  String get sortLatest => 'Latest';

  @override
  String get sortRandom => 'Random';

  @override
  String get categoryGeneral => 'General';

  @override
  String get categoryAnime => 'Anime';

  @override
  String get categoryPeople => 'People';

  @override
  String get puritySfw => 'SFW';

  @override
  String get puritySketchy => 'Sketchy';

  @override
  String get purityNsfw => 'NSFW';

  @override
  String get searchHint => 'Search wallpapers, tags...';

  @override
  String get noWallpapersFound => 'Wallhaven is having a moment';

  @override
  String get goToPageTitle => 'Go to page';

  @override
  String get cancel => 'Cancel';

  @override
  String get go => 'Go';

  @override
  String pageOf(int current, int last) {
    return 'Page $current of $last';
  }

  @override
  String get apiErrorTitle => 'Wallhaven is having a moment';

  @override
  String get apiErrorMessage =>
      'We\'re having trouble reaching the servers right now. Check your connection or try again shortly.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get detailsUploader => 'Uploader';

  @override
  String get detailsSaveWallpaper => 'Save Wallpaper';

  @override
  String get detailsLoadFailed => 'Couldn\'t load wallpaper details';

  @override
  String get actionInfo => 'Info';

  @override
  String get actionShare => 'Share';

  @override
  String get shareTitle => 'Share';

  @override
  String get shareQuestion => 'How do you want to share the image?';

  @override
  String get shareFile => 'File';

  @override
  String get shareLink => 'Link';

  @override
  String get shareFailed => 'Couldn\'t share the wallpaper';

  @override
  String get saveTitle => 'Save';

  @override
  String get downloadPreparing => 'Getting pictures folder...';

  @override
  String downloadProgress(int percent) {
    return 'Downloading image... $percent%';
  }

  @override
  String get downloadIndeterminate => 'Downloading image...';

  @override
  String get downloadAlreadyExists => 'Image already downloaded!';

  @override
  String get downloadSuccess => 'Image downloaded at Pictures/wallhaven/';

  @override
  String get downloadPermissionDenied => 'Storage permission denied';

  @override
  String get downloadUnsupported => 'Please use the Share button!';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String get savedTitle => 'Saved';

  @override
  String savedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wallpapers that you saved',
      one: 'A wallpaper you saved',
    );
    return '$_temp0';
  }

  @override
  String get savedLoading => 'Loading wallpapers...';

  @override
  String get savedEmpty => 'Can\'t find any saved wallpaper';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Enter your API key below';

  @override
  String get settingsApiKeyHint => 'Wallhaven API Key';

  @override
  String get settingsValidate => 'Validate';

  @override
  String get settingsKeyInvalid => 'API key is not valid';

  @override
  String get settingsKeyValid => 'You\'re good to go!';

  @override
  String get settingsUnavailable =>
      'Couldn\'t reach Wallhaven. Try again later.';

  @override
  String get infoId => 'id';

  @override
  String get infoUploader => 'uploader';

  @override
  String get infoCategory => 'category';

  @override
  String get infoResolution => 'resolution';

  @override
  String get infoType => 'type';

  @override
  String get infoSize => 'size';

  @override
  String get infoViews => 'views';

  @override
  String get infoFavorites => 'favorites';

  @override
  String get infoLink => 'link';

  @override
  String get infoDateAdded => 'date added';

  @override
  String get infoColors => 'colors';

  @override
  String get infoTags => 'tags';

  @override
  String colorCopied(String color) {
    return 'Color $color copied to clipboard';
  }

  @override
  String get tooltipBack => 'Back';

  @override
  String get tooltipToggleFit => 'Toggle fit';

  @override
  String get tooltipShowKey => 'Show API key';

  @override
  String get tooltipHideKey => 'Hide API key';

  @override
  String get tooltipPaste => 'Paste from clipboard';

  @override
  String get tooltipClear => 'Clear API key';

  @override
  String get tooltipSearch => 'Search';

  @override
  String get tooltipClearSearch => 'Clear search';

  @override
  String get tooltipPreviousPage => 'Previous page';

  @override
  String get tooltipNextPage => 'Next page';
}
