import 'dart:convert';
import 'package:http/http.dart' as http;

class CodeforcesApi {
  static const _baseUrl = 'https://codeforces.com/api';

  static Future<List<dynamic>> fetchSubmissions(String handle) async {
    final url = Uri.parse(
      '$_baseUrl/user.status?handle=$handle',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('HTTP error from Codeforces');
    }

    final data = jsonDecode(response.body);

    if (data['status'] != 'OK') {
      throw Exception(data['comment'] ?? 'Codeforces API failed');
    }

    return data['result'];
  }
}

