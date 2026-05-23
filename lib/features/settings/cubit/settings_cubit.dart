import 'package:equatable/equatable.dart';
import 'package:haven_app/data/data.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit(this._wallhavenRepository) : super(const SettingsState());

  final WallhavenRepository _wallhavenRepository;
  static final _logger = Logger('SettingsCubit');

  Future<void> validateApikey(String apikey) async {
    emit(state.copyWith(userStatus: UserStatus.loading));

    try {
      await _wallhavenRepository.apikeyValidation(apikey: apikey);
      emit(state.copyWith(userStatus: UserStatus.success, apikey: apikey));
    } catch (e) {
      _logger.severe('Failed to validate apikey', e);
      emit(state.copyWith(userStatus: UserStatus.failure));
    }
  }

  void clearApikey() {
    emit(const SettingsState());
  }

  @override
  SettingsState fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(SettingsState state) => state.toJson();
}
