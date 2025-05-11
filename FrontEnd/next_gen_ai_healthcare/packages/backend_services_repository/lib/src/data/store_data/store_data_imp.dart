import 'dart:convert';
import 'dart:io';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/models/item/entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class StoreDataImp extends StoreData {
  final String blobSASUrl =
      '''https://nextgemedcare.blob.core.windows.net/nextgenmedcare-images?sp=r&st=2024-12-16T10:29:59Z&se=2024-12-27T18:29:59Z&spr=https&sv=2022-11-02&sr=c&sig=jTXfAuzT4xCcWmXR3%2FjSdr4mdb%2FNBwyj%2BeD59%2FdIR1s%3D''';
  final String blobSASToken =
      '''sp=r&st=2024-12-16T10:29:59Z&se=2024-12-27T18:29:59Z&spr=https&sv=2022-11-02&sr=c&sig=jTXfAuzT4xCcWmXR3%2FjSdr4mdb%2FNBwyj%2BeD59%2FdIR1s%3D''';
  @override
  Future<Result<String, String>> storeAnItem({required Item item}) async {
    Uri url = Uri.parse("$api/items");

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ItemEntity.toJson(Item.toEntity(item))),
    );

    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      return Result.success(responseBody['status']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      final responseBody = json.decode(response.body);
      return Result.failure(responseBody['status']);
    } else {
      return Result.failure("An unexpected error occurred");
    }
  }

  @override
  Future<Result<String, String>> createItemObjectInDatabase(
      String userId, Item item) async {
    var request = http.post(
      Uri.parse("$api/items"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ItemEntity.toJson(Item.toEntity(item))),
    );
    var response = await request;
    if (response.statusCode == 201) {
      Map<String, dynamic> itemJson = json.decode(response.body);
      return Result.success(itemJson['_id']);
    } else {
      return Result.failure(json.decode(response.body)['error']['message']);
    }
  }

  @override
  Future<List<String>> getImagesFromPhone() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      return Future.value(images.map<String>((XFile e) => e.path).toList());
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<Result<List<String>, String>> uploadToCloudinary(
      List<String> images, String id) async {
    List<List<int>> imagesBytes = await Future.wait(images.map((p) async {
      return await File(p).readAsBytes();
    }).toList());
    List<String> imageUrl = [];
    for (int i = 0; i < images.length; i++) {
      String extension = path.extension(images[i]);
      final request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl))
      ..fields['upload_preset'] = "ml_default"
      ..fields['folder'] = "nextgenmedcare/$id"
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imagesBytes[i],
        filename: "$i$extension",
      ));
      final responseStream = await request.send();

      if (responseStream.statusCode == 200) {
        final responseBody = await http.Response.fromStream(responseStream);
        final responseJson = json.decode(responseBody.body);
        if (responseJson['secure_url'] == null) {
          debugPrint("Error uploading $id.$extension image");
          return Result.failure("Error uploading $id.$extension image");
        } else {
          debugPrint("Uploaded $id.$extension image");
          imageUrl.add(responseJson['secure_url']);
        }
      } else if (responseStream.statusCode == 201) {
        final responseBody = await http.Response.fromStream(responseStream);
        final responseJson = json.decode(responseBody.body);
        if (responseJson['secure_url'] == null) {
          debugPrint("Error uploading $id.$extension image");
          return Result.failure("Error uploading $id.$extension image");
        } else {
          debugPrint("Uploaded $id.$extension image");
          imageUrl.add(responseJson['secure_url']);
        }
      } else {
        debugPrint("Error uploading $id.$extension image");
        return Result.failure("Error uploading $id.$extension image");
      }
    }
    if (imageUrl.isNotEmpty) {
      return Result.success(imageUrl);
    } else {
      return Result.failure("Error uploading images");
    }
  }
}
