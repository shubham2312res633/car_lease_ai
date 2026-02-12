import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/api_service.dart';
import '../../models/contract_model.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  String? filePath;
  String? fileName;

  Future<void> pickFile() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path!;
        fileName = result.files.single.name;
      });
    }
  }

  Future<void> analyzeFile() async {

    Navigator.pushNamed(context, '/loading');

    try {
      ContractModel contract =
          await ApiService.analyzeContract(filePath!);

      Navigator.pushReplacementNamed(
        context,
        '/result',
        arguments: contract,
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Analysis failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Upload Contract")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: pickFile,
                child: const Text("Select PDF")),

            if (fileName != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12),
                child: Text(fileName!),
              ),

            if (filePath != null)
              ElevatedButton(
                  onPressed: analyzeFile,
                  child:
                      const Text("Analyze Contract")),
          ],
        ),
      ),
    );
  }
}
