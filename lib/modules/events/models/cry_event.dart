enum CrySound { 
  nehNeh, 
  eheh, 
  owh, 
  eairh, 
  iiihh 
}

enum CryVolume { 
  quiet, 
  increasing, 
  loud, 
  highPitch 
}

enum CryRhythm { 
  steady, 
  intermittent, 
  irregular, 
  quick 
}

enum CryDuration { 
  short, 
  average, 
  long, 
  constant 
}

enum CryBehaviour { 
  active, 
  freezing, 
  grimacing, 
  fussing 
}

class CryEvent {
  final String id;
  final String childId;
  final DateTime time;
  final Set<CrySound> sounds;
  final Set<CryVolume> volume;
  final Set<CryRhythm> rhythm;
  final Set<CryDuration> duration;
  final Set<CryBehaviour> behaviour;

  CryEvent({
    required this.id,
    required this.childId,
    required this.time,
    required this.sounds,
    required this.volume,
    required this.rhythm,
    required this.duration,
    required this.behaviour,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'childId': childId,
    'time': time.toIso8601String(),
    'sounds': sounds.map((e) => e.name).toList(),
    'volume': volume.map((e) => e.name).toList(),
    'rhythm': rhythm.map((e) => e.name).toList(),
    'duration': duration.map((e) => e.name).toList(),
    'behaviour': behaviour.map((e) => e.name).toList(),
  };

  factory CryEvent.fromJson(Map<String, dynamic> json) => CryEvent(
    id: json['id'],
    childId: json['childId'],
    time: DateTime.parse(json['time']),
    sounds: (json['sounds'] as List).map((e) => CrySound.values.byName(e)).toSet(),
    volume: (json['volume'] as List).map((e) => CryVolume.values.byName(e)).toSet(),
    rhythm: (json['rhythm'] as List).map((e) => CryRhythm.values.byName(e)).toSet(),
    duration: (json['duration'] as List).map((e) => CryDuration.values.byName(e)).toSet(),
    behaviour: (json['behaviour'] as List).map((e) => CryBehaviour.values.byName(e)).toSet(),
  );
}

// Extension methods for display names
extension CrySoundExtension on CrySound {
  String get displayName {
    switch (this) {
      case CrySound.nehNeh: return 'Neh-neh';
      case CrySound.eheh: return 'Eh-eh';
      case CrySound.owh: return 'Owh';
      case CrySound.eairh: return 'Eairh';
      case CrySound.iiihh: return 'Iiiihh';
    }
  }
}

extension CryVolumeExtension on CryVolume {
  String get displayName {
    switch (this) {
      case CryVolume.quiet: return 'Quiet';
      case CryVolume.increasing: return 'Increasing';
      case CryVolume.loud: return 'Loud';
      case CryVolume.highPitch: return 'High pitch';
    }
  }
}

extension CryRhythmExtension on CryRhythm {
  String get displayName {
    switch (this) {
      case CryRhythm.steady: return 'Steady';
      case CryRhythm.intermittent: return 'Intermittent';
      case CryRhythm.irregular: return 'Irregular';
      case CryRhythm.quick: return 'Quick';
    }
  }
}

extension CryDurationExtension on CryDuration {
  String get displayName {
    switch (this) {
      case CryDuration.short: return 'Short';
      case CryDuration.average: return 'Average';
      case CryDuration.long: return 'Long-lasting';
      case CryDuration.constant: return 'Constant';
    }
  }
}

extension CryBehaviourExtension on CryBehaviour {
  String get displayName {
    switch (this) {
      case CryBehaviour.active: return 'Active';
      case CryBehaviour.freezing: return 'Freezing';
      case CryBehaviour.grimacing: return 'Grimacing';
      case CryBehaviour.fussing: return 'Fussing';
    }
  }
}
