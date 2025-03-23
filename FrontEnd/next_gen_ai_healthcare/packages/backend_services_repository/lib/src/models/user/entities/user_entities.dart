
class UserEntity {
  final String userId;
  final String userName;
  final String email;
  final String password;
  String? picture;
  double? personReputation;
  Map<String, dynamic>? location;

  UserEntity(
      {required this.userId,
      required this.userName,
      required this.email,
      this.picture,
      this.location,
      this.password = "",
      this.personReputation = 0});

  static UserEntity fromJson(Map<String, dynamic> jsonObject) {
    return UserEntity(
      userId: jsonObject['_id'],
      userName: jsonObject['userName'],
      email: jsonObject['email'],
      picture: jsonObject['picture'],
      password: jsonObject['password'],
      personReputation: jsonObject['personReputation'].toDouble(),
      location: jsonObject['location']??{},
    );
  }

  static Map<String, dynamic> toJson(UserEntity userEntity) {
    return {
      'userId': userEntity.userId,
      'userName': userEntity.userName,
      'email': userEntity.email,
      'password': userEntity.password,
      'picture': userEntity.picture,
      'personReputation': userEntity.personReputation,
      'location': userEntity.location??{},
    };
  }
}
