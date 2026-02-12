import 'package:flutter/material.dart';

class ScoreCircle extends StatelessWidget {
  final int score;

  const ScoreCircle({
    super.key,
    required this.score,
  });

  Color getScoreColor() {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getScoreColor().withOpacity(0.1),
      ),
      child: Text(
        "$score",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: getScoreColor(),
        ),
      ),
    );
  }
}
