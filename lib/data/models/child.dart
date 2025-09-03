import 'weight.dart';

enum Gender { boy, girl }

class Child {
  final String id;
  final String name;
  final DateTime birthday;
  final Gender gender;
  final Weight birthWeight;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Child({
    required this.id,
    required this.name,
    required this.birthday,
    required this.gender,
    required this.birthWeight,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate age in days
  int get ageInDays {
    final now = DateTime.now();
    return now.difference(birthday).inDays;
  }

  // Calculate age in weeks
  int get ageInWeeks => ageInDays ~/ 7;

  // Calculate age in months (approximate)
  int get ageInMonths {
    final now = DateTime.now();
    int months = (now.year - birthday.year) * 12 + (now.month - birthday.month);
    if (now.day < birthday.day) {
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
      'birthday': birthday.toIso8601String(),
      'gender': gender.name,
      'birthWeight': birthWeight.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      name: json['name'],
      birthday: DateTime.parse(json['birthday']),
      gender: Gender.values.firstWhere((g) => g.name == json['gender']),
      birthWeight: Weight.fromJson(json['birthWeight']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Copy with method for updates
  Child copyWith({
    String? id,
    String? name,
    DateTime? birthday,
    Gender? gender,
    Weight? birthWeight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      birthWeight: birthWeight ?? this.birthWeight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Child(id: $id, name: $name, gender: $gender, age: $ageDisplay)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Child && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
