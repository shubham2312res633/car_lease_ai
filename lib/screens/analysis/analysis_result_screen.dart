import 'package:flutter/material.dart';
import '../../models/contract_model.dart';
import '../../widgets/score_circle.dart';

class AnalysisResultScreen extends StatelessWidget {
  const AnalysisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final contract =
        ModalRoute.of(context)!.settings.arguments as ContractModel;

    return Scaffold(
      appBar: AppBar(title: const Text("Analysis Result")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            ScoreCircle(score: contract.fairnessScore),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(contract.summary),
            ),

            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                termCard("Monthly", contract.monthlyPayment),
                termCard("APR", contract.apr),
                termCard("Term", contract.term),
                termCard("Mileage", contract.mileage),
              ],
            ),

            const SizedBox(height: 20),

            Column(
              children: contract.redFlags.map((flag) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(flag),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/negotiation',
                  arguments: contract.clauses,
                );
              },
              child: const Text("Start Negotiation"),
            ),
          ],
        ),
      ),
    );
  }

  Widget termCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
