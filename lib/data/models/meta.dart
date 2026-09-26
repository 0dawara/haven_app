import 'package:equatable/equatable.dart';

class Meta extends Equatable {
  const Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.query,
    this.seed,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json['current_page'] == null ? 0 : json['current_page'] as int,
    lastPage: json['last_page'] == null ? 0 : json['last_page'] as int,
    perPage: int.tryParse(json['per_page'].toString()) ?? 0,
    total: json['total'] == null ? 0 : json['total'] as int,
    query: json['query'] as String?,
    seed: json['seed'],
  );

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? query;
  final dynamic seed;

  static const empty = Meta(currentPage: 0, lastPage: 0, perPage: 0, total: 0);

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'last_page': lastPage,
    'per_page': perPage,
    'total': total,
    'query': query,
    'seed': seed,
  };

  @override
  List<Object?> get props {
    return [currentPage, lastPage, perPage, total, query, seed];
  }

  @override
  String toString() {
    return 'Meta(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, query: $query, seed: $seed)';
  }
}
