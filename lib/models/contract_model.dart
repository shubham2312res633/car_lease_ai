class ContractModel {
  final int fairnessScore;
  final List<String> redFlags;
  final String summary;

  final String monthlyPayment;
  final String apr;
  final String term;
  final String mileage;

  final Map<String, dynamic> clauses;

  ContractModel({
    required this.fairnessScore,
    required this.redFlags,
    required this.summary,
    required this.monthlyPayment,
    required this.apr,
    required this.term,
    required this.mileage,
    required this.clauses,
  });

  factory ContractModel.fromBackend(Map<String, dynamic> json) {
    return ContractModel(
      fairnessScore: json["fairness"]["score"] ?? 0,
      redFlags: List<String>.from(json["fairness"]["reasons"] ?? []),
      summary: json["ai_summary"] ?? "",

      monthlyPayment:
          json["clauses"]["Payment"]?.toString() ?? "",
      apr:
          json["clauses"]["Interest"]?.toString() ?? "",
      term:
          json["clauses"]["Term"]?.toString() ?? "",
      mileage:
          json["clauses"]["Mileage"]?.toString() ?? "",

      clauses: json["clauses"] ?? {},
    );
  }
}
