part of 'settings_cubit.dart';

enum UserStatus { initial, loading, success, failure, unavailable }

class SettingsState extends Equatable {
  const SettingsState({this.userStatus = UserStatus.initial, this.apikey = ''});

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    final status =
        (json['userStatus'] == 'success' || json['userStatus'] == 2)
            ? UserStatus.success
            : UserStatus.initial;
    final apikey =
        status == UserStatus.success ? (json['apikey'] as String? ?? '') : '';
    return SettingsState(userStatus: status, apikey: apikey);
  }

  final UserStatus userStatus;
  final String apikey;

  SettingsState copyWith({UserStatus? userStatus, String? apikey}) {
    return SettingsState(
      userStatus: userStatus ?? this.userStatus,
      apikey: apikey ?? this.apikey,
    );
  }

  Map<String, dynamic> toJson() => {
    'userStatus': userStatus.name,
    'apikey': apikey,
  };

  @override
  List<Object?> get props => [userStatus, apikey];
}
