import 'package:get/get.dart';
import 'app_routes.dart';

// Import actual views
import '../modules/onboarding/views/splash_view.dart';
import '../modules/onboarding/views/start_goal_view.dart';
import '../modules/onboarding/views/feed_tracking_involvement_view.dart';
import '../modules/onboarding/views/measure_growth_frequency_view.dart';
import '../modules/onboarding/views/team_intro_view.dart';
import '../modules/onboarding/views/parent_name_view.dart';
import '../modules/onboarding/views/baby_name_view.dart';
import '../modules/onboarding/views/baby_birthday_view.dart';
import '../modules/onboarding/views/baby_gender_view.dart';
import '../modules/onboarding/views/birth_weight_metric_view.dart';
import '../modules/onboarding/views/birth_weight_imperial_view.dart';
import '../modules/onboarding/views/time_on_sleep_schedule_view.dart';
import '../modules/onboarding/views/importance_of_health_info_view.dart';
import '../modules/onboarding/views/attitude_to_attachment_view.dart';
import '../modules/onboarding/views/role_check_view.dart';
import '../modules/onboarding/views/welcome_name_view.dart';
import '../modules/onboarding/views/teammate_name_view.dart';
import '../modules/onboarding/views/teammate_role_view.dart';
import '../modules/onboarding/views/team_ready_view.dart';
import '../modules/onboarding/views/routine_improve_view.dart';
import '../modules/onboarding/views/night_feeds_view.dart';
import '../modules/onboarding/views/feeding_type_view.dart';
import '../modules/onboarding/views/feeding_right_place_view.dart';
import '../modules/onboarding/views/sleep_issues_view.dart';
import '../modules/onboarding/views/naps_per_day_view.dart';
import '../modules/onboarding/views/night_sleep_period_view.dart';
import '../modules/onboarding/views/last_fell_asleep_view.dart';
import '../modules/onboarding/views/mark_3_days_view.dart';
import '../modules/onboarding/views/whats_on_your_side_view.dart';
import '../modules/onboarding/views/emotional_state_view.dart';
import '../modules/onboarding/views/emotion_grid_view.dart';
import '../modules/onboarding/views/self_care_view.dart';
import '../modules/onboarding/views/sleep_statement_view.dart';
import '../modules/onboarding/views/appetite_view.dart';
import '../modules/onboarding/views/tried_to_normalize_view.dart';
import '../modules/onboarding/views/needs_learn_to_sleep_view.dart';
import '../modules/onboarding/views/start_feeding_know_how_view.dart';
import '../modules/onboarding/views/foods_under_one_view.dart';
import '../modules/onboarding/views/intro_food_soon_view.dart';
import '../modules/onboarding/views/learn_about_dev_view.dart';
import '../modules/onboarding/views/spurt_intro_view.dart';
import '../modules/onboarding/views/similar_changes_view.dart';
import '../modules/onboarding/views/spurt_timeline_view.dart';
import '../modules/onboarding/views/promise_fingerprint_view.dart';
import '../modules/onboarding/views/you_can_do_it_view.dart';
import '../modules/onboarding/views/setup_progress_view.dart';
import '../modules/onboarding/views/with_without_view.dart';
import '../modules/onboarding/views/jumpstart_view.dart';
import '../modules/onboarding/views/log_recent_view.dart';
import '../modules/onboarding/views/add_event_time_view.dart';
import '../modules/onboarding/views/well_done_view.dart';
import '../modules/onboarding/views/habit_view.dart';
import '../modules/onboarding/views/already_added_view.dart';
import '../modules/onboarding/views/streak_view.dart';
import '../modules/tabs/tabs_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/tabs/bindings/tabs_binding.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    // Onboarding flow
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.startGoal,
      page: () => const StartGoalView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.feedTrackingInvolvement,
      page: () => const FeedTrackingInvolvementView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.measureGrowthFrequency,
      page: () => const MeasureGrowthFrequencyView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.timeOnSleepSchedule,
      page: () => const TimeOnSleepScheduleView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.importanceOfHealthInfo,
      page: () => const ImportanceOfHealthInfoView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.attitudeToAttachment,
      page: () => const AttitudeToAttachmentView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.teamIntro,
      page: () => const TeamIntroView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.parentName,
      page: () => const ParentNameView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.roleCheck,
      page: () => const RoleCheckView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.welcomeName,
      page: () => const WelcomeNameView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.babyName,
      page: () => const BabyNameView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.babyBirthday,
      page: () => const BabyBirthdayView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.babyGender,
      page: () => const BabyGenderView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.birthWeightMetric,
      page: () => const BirthWeightMetricView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.birthWeightImperial,
      page: () => const BirthWeightImperialView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.teammateName,
      page: () => const TeammateNameView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.teammateRole,
      page: () => const TeammateRoleView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.teamReady,
      page: () => const TeamReadyView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.routineImprove,
      page: () => const RoutineImproveView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.nightFeeds,
      page: () => const NightFeedsView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.feedingType,
      page: () => const FeedingTypeView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.feedingRightPlace,
      page: () => const FeedingRightPlaceView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.sleepIssues,
      page: () => const SleepIssuesView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.napsPerDay,
      page: () => const NapsPerDayView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.nightSleepPeriod,
      page: () => const NightSleepPeriodView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.lastFellAsleep,
      page: () => const LastFellAsleepView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.mark3Days,
      page: () => const Mark3DaysView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.whatsOnYourSide,
      page: () => const WhatsOnYourSideView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.emotionalState,
      page: () => const EmotionalStateView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.emotionGrid,
      page: () => const EmotionGridView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.selfCare,
      page: () => const SelfCareView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.sleepStatement,
      page: () => const SleepStatementView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.appetite,
      page: () => const AppetiteView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.triedToNormalize,
      page: () => const TriedToNormalizeView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.needsLearnToSleep,
      page: () => const NeedsLearnToSleepView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.startFeedingKnowHow,
      page: () => const StartFeedingKnowHowView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.foodsUnderOne,
      page: () => const FoodsUnderOneView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.introFoodSoon,
      page: () => const IntroFoodSoonView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.learnAboutDev,
      page: () => const LearnAboutDevView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.spurtIntro,
      page: () => const SpurtIntroView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.similarChanges,
      page: () => const SimilarChangesView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.spurtTimeline,
      page: () => const SpurtTimelineView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.promiseFingerprint,
      page: () => const PromiseFingerprintView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.youCanDoIt,
      page: () => const YouCanDoItView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.setup18,
      page: () => const Setup18View(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.setup59,
      page: () => const Setup59View(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.setup73,
      page: () => const Setup73View(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.setup87,
      page: () => const Setup87View(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.withWithout,
      page: () => const WithWithoutView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.jumpstart,
      page: () => const JumpstartView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.logRecent,
      page: () => const LogRecentView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.addEventTime,
      page: () => const AddEventTimeView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.wellDone,
      page: () => const WellDoneView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.habit,
      page: () => const HabitView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.alreadyAdded,
      page: () => const AlreadyAddedView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.streak,
      page: () => const StreakView(),
      binding: OnboardingBinding(),
    ),

    // Main app tabs
    GetPage(
      name: Routes.tabs,
      page: () => const TabsView(),
      binding: TabsBinding(),
    ),
  ];
}

// All screens are now implemented!



