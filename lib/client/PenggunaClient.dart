import 'package:flutter_application_1/entity/Pengguna.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Penggunaclient {
  static final String url = 'http://10.0.2.2:8000';
  static final String endpoint = '/api/pengguna';

  // Mengambil semua data pengguna dari API
  static Future<List<Pengguna>> fetchAll() async {
    try {
      final response = await get(Uri.parse('$url$endpoint'));

      if (response.statusCode != 200) throw Exception('Failed to load users: ${response.reasonPhrase}');

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Pengguna.fromJson(e)).toList();
    } catch (e) {
      return Future.error('Error fetching users: $e');
    }
  }

  // Membuat pengguna baru
  static Future<Response> create(Pengguna pengguna) async {
      final response = await post(
        Uri.parse('$url$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pengguna.toJson()),
      );

      if (response.statusCode != 201) {
        print('Response body: ${response.body}');
        throw Exception('Failed to create user: ${response.reasonPhrase}');
      }
      return response;
  }

  // Metode untuk login pengguna
  static Future<Response> login(String namaPengguna, String password) async {
    try {
      final response = await post(
        Uri.parse('$url$endpoint/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'namaPengguna': namaPengguna,
          'kataSandi': password,
        }),
      );

      if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final token = responseBody['token'];

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
      } else {
        throw Exception('Token is null');
      }
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }


      return response;
    } catch (e) {
      return Future.error('Error logging in: $e');
    }
  }

  // Mengambil data pengguna yang sedang login
  static Future<Pengguna> fetchCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken'); // Ambil token dari SharedPreferences

    if (token == null) {
      throw Exception("Token tidak ditemukan. Silakan login kembali.");
    }

    final response = await get(
      Uri.parse('$url/api/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Kirim token di header Authorization
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data pengguna: ${response.body}');
    }

    final data = json.decode(response.body)['data'];
    return Pengguna.fromJson(data);
  }


}