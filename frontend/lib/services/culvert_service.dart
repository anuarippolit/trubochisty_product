import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontend/models/culvert_data.dart';
import 'package:frontend/models/user.dart';


class CulvertService {
  /// Base URL for the CulvertController
  final String baseUrl = 'http://localhost:8080/culvert';

  /// Common headers for JSON requests
  Map<String, String> _headers(String? token) => {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Common headers for multipart requests (do not set content-type manually)
  Map<String, String> _multipartHeaders(String? token) => {
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Fetch all culverts (GET /culvert)
  Future<List<CulvertData>> getAllCulverts(User user) async {
    final uri = Uri.parse(baseUrl);
    final response = await http.get(uri, headers: _headers(user.token));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => CulvertData.fromJson(e)).toList();
    } else {
      throw Exception('Ошибка при получении труб (${response.statusCode})');
    }
  }

  /// Fetch a single culvert by ID (GET /culvert/culverts/{id})
  Future<CulvertData> getCulvertById(String id, User user) async {
    final uri = Uri.parse('$baseUrl/culverts/$id');
    final response = await http.get(uri, headers: _headers(user.token));

    if (response.statusCode == 200) {
      return CulvertData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка при получении трубы (${response.statusCode})');
    }
  }

  /// Create a new culvert (JSON POST to /culvert)
  Future<CulvertData> createCulvert(CulvertData culvert, User user) async {
    final uri = Uri.parse(baseUrl);
    final response = await http.post(
      uri,
      headers: _headers(user.token),
      body: jsonEncode(culvert.toJson()),
    );

    if (response.statusCode == 201) {
      return CulvertData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Ошибка при создании трубы (${response.statusCode}): ${response.body}',
      );
    }
  }

  /// Update an existing culvert (PUT /culvert/{id})
  Future<CulvertData> updateCulvert(
    String id,
    CulvertData culvert,
    User user,
  ) async {
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.put(
      uri,
      headers: _headers(user.token),
      body: jsonEncode(culvert.toJson()),
    );

    if (response.statusCode == 200) {
      return CulvertData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка при обновлении трубы (${response.statusCode})');
    }
  }

  /// Delete a culvert (DELETE /culvert/{id})
  Future<void> deleteCulvert(String id, User user) async {
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.delete(uri, headers: _headers(user.token));

    if (response.statusCode != 204) {
      throw Exception('Ошибка при удалении трубы (${response.statusCode})');
    }
  }

  /// Upload photos to a culvert (PUT /culvert/photos/{id})
  Future<List<String>> uploadPhotos(
    String id,
    List<File> photos,
    User user,
  ) async {
    final uri = Uri.parse('$baseUrl/photos/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers.addAll(_multipartHeaders(user.token));

    for (final file in photos) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photos',
          file.path,
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка при загрузке фотографий (${response.statusCode})');
    }
  }

  /// Replace all photos for a culvert (PUT /culvert/photos/replace/{id})
  Future<List<String>> replacePhotos(
    String id,
    List<File> photos,
    User user,
  ) async {
    final uri = Uri.parse('$baseUrl/photos/replace/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers.addAll(_multipartHeaders(user.token));

    for (final file in photos) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          file.path,
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка при замене фотографий (${response.statusCode})');
    }
  }

  /// Delete a single photo from a culvert (DELETE /culvert/photos/{id}?url=...)
  Future<void> deletePhoto(
    String culvertId,
    String photoUrl,
    User user,
  ) async {
    final uri = Uri.parse('$baseUrl/photos/$culvertId?url=$photoUrl');
    final response = await http.delete(uri, headers: _headers(user.token));

    if (response.statusCode != 200) {
      throw Exception('Ошибка при удалении фотографии (${response.statusCode})');
    }
  }
}