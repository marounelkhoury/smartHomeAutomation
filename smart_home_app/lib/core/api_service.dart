import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/smart_plug.dart';

class ApiService {
  static const String baseUrl = 'https://example.com/api';

  Future<List<SmartPlug>> fetchSmartPlugs() async {
    final response = await http.get(Uri.parse('$baseUrl/smartplugs'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((plug) => SmartPlug(id: plug['id'], name: plug['name'], status: plug['status'])).toList();
    } else {
      throw Exception('Failed to load smart plugs');
    }
  }
}