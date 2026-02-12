import 'dart:convert';
import 'package:http/http.dart' as http;


const String BASE_URL = "http://192.168.1.5:8000";

class NegotiationService {

  static Future<String> sendQuestion(
    Map<String, dynamic> clauses,
    String question,
  ) async {

    final response = await http.post(
      Uri.parse("$BASE_URL/negotiate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "clauses": clauses,
        "question": question,
      }),
    ).timeout(const Duration(seconds: 40));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["negotiation_advice"] ?? "No advice received.";
    } else {
      throw Exception("Negotiation failed");
    }
  }
}
