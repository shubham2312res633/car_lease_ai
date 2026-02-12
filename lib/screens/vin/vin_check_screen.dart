import 'package:flutter/material.dart';

class VinCheckScreen extends StatelessWidget {
  const VinCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("VIN Check")),
      body: Column(
        children: [
          TextField(controller: controller),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  '/vinReport',
                  arguments: controller.text);
            },
            child: const Text("Verify VIN"),
          )
        ],
      ),
    );
  }
}
