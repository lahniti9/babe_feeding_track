import '../models/spurt_models.dart';

// Episodes data matching the calendar grid colors/positions
const spurtEpisodes = <SpurtEpisode>[
  // Page 1 of calendar (matching screenshot colors)
  SpurtEpisode(week: 4,  type: SpurtType.growthLeap, contentKey: 'wk4'),
  SpurtEpisode(week: 5,  type: SpurtType.growthLeap, contentKey: 'wk5'),
  SpurtEpisode(week: 8,  type: SpurtType.growthLeap, contentKey: 'wk8'),
  SpurtEpisode(week: 9,  type: SpurtType.fussyPhase, contentKey: 'wk9'),
  SpurtEpisode(week: 11, type: SpurtType.growthLeap, contentKey: 'wk11'),
  SpurtEpisode(week: 12, type: SpurtType.growthLeap, contentKey: 'wk12'),
  SpurtEpisode(week: 15, type: SpurtType.fussyPhase, contentKey: 'wk15'),
  SpurtEpisode(week: 16, type: SpurtType.fussyPhase, contentKey: 'wk16'),
  SpurtEpisode(week: 17, type: SpurtType.growthLeap, contentKey: 'wk17'),
  SpurtEpisode(week: 18, type: SpurtType.growthLeap, contentKey: 'wk18'),
  SpurtEpisode(week: 19, type: SpurtType.fussyPhase, contentKey: 'wk19'),
  SpurtEpisode(week: 24, type: SpurtType.fussyPhase, contentKey: 'wk24'),
  SpurtEpisode(week: 25, type: SpurtType.fussyPhase, contentKey: 'wk25'),
  SpurtEpisode(week: 26, type: SpurtType.growthLeap, contentKey: 'wk26'),
  SpurtEpisode(week: 35, type: SpurtType.fussyPhase, contentKey: 'wk35'),
  SpurtEpisode(week: 36, type: SpurtType.growthLeap, contentKey: 'wk36'),
  SpurtEpisode(week: 37, type: SpurtType.fussyPhase, contentKey: 'wk37'),
  SpurtEpisode(week: 43, type: SpurtType.fussyPhase, contentKey: 'wk43'),
  SpurtEpisode(week: 44, type: SpurtType.growthLeap, contentKey: 'wk44'),
  SpurtEpisode(week: 45, type: SpurtType.fussyPhase, contentKey: 'wk45'),
  SpurtEpisode(week: 46, type: SpurtType.fussyPhase, contentKey: 'wk46'),
  SpurtEpisode(week: 52, type: SpurtType.fussyPhase, contentKey: 'wk52'),
  SpurtEpisode(week: 53, type: SpurtType.growthLeap, contentKey: 'wk53'),
  SpurtEpisode(week: 54, type: SpurtType.growthLeap, contentKey: 'wk54'),
  SpurtEpisode(week: 55, type: SpurtType.growthLeap, contentKey: 'wk55'),
];

