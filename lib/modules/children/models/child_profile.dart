enum BabyGender { girl, boy }

class ChildProfile {
  final String id;
  String name;
  BabyGender gender;
  DateTime birthDate;
  String? avatar; // file path / url

  ChildProfile({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    this.avatar,
  });

  // Calculate age in days
  int get ageInDays {
    final now = DateTime.now();
    return now.difference(birthDate).inDays;
  }

  // Calculate age in weeks
  int get ageInWeeks => ageInDays ~/ 7;

  // Calculate age in months (approximate)
  int get ageInMonths {
    final now = DateTime.now();
    int months = (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) {
      months--;
    }
    return months;
  }

  // Get age display string
  String get ageDisplay {
    if (ageInDays < 7) {
      return '$ageInDays day${ageInDays == 1 ? '' : 's'} old';
    } else if (ageInWeeks < 8) {
      return '$ageInWeeks week${ageInWeeks == 1 ? '' : 's'} old';
    } else {
      return '$ageInMonths month${ageInMonths == 1 ? '' : 's'} old';
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender.name,
      'birthDate': birthDate.toIso8601String(),
      'avatar': avatar,
    };
  }

  // Create from JSON
  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'],
      name: json['name'],
      gender: BabyGender.values.firstWhere((g) => g.name == json['gender']),
      birthDate: DateTime.parse(json['birthDate']),
      avatar: json['avatar'],
    );
  }

  // Copy with method for updates
  ChildProfile copyWith({
    String? id,
    String? name,
    BabyGender? gender,
    DateTime? birthDate,
    String? avatar,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  String toString() => 'ChildProfile(id: $id, name: $name, gender: $gender, age: $ageDisplay)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChildProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
