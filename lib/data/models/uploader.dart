import 'package:equatable/equatable.dart';
import 'package:haven_app/data/models/avatar.dart';

class Uploader extends Equatable {
  const Uploader({
    required this.username,
    required this.group,
    required this.avatar,
  });

  factory Uploader.fromJson(Map<String, dynamic> json) => Uploader(
    username: json['username'] as String,
    group: json['group'] as String,
    avatar: Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
  );

  final String username;
  final String group;
  final Avatar avatar;

  static const empty = Uploader(username: '', group: '', avatar: Avatar.empty);

  Map<String, dynamic> toJson() => {
    'username': username,
    'group': group,
    'avatar': avatar.toJson(),
  };

  @override
  List<Object?> get props => [username, group, avatar];

  @override
  String toString() =>
      'Uploader(username: $username, group: $group, avatar: $avatar)';
}
