class Weight {
  final int grams;
  final int lb;
  final int oz;

  const Weight({
    required this.grams,
    required this.lb,
    required this.oz,
  });

  // Create from grams
  factory Weight.fromGrams(int grams) {
    final totalOz = (grams * 0.035274).round();
    final lb = totalOz ~/ 16;
    final oz = totalOz % 16;
    
    return Weight(
      grams: grams,
      lb: lb,
      oz: oz,
    );
  }

  // Create from pounds and ounces
  factory Weight.fromImperial(int lb, int oz) {
    final totalOz = (lb * 16) + oz;
    final grams = (totalOz * 28.3495).round();

    return Weight(
      grams: grams,
      lb: lb,
      oz: oz,
    );
  }

  // Create from pounds and ounces (alternative name)
  factory Weight.fromPoundsOunces(int pounds, int ounces) {
    return Weight.fromImperial(pounds, ounces);
  }

  // Getters for easier access
  int get pounds => lb;
  int get ounces => oz;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'grams': grams,
      'lb': lb,
      'oz': oz,
    };
  }

  // Create from JSON
  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      grams: json['grams'] ?? 0,
      lb: json['lb'] ?? 0,
      oz: json['oz'] ?? 0,
    );
  }

  // Display methods
  String toMetricString() => '${grams}g';
  String toImperialString() => '${lb}lb ${oz}oz';

  @override
  String toString() => 'Weight(grams: $grams, lb: $lb, oz: $oz)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Weight &&
        other.grams == grams &&
        other.lb == lb &&
        other.oz == oz;
  }

  @override
  int get hashCode => grams.hashCode ^ lb.hashCode ^ oz.hashCode;
}
