import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contract_model.dart';

const String BASE_URL = "http://192.168.1.5:8000"; 
// 👆 apna local IP daalo (localhost mobile me work nahi karega)

class ApiService {

  static Future<ContractModel> analyzeContract(String filePath) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$BASE_URL/analyze-pdf"),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', filePath),
    );

    var response = await request.send()
        .timeout(const Duration(seconds: 60));

    var respStr = await response.stream.bytesToString();
    final data = jsonDecode(respStr);

    return ContractModel.fromBackend(data);
  }
}
