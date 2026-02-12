class NegotiationMessage {
  final String role; // user / ai
  final String message;

  NegotiationMessage({
    required this.role,
    required this.message,
  });
}
