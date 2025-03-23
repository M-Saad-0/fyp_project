import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/models/user/entities/entities.dart';
part 'user.g.dart';
@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  String? picture;
  @HiveField(5)
  double? personReputation;
  @HiveField(6)
  Map<String, dynamic>? location;

  User(
      {required this.userId,
      required this.userName,
      this.password = "",
      required this.email,
      this.picture,
      this.location,
      this.personReputation = 0});

  static UserEntity toEntity(User user) {
    return UserEntity(
        userId: user.userId,
        password: user.password,
        userName: user.userName,
        email: user.email,
        picture: user.picture ?? "",
        location: user.location ?? {},
        personReputation: user.personReputation);
  }

  static User fromEntity(UserEntity userEntity) {
    return User(
        userId: userEntity.userId,
        userName: userEntity.userName,
        password: userEntity.password,
        email: userEntity.email,
        picture: userEntity.picture ?? "",
        location: userEntity.location ?? {},
        personReputation: userEntity.personReputation);
  }
}
