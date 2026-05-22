part of 'settings_cubit.dart';

enum UserStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({this.userStatus = UserStatus.initial, this.apikey = ''});

  factory SettingsState.fromJson(Map<String, dynamic> json) => SettingsState(
    userStatus: UserStatus.values[json['userStatus'] as int? ?? 0],
    apikey: json['apikey'] as String? ?? '',
  );

  final UserStatus userStatus;
  final String apikey;

  SettingsState copyWith({UserStatus? userStatus, String? apikey}) {
    return SettingsState(
      userStatus: userStatus ?? this.userStatus,
      apikey: apikey ?? this.apikey,
    );
  }

  Map<String, dynamic> toJson() => {
    'userStatus': userStatus.index,
    'apikey': apikey,
  };

  @override
  List<Object?> get props => [userStatus, apikey];
}
