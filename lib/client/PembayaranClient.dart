import 'package:flutter_application_1/entity/Pembayaran.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PembayaranClient {
  static final String url = 'http://10.0.2.2:8000';
  static final String endpoint = '/api/pembayaran';

  static Future<List<Pembayaran>> fetchPembayaran() async {
    final response = await http.get(Uri.parse('$url$endpoint'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((data) => Pembayaran.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load pembayaran');
    }
  }

  static Future<Pembayaran> createPembayaran(Pembayaran pembayaran) async {
    final response = await http.post(
      Uri.parse('$url$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: pembayaran.toRawJson(),
    );

    if (response.statusCode == 201) {
      return Pembayaran.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create pembayaran');
    }
  }

  static Future<Pembayaran> updatePembayaran(Pembayaran pembayaran) async {
    final response = await http.put(
      Uri.parse('$url$endpoint/${pembayaran.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: pembayaran.toRawJson(),
    );

    if (response.statusCode == 200) {
      return Pembayaran.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to update pembayaran');
    }
  }

  static Future<void> deletePembayaran(int id) async {
    final response = await http.delete(
      Uri.parse('$url$endpoint/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete pembayaran');
    }
  }

  static Future<Pembayaran> fetchPembayaranById(int id) async {
    final response = await http.get(Uri.parse('$url$endpoint/$id'));

    if (response.statusCode == 200) {
      return Pembayaran.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to find pembayaran');
    }
  }
}