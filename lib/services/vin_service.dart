import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vin_model.dart';

const String BASE_URL = "http://192.168.1.5:8000";

class VinService {

  static Future<VinModel> fetchVin(String vin) async {

    final response = await http.get(
      Uri.parse("$BASE_URL/vin/$vin"),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return VinModel.fromJson(data);
    } else {
      throw Exception("VIN lookup failed");
    }
  }
}
