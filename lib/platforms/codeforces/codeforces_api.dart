import 'dart:convert';
import 'package:http/http.dart' as http;

class CodeforcesApi {
  static Future<List<dynamic>> getSubmissions(String handle) async {
    final url =
        'https://codeforces.com/api/user.status?handle=$handle';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Codeforces API error');
    }

    final data = jsonDecode(response.body);

    if (data['status'] != 'OK') {
      throw Exception('Invalid Codeforces user');
    }

    return data['result'];
  }
}

