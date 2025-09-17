import 'package:flutter/material.dart';
import '../models/spurt_models.dart';

// Wonder Weeks data following the established model
const Map<int, SpurtWeek> kSpurtWeeks = {
  // === Lead-in to Leap 4 (Events) ===
  15: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 4)",
    behavior: [
      "May be clingier and startle more easily",
      "Daytime naps wobble; more evening fussiness",
    ],
    tips: [
      "Keep routines simple; extra contact/soothing",
      "Dim lights, white noise, slow transitions",
    ],
  ),
  16: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase continues",
    behavior: [
      "Wants to be held more; appetite may shift",
      "Tires faster with busy environments",
    ],
    tips: [
      "Lower stimulation; take calm outdoor walks",
      "Offer feeds responsively; protect sleep",
    ],
  ),
  17: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (approaching Leap 4)",
    behavior: [
      "More protest at put-downs; short catnaps",
      "Notices changes in pace, light, and sound",
    ],
    tips: [
      "Predictable wind-down before sleep",
      "Use rhythmic motion (rock/sway) if needed",
    ],
  ),
  18: SpurtWeek(
    type: SpurtType.fussy,
    title: "Stormy days before Leap 4",
    behavior: [
      "Cranky evenings; wants familiar faces",
      "Easily overstimulated during play",
    ],
    tips: [
      "Shorter play windows; face-to-face time",
      "Keep bedtime consistent",
    ],
  ),
  19: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 4 – Events",
    behavior: [
      "Becomes more sensitive to surroundings",
      "May react to tone/voice, position or light",
    ],
    skills: [
      "First deliberate responses; hand-to-mouth",
      "Begins to combine sights/sounds into 'events'",
    ],
    tips: [
      "Feeding: quiet, low-distraction feeds",
      "Sleep: expect changes; keep routine steady",
      "Communication: narrate simple actions (\"now we change\", \"now we pick up\")",
    ],
  ),

  // === Lead-in to Leap 5 (Relationships) ===
  24: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 5)",
    behavior: [
      "New clinginess, prefers primary carers",
      "More alert to distance from you",
    ],
    tips: [
      "Play peekaboo; describe comings & goings",
      "Offer extra reassurance at bedtime",
    ],
  ),
  25: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase continues",
    behavior: [
      "Protests when you leave the room",
      "Shorter tolerance for strangers/crowds",
    ],
    tips: [
      "Use goodbye rituals; brief separations",
      "Babywearing for transitions",
    ],
  ),
  26: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 5 – Relationships",
    behavior: [
      "Understands near/far; separation is harder",
      "Watches where objects/people go",
    ],
    skills: [
      "Tracks relationships (object/person distance)",
      "Experiments with cause/effect more",
    ],
    tips: [
      "Feeding: feed on cues; distractions rise",
      "Sleep: separation-aware—calm, consistent responses",
      "Communication: name people/places (\"Mama back soon\")",
    ],
  ),

  // === Lead-in to Leap 6 (Categories) ===
  35: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 6)",
    behavior: [
      "More curious but frustrated quickly",
      "Wants the 'right' object/texture",
    ],
    tips: [
      "Rotate a few toys; avoid overstocks",
      "Slow, floor-based play blocks",
    ],
  ),
  36: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase continues",
    behavior: [
      "Resistance at diaper/clothes changes",
      "Naps shift with busy brains",
    ],
    tips: [
      "Narrate steps; offer choices ('this or that')",
      "Protect sleepy cues; earlier nap if needed",
    ],
  ),
  37: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 6 – Categories",
    behavior: [
      "Groups things (big/small, soft/hard)",
      "Examines details; compares objects",
    ],
    skills: [
      "Begins sorting/building preferences",
      "Imitates actions more accurately",
    ],
    tips: [
      "Feeding: let baby explore safe textures",
      "Sleep: mental practice can disrupt—stay calm/consistent",
      "Play: simple sorting cups, baskets, fabric squares",
    ],
  ),

  // === Lead-in to Leap 7 (Sequences) ===
  43: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 7)",
    behavior: [
      "Gets frustrated when steps don't work",
      "Wants to repeat routines 'just so'",
    ],
    tips: [
      "Keep predictable daily sequences",
      "Let baby try steps with gentle help",
    ],
  ),
  44: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase continues",
    behavior: [
      "More intent focus, then sudden fuss",
      "Protests transitions mid-activity",
    ],
    tips: [
      "Use 'first-then' language",
      "Offer a small job during routines",
    ],
  ),
  45: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (nearly Leap 7)",
    behavior: [
      "Clinginess at bedtime/naps",
      "Wants familiar sequence of events",
    ],
    tips: [
      "Unhurried wind-downs; same order nightly",
      "Invite participation (hand the diaper, hold the sock)",
    ],
  ),
  46: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 7 – Sequences",
    behavior: [
      "Understands simple step-by-step patterns",
      "Tries to combine actions (stack, place, fit)",
    ],
    skills: [
      "Copies multi-step routines",
      "Longer play loops; cause→effect chains",
    ],
    tips: [
      "Feeding: predictable mealtime steps",
      "Sleep: repeatable pre-sleep sequence",
      "Play: stacking rings, simple insert puzzles",
    ],
  ),

  // === Lead-in to Leap 8 (Programs) ===
  52: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 8)",
    behavior: [
      "Bigger emotions; testing limits",
      "Wants to do things 'own way'",
    ],
    tips: [
      "Offer choices, simple boundaries",
      "Name feelings; keep routines solid",
    ],
  ),
  53: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase continues",
    behavior: [
      "Frequent 'do it myself' moments",
      "Sleep may dip with mobility/practice",
    ],
    tips: [
      "Allow safe independence; scaffold steps",
      "Extra fresh air and gross-motor play",
    ],
  ),
  54: SpurtWeek(
    type: SpurtType.fussy,
    title: "Stormy days before Leap 8",
    behavior: [
      "Push–pull behavior (clingy ↔ independent)",
      "Protests limits more loudly",
    ],
    tips: [
      "Consistent boundaries; warm tone",
      "Reset with movement and outside time",
    ],
  ),
  55: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 8 – Programs",
    behavior: [
      "Strings steps into little 'programs'",
      "Attempts to solve simple problems",
    ],
    skills: [
      "Imitates chores; two-step requests",
      "Longer attention for purposeful play",
    ],
    tips: [
      "Feeding: involve in tiny tasks (wipe, place cup)",
      "Sleep: routine + clear cues = smoother nights",
      "Play: pretend play starter kits, simple chores",
    ],
  ),
};

