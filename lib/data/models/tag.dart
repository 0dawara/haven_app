import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  const Tag({
    required this.id,
    required this.name,
    required this.alias,
    required this.categoryId,
    required this.category,
    required this.purity,
    required this.createdAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    alias: json['alias'] as String? ?? '',
    categoryId: json['category_id'] as int? ?? 0,
    category: json['category'] as String? ?? '',
    purity: json['purity'] as String? ?? '',
    createdAt: json['created_at'] as String? ?? '',
  );

  final int id;
  final String name;
  final String alias;
  final int categoryId;
  final String category;
  final String purity;
  final String createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'alias': alias,
    'category_id': categoryId,
    'category': category,
    'purity': purity,
    'created_at': createdAt,
  };

  @override
  List<Object?> get props {
    return [id, name, alias, categoryId, category, purity, createdAt];
  }

  @override
  String toString() =>
      'Tag(id: $id, name: $name, alias: $alias, categoryId: $categoryId, category: $category, purity: $purity, createdAt: $createdAt)';
}
