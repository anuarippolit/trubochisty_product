import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontend/models/culvert_data.dart';
import 'package:frontend/models/user.dart';

class CulvertService {
  final String baseUrl = 'http://localhost:8080/culvert';

  // Получить все трубы
  Future<List<CulvertData>> getAllCulverts(User user) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: _headers(user.token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => CulvertData.fromJson(e)).toList();
    } else {
      throw Exception('Ошибка при получении труб');
    }
  }

  // Получить одну трубу по ID
  Future<CulvertData> getCulvertById(String id, User user) async {
    final url = Uri.parse('$baseUrl/culverts/$id');
    final response = await http.get(url, headers: _headers(user.token));

    if (response.statusCode == 200) {
      return CulvertData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка при получении трубы');
    }
  }

  // Создать новую трубу
  Future<CulvertData> createCulvert(
    CulvertData culvert,
    List<File> photos,
    User user,
  ) async {
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers(user.token, isMultipart: true))
      ..fields['culvert'] = jsonEncode(culvert.toJson());

    for (final photo in photos) {
      final stream = http.ByteStream(photo.openRead());
      final length = await photo.length();
      final filename = photo.path.split(Platform.pathSeparator).last;

      request.files.add(
        http.MultipartFile('photos', stream, length, filename: filename),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await http.Response.fromStream(response);
      return CulvertData.fromJson(jsonDecode(body.body));
    } else {
      throw Exception('Ошибка при создании трубы');
    }
  }

  // Обновить трубу
  Future<CulvertData> updateCulvert(
    String id,
    CulvertData culvert,
    User user,
  ) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.put(
      url,
      headers: _headers(user.token),
      body: jsonEncode(culvert.toJson()),
    );

    if (response.statusCode == 200) {
      return CulvertData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка при обновлении трубы');
    }
  }

  // Удалить трубу
  Future<void> deleteCulvert(String id, User user) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.delete(url, headers: _headers(user.token));

    if (response.statusCode != 204) {
      throw Exception('Ошибка при удалении трубы');
    }
  }

  // Загрузить фото (добавить к существующим)
  Future<List<String>> uploadPhotos(
    String id,
    List<File> photos,
    User user,
  ) async {
    final uri = Uri.parse('$baseUrl/photos/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers.addAll(_headers(user.token, isMultipart: true));

    for (final file in photos) {
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final filename = file.path.split(Platform.pathSeparator).last;

      request.files.add(
        http.MultipartFile('photos', stream, length, filename: filename),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await http.Response.fromStream(response);
      return List<String>.from(jsonDecode(body.body));
    } else {
      throw Exception('Ошибка при загрузке фотографий');
    }
  }

  // Полностью заменить фото
  Future<List<String>> replacePhotos(
    String id,
    List<File> photos,
    User user,
  ) async {
    final uri = Uri.parse('$baseUrl/photos/replace/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers.addAll(_headers(user.token, isMultipart: true));

    for (final file in photos) {
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final filename = file.path.split(Platform.pathSeparator).last;

      request.files.add(
        http.MultipartFile('files', stream, length, filename: filename),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await http.Response.fromStream(response);
      return List<String>.from(jsonDecode(body.body));
    } else {
      throw Exception('Ошибка при замене фотографий');
    }
  }

  // Удалить одно фото
  Future<void> deletePhoto(String culvertId, String photoUrl, User user) async {
    final url = Uri.parse('$baseUrl/photos/$culvertId?url=$photoUrl');
    final response = await http.delete(url, headers: _headers(user.token));

    if (response.statusCode != 200) {
      throw Exception('Ошибка при удалении фотографии');
    }
  }

  // Заголовки
  Map<String, String> _headers(String? token, {bool isMultipart = false}) {
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      if (!isMultipart) 'Content-Type': 'application/json',
    };
  }
}
