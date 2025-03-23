import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/models/user/entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class Authentication {
  User? checkUserAccountOnStartUp();
  Future<Result<User, String>> createAnAccount(
      {required User user, required String password});
  Future<Result<User, String>> loginWithGoogle(
      {required User user, String? idToken});
  Future<void> saveAccountLocally({required User user});
  Future<Result<User, String>> login(
      {required String email, required String password});
  Future<void> logout();
}

class AuthenticationImp extends Authentication {
  @override
  User? checkUserAccountOnStartUp()  {
    // print("Dddddddddd");
    User? checkUser =  LocalUserData().getUser();
    return checkUser;
  }

  @override
  Future<Result<User, String>> createAnAccount(
      {required User user, required String password}) async {
    Uri url = Uri.parse("$api/users/register");
    Map<String, dynamic> toSend = UserEntity.toJson(User.toEntity(user));
    toSend['password'] = password;

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(toSend),
    );

    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      User updatedUser = User.fromEntity(UserEntity.fromJson(responseBody));
      LocalUserData().insertUser(updatedUser);
      return Result.success(updatedUser);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      final responseBody = json.decode(response.body);
      return Result.failure(responseBody['message']);
    } else {
      return Result.failure('');
      // return Result.failure('An unexpected error occurred.');
    }
  }

  @override
  Future<void> saveAccountLocally({required User user}) async {
    await LocalUserData().insertUser(user);
  }

  @override
  Future<Result<User, String>> login(
      {required String email, required String password}) async {
    Uri url = Uri.parse("$api/users/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      User loggedInUser = User.fromEntity(UserEntity.fromJson(responseBody));
      await saveAccountLocally(user: loggedInUser);
      return Result.success(loggedInUser);
    } else if (response.statusCode >= 400 && response.statusCode < 600) {
      final responseBody = json.decode(response.body);
      return Result.failure(responseBody['message']);
    } else {
      return Result.failure("An unexpected error occurred.");
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (await GoogleSignInAuth.isUserLoggedInWithGoogle()) {
        try {
          await GoogleSignInAuth.logOut();
        } catch (e) {
          debugPrint("Not a google login");
        }
      }
    } catch (e) {
      debugPrint("Error checking Google login status: $e");
    } finally {
      await LocalUserData().clearUserTable();
    }
  }

  @override
  Future<Result<User, String>> loginWithGoogle(
      {required User user, String? idToken}) async {
    final uri = Uri.parse("$api/users/google-login");
    Map<String, dynamic> userJson = UserEntity.toJson(User.toEntity(user));
    userJson['idToken'] = idToken;
    final response = await http.post(uri,
        headers: {'Content-Type': "application/json"}, body: json.encode(userJson));
    if (response.statusCode >= 400 && response.statusCode <= 600) {
      debugPrint("**************400-600***************");
      return Result.failure(json.decode(response.body)['message']);
    } else if (response.statusCode == 201) {
      debugPrint("*************201****************");
      final responseBody = json.decode(response.body);
      debugPrint(responseBody.toString());
      User loggedInUser = User.fromEntity(UserEntity.fromJson(responseBody));
      await saveAccountLocally(user: loggedInUser);
      return Result.success(loggedInUser);
    } else {
      return Result.failure('An unexpected error occurred.');
    }
  }
}
