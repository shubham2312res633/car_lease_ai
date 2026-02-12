import 'package:flutter/material.dart';
import '../../models/negotiation_model.dart';
import '../../services/negotiation_service.dart';
import '../../widgets/chat_bubble.dart';

class NegotiationScreen extends StatefulWidget {
  const NegotiationScreen({super.key});

  @override
  State<NegotiationScreen> createState() =>
      _NegotiationScreenState();
}

class _NegotiationScreenState
    extends State<NegotiationScreen> {

  final TextEditingController controller =
      TextEditingController();

  List<NegotiationMessage> messages = [];
  Map<String, dynamic> clauses = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    clauses = ModalRoute.of(context)!
            .settings
            .arguments as Map<String, dynamic>? ??
        {};
  }

  Future<void> sendMessage() async {
    if (controller.text.isEmpty) return;

    final text = controller.text;

    setState(() {
      messages.add(
          NegotiationMessage(role: "user", message: text));
    });

    controller.clear();

    try {
      final reply =
          await NegotiationService.sendQuestion(
              clauses, text);

      setState(() {
        messages.add(
            NegotiationMessage(role: "ai", message: reply));
      });
    } catch (e) {
      setState(() {
        messages.add(NegotiationMessage(
            role: "ai",
            message: "Error occurred."));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Negotiation")),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                    message: messages[index]);
              },
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              )
            ],
          )
        ],
      ),
    );
  }
}
