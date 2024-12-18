import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String username;

  @HiveField(3)
  String? avatarUrl;

  @HiveField(4)
  final String passwordHash;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.passwordHash,
  });
} 