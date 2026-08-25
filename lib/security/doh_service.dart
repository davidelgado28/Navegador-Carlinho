import 'dart:convert';
import 'package:http/http.dart' as http;

class DoHService {
  static const String _cloudflareDohUrl = 'https://cloudflare-dns.com/dns-query';

  Future<String?> resolveDomain(String domain) async {
    try {
      final uri = Uri.parse('$_cloudflareDohUrl?name=$domain&type=A');
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/dns-json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final answers = data['Answer'] as List?;
        if (answers != null && answers.isNotEmpty) {
          return answers[0]['data'] as String;
        }
      }
    } catch (e) {
      print('Erro ao consultar DoH: $e');
    }
    return null;
  }
}