// Helper function to get week color
Color weekColor(int week) {
  final info = kSpurtWeeks[week];
  if (info == null) return Colors.transparent;
  return info.type == SpurtType.leap ? const Color(0xFFFF6B6B) : const Color(0xFF22C55E);
}

// Legacy episodes data for backward compatibility - converted from kSpurtWeeks
final spurtEpisodes = kSpurtWeeks.entries.map((entry) =>
  SpurtEpisode(
    week: entry.key,
    type: entry.value.type,
    contentKey: 'wk${entry.key}'
  )
).toList();

// Convert SpurtWeek data to legacy SpurtContent format for backward compatibility
SpurtContent? getSpurtContent(String contentKey) {
  final weekNumber = int.tryParse(contentKey.replaceFirst('wk', ''));
  if (weekNumber == null) return null;

  final spurtWeek = kSpurtWeeks[weekNumber];
  if (spurtWeek == null) return null;

  final titleLine = spurtWeek.type == SpurtType.leap
      ? 'This growth leap will occur in {days} days'
      : 'This fussy phase will start in {days} days';

  return SpurtContent(
    titleLine: titleLine,
    behavior: spurtWeek.behavior.join(' '),
    skill: spurtWeek.skills.join(' '),
    feeding: spurtWeek.tips.where((tip) => tip.toLowerCase().contains('feeding')).join(' '),
    sleep: spurtWeek.tips.where((tip) => tip.toLowerCase().contains('sleep')).join(' '),
    communication: spurtWeek.tips.where((tip) => tip.toLowerCase().contains('communication')).join(' '),
  );
}

// Legacy content map for backward compatibility
final spurtContent = <String, SpurtContent>{
  for (final week in kSpurtWeeks.keys)
    'wk$week': getSpurtContent('wk$week')!,
};
