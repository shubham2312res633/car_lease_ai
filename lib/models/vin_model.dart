class VinModel {
  final String make;
  final String model;
  final String year;
  final String fuelType;
  final String transmission;

  VinModel({
    required this.make,
    required this.model,
    required this.year,
    required this.fuelType,
    required this.transmission,
  });

  factory VinModel.fromJson(Map<String, dynamic> json) {
    return VinModel(
      make: json["make"] ?? "",
      model: json["model"] ?? "",
      year: json["year"] ?? "",
      fuelType: json["fuel_type"] ?? "",
      transmission: json["transmission"] ?? "",
    );
  }
}