// Content for each episode
const spurtContent = <String, SpurtContent>{
  'wk4': SpurtContent(
    titleLine: 'This growth leap will occur in {days} days',
    behavior: 'Your baby becomes more restless and fussy for no clear reason. They may cry more often and seem harder to comfort. This is completely normal and indicates important brain development is happening.',
    skill: 'Begins to focus on objects 20–25 cm from their face. Your baby starts to track moving objects with their eyes and shows increased visual attention to faces and high-contrast patterns.',
    feeding: 'Feeds more often and may ask for breast or bottle more than usual. Growth spurts require extra nutrition, so follow your baby\'s hunger cues and feed on demand.',
    sleep: 'Sleeps 16–18 hours a day, but wake periods become longer and more alert. You may notice your baby staying awake for 45-60 minutes at a time between naps.',
    communication: 'First attempts at eye contact become more deliberate. Your baby starts looking directly at your eyes and may hold the gaze for several seconds, beginning social interaction.',
  ),
  
  'wk5': SpurtContent(
    titleLine: 'This growth leap will occur in {days} days',
    behavior: 'Increased alertness and awareness of surroundings. Your baby may startle more easily at sudden sounds or movements as their nervous system becomes more sensitive.',
    skill: 'Shows first deliberate smile in response to your voice or face. This is different from reflexive smiles and marks the beginning of social responsiveness.',
    feeding: 'May cluster feed, especially in the evenings. This is normal behavior that helps establish milk supply and provides comfort during this developmental period.',
    sleep: 'Sleep patterns may become temporarily disrupted. Your baby might have shorter naps or wake more frequently as their brain processes new developmental changes.',
    communication: 'Begins to make soft cooing sounds and may respond to your voice with increased movement or attention. Early vocal play starts to emerge.',
  ),

  'wk8': SpurtContent(
    titleLine: 'This growth leap will occur in {days} days',
    behavior: 'Your baby becomes more aware of patterns and routines. They may show anticipation when they see familiar objects like a bottle or when you approach for feeding time.',
    skill: 'Develops better head control and can lift head briefly during tummy time. Hand-eye coordination begins to improve as they start to swipe at objects.',
    feeding: 'Feeding becomes more efficient and rhythmic. Your baby may take less time to feed but still requires frequent meals for proper growth and development.',
    sleep: 'May begin to show preference for certain sleep positions. Night sleep periods may start to lengthen slightly, though this varies greatly between babies.',
    communication: 'Responds more consistently to familiar voices and may turn head toward sounds. Crying becomes more varied with different tones for different needs.',
  ),

  'wk9': SpurtContent(
    titleLine: 'This fussy phase will start in {days} days',
    behavior: 'Increased fussiness and crying, especially in the late afternoon and evening. Your baby may seem inconsolable at times despite all needs being met.',
    skill: 'Hand movements become more purposeful. Your baby may start to bring hands together and show interest in their own fingers and hands.',
    feeding: 'May become more distracted during feeds or seem unsatisfied after eating. This is normal during fussy phases and doesn\'t indicate feeding problems.',
    sleep: 'Sleep may become more fragmented with frequent wake-ups. Your baby might need extra comfort and soothing to settle for naps and nighttime sleep.',
    communication: 'Crying increases in frequency and intensity. This is your baby\'s way of expressing the overwhelming sensations of rapid brain development.',
  ),

  'wk11': SpurtContent(
    titleLine: 'This growth leap will occur in {days} days',
    behavior: 'Your baby shows increased interest in their environment and may become overstimulated more easily. They need more quiet time to process new experiences.',
    skill: 'Begins to reach for objects with more accuracy. Your baby may successfully grab toys or your finger when offered, showing improved motor planning.',
    feeding: 'Appetite may increase significantly. Growth spurts require extra calories, so be prepared for more frequent feeding sessions throughout the day.',
    sleep: 'Sleep needs remain high but wake periods become more interactive. Your baby may stay alert for 60-90 minutes between sleep periods.',
    communication: 'Vocalizations become more varied with different pitches and tones. Your baby may "talk" back when you speak to them, beginning turn-taking in conversation.',
  ),

  'wk12': SpurtContent(
    titleLine: 'This growth leap will occur in {days} days',
    behavior: 'Becomes more social and responsive to interaction. Your baby may show clear preferences for certain people and activities.',
    skill: 'Develops better control over arm and leg movements. Kicking becomes more coordinated and your baby may enjoy batting at hanging toys.',
    feeding: 'Feeding patterns may become more predictable. Your baby might start to space feeds slightly further apart as stomach capacity increases.',
    sleep: 'May begin to show early signs of day/night awareness. Some babies start to have one longer sleep period, often in the early part of the night.',
    communication: 'Laughing and giggling may emerge. Your baby responds more enthusiastically to games like peek-a-boo and silly faces.',
  ),

  // Add placeholder content for other weeks - can be expanded later
  'wk15': SpurtContent(
    titleLine: 'This fussy phase will start in {days} days',
    behavior: 'Increased sensitivity and fussiness as your baby processes new developmental changes.',
    skill: 'Improved hand coordination and reaching abilities develop during this period.',
    feeding: 'May show changes in feeding patterns and appetite during this fussy phase.',
    sleep: 'Sleep patterns may be temporarily disrupted as development progresses.',
    communication: 'Vocalizations and crying patterns may change during this developmental period.',
  ),

  'wk16': SpurtContent(
    titleLine: 'This fussy phase will start in {days} days',
    behavior: 'Continued fussiness as major developmental changes occur in your baby\'s brain.',
    skill: 'Motor skills continue to develop with improved coordination and control.',
    feeding: 'Feeding may require extra patience and comfort during this challenging phase.',
    sleep: 'Sleep disruptions are common but temporary during this developmental period.',
    communication: 'Your baby may be more vocal and expressive, even when fussy.',
  ),

  'wk17': SpurtContent(
    titleLine: 'This growth leap will occur in {days} days',
    behavior: 'Your baby becomes more interactive and shows increased social awareness.',
    skill: 'Significant improvements in motor control and purposeful movements emerge.',
    feeding: 'Growth spurts may increase appetite and feeding frequency temporarily.',
    sleep: 'Sleep patterns begin to stabilize after the previous fussy period.',
    communication: 'More complex vocalizations and social responses develop.',
  ),

  'wk18': SpurtContent(
    titleLine: 'This growth leap will occur in {days} days',
    behavior: 'Increased alertness and curiosity about the surrounding environment.',
    skill: 'Hand-eye coordination improves significantly with better object manipulation.',
    feeding: 'Feeding becomes more efficient as your baby develops better coordination.',
    sleep: 'Longer wake periods allow for more interaction and learning opportunities.',
    communication: 'Your baby may start to show preferences for certain sounds and voices.',
  ),

  // Placeholder entries for remaining weeks
  'wk19': SpurtContent(titleLine: 'This fussy phase will start in {days} days', behavior: 'Temporary fussiness during development.', skill: 'New skills emerging.', feeding: 'Feeding patterns may change.', sleep: 'Sleep may be disrupted.', communication: 'Communication develops.'),
  'wk24': SpurtContent(titleLine: 'This fussy phase will start in {days} days', behavior: 'Developmental fussiness.', skill: 'Motor skills advancing.', feeding: 'Feeding adjustments needed.', sleep: 'Sleep patterns evolving.', communication: 'Vocal development continues.'),
  'wk25': SpurtContent(titleLine: 'This fussy phase will start in {days} days', behavior: 'Continued development.', skill: 'Skills progressing.', feeding: 'Feeding evolving.', sleep: 'Sleep adjusting.', communication: 'Communication growing.'),
  'wk26': SpurtContent(titleLine: 'This growth leap will occur in {days} days', behavior: 'Major growth period.', skill: 'Significant skill development.', feeding: 'Increased nutritional needs.', sleep: 'Sleep patterns changing.', communication: 'Enhanced communication.'),
  'wk35': SpurtContent(titleLine: 'This fussy phase will start in {days} days', behavior: 'Developmental challenges.', skill: 'Advanced skills emerging.', feeding: 'Complex feeding needs.', sleep: 'Mature sleep patterns.', communication: 'Sophisticated communication.'),
  'wk36': SpurtContent(titleLine: 'This growth leap will occur in {days} days', behavior: 'Rapid development.', skill: 'Complex motor skills.', feeding: 'Varied feeding patterns.', sleep: 'Established sleep routines.', communication: 'Advanced vocalizations.'),
  'wk37': SpurtContent(titleLine: 'This fussy phase will start in {days} days', behavior: 'Adjustment period.', skill: 'Refined abilities.', feeding: 'Mature feeding skills.', sleep: 'Consistent sleep needs.', communication: 'Clear communication attempts.'),
  'wk43': SpurtContent(titleLine: 'This fussy phase will start in {days} days', behavior: 'Complex development.', skill: 'Advanced coordination.', feeding: 'Independent feeding signs.', sleep: 'Predictable sleep.', communication: 'Intentional communication.'),
  'wk44': SpurtContent(titleLine: 'This growth leap will occur in {days} days', behavior: 'Significant growth.', skill: 'Mastery of skills.', feeding: 'Efficient feeding.', sleep: 'Stable sleep patterns.', communication: 'Clear expressions.'),
  'wk45': SpurtContent(titleLine: 'This fussy phase will start in {days} days', behavior: 'Transitional period.', skill: 'Skill refinement.', feeding: 'Feeding independence.', sleep: 'Mature sleep habits.', communication: 'Purposeful communication.'),
  'wk46': SpurtContent(titleLine: 'This fussy phase will start in {days} days', behavior: 'Developmental adjustment.', skill: 'Complex abilities.', feeding: 'Advanced feeding skills.', sleep: 'Consistent patterns.', communication: 'Sophisticated expression.'),
  'wk52': SpurtContent(titleLine: 'This fussy phase will start in {days} days', behavior: 'Year milestone changes.', skill: 'Major skill achievements.', feeding: 'Independent feeding.', sleep: 'Established routines.', communication: 'Clear communication.'),
  'wk53': SpurtContent(titleLine: 'This growth leap will occur in {days} days', behavior: 'Toddler development begins.', skill: 'Advanced motor skills.', feeding: 'Complex nutritional needs.', sleep: 'Mature sleep patterns.', communication: 'Verbal development.'),
  'wk54': SpurtContent(titleLine: 'This growth leap will occur in {days} days', behavior: 'Continued growth.', skill: 'Refined coordination.', feeding: 'Independent eating.', sleep: 'Predictable sleep.', communication: 'Language emergence.'),
  'wk55': SpurtContent(titleLine: 'This growth leap will occur in {days} days', behavior: 'Advanced development.', skill: 'Complex motor control.', feeding: 'Mature feeding habits.', sleep: 'Stable sleep needs.', communication: 'Early language skills.'),
};
