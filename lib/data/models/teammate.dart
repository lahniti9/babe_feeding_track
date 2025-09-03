enum TeammateRole {
  mother,
  father,
  coParent,
  caregiver,
  familyMember,
  babysitter,
  other,
}

class Teammate {
  final String id;
  final String name;
  final TeammateRole role;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Teammate({
    required this.id,
    required this.name,
    required this.role,
    this.isPrimary = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Get role display name
  String get roleDisplay {
    switch (role) {
      case TeammateRole.mother:
        return 'Mom';
      case TeammateRole.father:
        return 'Dad';
      case TeammateRole.coParent:
        return 'Co-parent/caregiver';
      case TeammateRole.caregiver:
        return 'Caregiver';
      case TeammateRole.familyMember:
        return 'Family member';
      case TeammateRole.babysitter:
        return 'Babysitter';
      case TeammateRole.other:
        return 'Other';
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role.name,
      'isPrimary': isPrimary,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Teammate.fromJson(Map<String, dynamic> json) {
    return Teammate(
      id: json['id'],
      name: json['name'],
      role: TeammateRole.values.firstWhere((r) => r.name == json['role']),
      isPrimary: json['isPrimary'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Copy with method for updates
  Teammate copyWith({
    String? id,
    String? name,
    TeammateRole? role,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Teammate(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Teammate(id: $id, name: $name, role: $roleDisplay)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Teammate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
