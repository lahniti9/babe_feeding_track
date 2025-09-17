import 'package:flutter/material.dart';
import '../models/spurt_models.dart';

/// Wonder Weeks – Leaps + lead-in "fussy" windows (paraphrased, concise)
/// Leaps: 5, 8, 12, 19, 26, 37, 46, 55
/// Lead-ins: 4, 7, 9, 11, 15–18, 24–25, 35–36, 43–45, 52–54
const Map<int, SpurtWeek> kSpurtWeeks = {
  // ──────────────────────────────
  // Leap 1 (Changing Sensations) ⟶ ~5 weeks
  4: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 1)",
    behavior: [
      "More clingy/startly; wants contact",
      "Sleep and feeds feel less predictable",
    ],
    tips: [
      "Feeding: quiet, low-stim feeds",
      "Sleep: short soothing, swaddle/white noise",
      "Communication: soft voice, skin-to-skin",
    ],
  ),
  5: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 1 – Changing sensations",
    behavior: [
      "More alert to light/sound/touch",
      "May fuss during transitions",
    ],
    skills: [
      "Longer eye contact; brief smiles",
      "Slightly longer awake windows",
    ],
    tips: [
      "Feeding: watch cues; smaller, frequent feeds",
      "Sleep: calm wind-downs; expect short naps",
      "Communication: face-to-face, gentle talk",
    ],
  ),

  // ──────────────────────────────
  // Leap 2 (Patterns) ⟶ ~8 weeks
  7: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 2)",
    behavior: [
      "Wants to be held more; catnaps",
      "Overstimulation shows faster",
    ],
    tips: [
      "Feeding: reduce distractions",
      "Sleep: earlier nap when drowsy",
      "Communication: simple, repeatable play",
    ],
  ),
  8: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 2 – Patterns",
    behavior: [
      "Tracks simple patterns/rhythms",
      "More engaged, then suddenly fussy",
    ],
    skills: [
      "Stares at stripes/dots; coos more",
      "Beginnings of 'social' smile",
    ],
    tips: [
      "Feeding: pause/burp when gaze wanders",
      "Sleep: short wake→sleep routines",
      "Play: high-contrast patterns, songs",
    ],
  ),
  9: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase tails off",
    behavior: [
      "Evenings may still be cranky",
      "Needs help switching off",
    ],
    tips: [
      "Keep bedtime consistent",
      "Slow transitions; dark, quiet room",
    ],
  ),

  // ──────────────────────────────
  // Leap 3 (Smooth Transitions) ⟶ ~12 weeks
  11: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 3)",
    behavior: [
      "Frustrates with sudden changes",
      "Short naps return",
    ],
    tips: [
      "Feeding: feed on cues; cluster feeds OK",
      "Sleep: protect first nap; contact nap if needed",
      "Communication: narrate changes in pace",
    ],
  ),
  12: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 3 – Smooth transitions",
    behavior: [
      "Notices gradual changes (light, sound, movement)",
      "May protest when pace shifts",
    ],
    skills: [
      "Smoother head/eye control",
      "More coo chains; hand discovery",
    ],
    tips: [
      "Feeding: calm setting; responsive breaks",
      "Sleep: rhythmic wind-down; predictable order",
      "Play: slow peekaboo, gentle motion",
    ],
  ),

  // ──────────────────────────────
  // Leap 4 (Events) ⟶ ~19 weeks
  15: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 4)",
    behavior: [
      "Clingier; startles easily",
      "Day naps wobble; evening fuss",
    ],
    tips: [
      "Keep routines simple; extra soothing",
      "Dim lights, white noise, slow transitions",
    ],
  ),
  16: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase continues",
    behavior: [
      "Wants to be held; appetite shifts",
      "Tires quickly in busy places",
    ],
    tips: [
      "Lower stimulation; short outdoor walks",
      "Offer feeds responsively; protect sleep",
    ],
  ),
  17: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (approaching Leap 4)",
    behavior: [
      "Protests put-downs; catnaps",
      "Notices changes in pace/light/sound",
    ],
    tips: [
      "Predictable wind-down before sleep",
      "Use rhythmic motion if needed",
    ],
  ),
  18: SpurtWeek(
    type: SpurtType.fussy,
    title: "Stormy days before Leap 4",
    behavior: [
      "Cranky evenings; prefers familiar faces",
      "Easily overstimulated during play",
    ],
    tips: [
      "Short, calm play; face-to-face time",
      "Keep bedtime consistent",
    ],
  ),
  19: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 4 – Events",
    behavior: [
      "Combines sights/sounds into 'events'",
      "More distractible, bigger emotions",
    ],
    skills: [
      "First deliberate grabs; hand-to-mouth",
      "Tracks cause→effect in short bursts",
    ],
    tips: [
      "Feeding: quiet, low-distraction feeds",
      "Sleep: expect changes; stick to routine",
      "Communication: narrate actions (\"now we change…\")",
    ],
  ),

  // ──────────────────────────────
  // Leap 5 (Relationships) ⟶ ~26 weeks
  24: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 5)",
    behavior: [
      "New clinginess; prefers primary carers",
      "Alert to distance from you",
    ],
    tips: [
      "Peekaboo; describe comings & goings",
      "Extra reassurance at bedtime",
    ],
  ),
  25: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase continues",
    behavior: [
      "Protests when you leave",
      "Lower tolerance for strangers/crowds",
    ],
    tips: [
      "Goodbye rituals; brief separations",
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
      "Tracks relationships in space",
      "Explores cause/effect more boldly",
    ],
    tips: [
      "Feeding: feed on cues; distractions rise",
      "Sleep: separation-aware—calm, consistent responses",
      "Communication: name people/places (\"Mama back soon\")",
    ],
  ),

  // ──────────────────────────────
  // Leap 6 (Categories) ⟶ ~37 weeks
  35: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 6)",
    behavior: [
      "Very curious; frustrates quickly",
      "Wants the 'right' object/texture",
    ],
    tips: [
      "Rotate a few toys; avoid overstimulation",
      "Short, floor-based play blocks",
    ],
  ),
  36: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase continues",
    behavior: [
      "Resists diaper/clothes changes",
      "Naps shift with busy brain",
    ],
    tips: [
      "Narrate steps; offer small choices",
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
      "Simple sorting; stronger imitation",
      "Early \"favorites\" (toys, textures)",
    ],
    tips: [
      "Feeding: safe texture exploration",
      "Sleep: mental practice can disrupt—stay steady",
      "Play: cups to sort, baskets to fill/empty",
    ],
  ),

  // ──────────────────────────────
  // Leap 7 (Sequences) ⟶ ~46 weeks
  43: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 7)",
    behavior: [
      "Frustrated when steps don't work",
      "Wants routines 'just so'",
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
      "Intent focus, then sudden fuss",
      "Protests transitions mid-activity",
    ],
    tips: [
      "Use 'first-then' language",
      "Offer a tiny job during routines",
    ],
  ),
  45: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (nearly Leap 7)",
    behavior: [
      "Clingy at bedtime/naps",
      "Wants same order nightly",
    ],
    tips: [
      "Unhurried wind-downs; same order",
      "Invite participation (hand diaper, hold sock)",
    ],
  ),
  46: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 7 – Sequences",
    behavior: [
      "Understands step-by-step patterns",
      "Combines actions (stack/place/fit)",
    ],
    skills: [
      "Copies multi-step routines",
      "Longer play loops; cause→effect chains",
    ],
    tips: [
      "Feeding: predictable mealtime steps",
      "Sleep: repeatable pre-sleep sequence",
      "Play: stacking rings, inset puzzles",
    ],
  ),

  // ──────────────────────────────
  // Leap 8 (Programs) ⟶ ~55 weeks
  52: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase (pre-Leap 8)",
    behavior: [
      "Bigger feelings; tests limits",
      "Wants to do things 'own way'",
    ],
    tips: [
      "Offer choices with clear boundaries",
      "Name feelings; keep routines solid",
    ],
  ),
  53: SpurtWeek(
    type: SpurtType.fussy,
    title: "Fussy phase continues",
    behavior: [
      "Many 'do-it-myself' moments",
      "Sleep dips with new mobility/practice",
    ],
    tips: [
      "Allow safe independence; scaffold steps",
      "Extra outdoor gross-motor play",
    ],
  ),
  54: SpurtWeek(
    type: SpurtType.fussy,
    title: "Stormy days before Leap 8",
    behavior: [
      "Push–pull (clingy ↔ independent)",
      "Louder protests at limits",
    ],
    tips: [
      "Be consistent and warm",
      "Reset with movement and outside time",
    ],
  ),
  55: SpurtWeek(
    type: SpurtType.leap,
    title: "Leap 8 – Programs",
    behavior: [
      "Strings sequences into little 'programs'",
      "Starts solving simple problems",
    ],
    skills: [
      "Imitates chores; two-step requests",
      "More purposeful, longer attention",
    ],
    tips: [
      "Feeding: involve in tiny tasks (wipe, place cup)",
      "Sleep: routine + clear cues = smoother nights",
      "Play: early pretend; simple 'helping' jobs",
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
