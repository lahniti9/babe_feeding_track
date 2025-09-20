import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/spurt_content_models.dart';
import '../../modules/spurt/models/spurt_models.dart';

/// Service for loading and caching spurt/leap content from JSON
/// Provides high-performance access to content with background loading
class SpurtContentService extends GetxService {
  static const String _contentPath = 'assets/data/spurt_content.json';
  
  SpurtContentData? _contentData;
  bool _isLoaded = false;
  bool _isLoading = false;
  
  /// Get the cached content data
  SpurtContentData? get contentData => _contentData;
  
  /// Check if content is loaded
  bool get isLoaded => _isLoaded;
  
  /// Check if content is currently loading
  bool get isLoading => _isLoading;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Start loading content immediately when service is initialized
    await loadContent();
  }

  /// Load content from JSON file with background parsing
  Future<void> loadContent() async {
    if (_isLoaded || _isLoading) return;
    
    _isLoading = true;
    
    try {
      // Load JSON string from assets
      final jsonString = await rootBundle.loadString(_contentPath);
      
      // Parse JSON in background isolate to prevent UI jank
      final contentData = await compute(_parseContentInBackground, jsonString);
      
      _contentData = contentData;
      _isLoaded = true;
      
      if (kDebugMode) {
        print('SpurtContentService: Content loaded successfully');
        print('Schema version: ${contentData.schema.version}');
        print('Available weeks: ${contentData.availableWeeks.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('SpurtContentService: Failed to load content: $e');
      }
      // In case of error, we could fall back to hardcoded data
      _loadFallbackContent();
    } finally {
      _isLoading = false;
    }
  }

  /// Background function for parsing JSON (runs in isolate)
  static SpurtContentData _parseContentInBackground(String jsonString) {
    return parseSpurtContentData(jsonString);
  }

  /// Load fallback content if JSON loading fails
  void _loadFallbackContent() {
    // Create minimal fallback content to ensure app doesn't crash
    final schema = ContentSchema(
      version: '1.0.0-fallback',
      lastUpdated: DateTime.now(),
      description: 'Fallback content',
    );
    
    _contentData = SpurtContentData(
      schema: schema,
      weeks: <int, SpurtWeekContent>{},
    );
    _isLoaded = true;
    
    if (kDebugMode) {
      print('SpurtContentService: Using fallback content');
    }
  }

  /// Get content for a specific week
  SpurtWeekContent? getWeekContent(int week) {
    return _contentData?.getWeekContent(week);
  }

  /// Get legacy SpurtContent format for backward compatibility
  SpurtContent? getLegacyContent(String contentKey) {
    final weekNumber = int.tryParse(contentKey.replaceFirst('wk', ''));
    if (weekNumber == null) return null;
    
    final weekContent = getWeekContent(weekNumber);
    if (weekContent == null) return null;
    
    return SpurtContent(
      titleLine: weekContent.titleLineTemplate,
      behavior: weekContent.behaviorText,
      skill: weekContent.skillsText,
      feeding: weekContent.feedingTips,
      sleep: weekContent.sleepTips,
      communication: weekContent.communicationTips,
    );
  }

  /// Get all available weeks
  List<int> get availableWeeks => _contentData?.availableWeeks ?? [];

  /// Check if content exists for a week
  bool hasWeekContent(int week) => _contentData?.hasWeekContent(week) ?? false;

  /// Get all leap weeks
  List<int> get leapWeeks => _contentData?.leapWeeks ?? [];

  /// Get all fussy weeks
  List<int> get fussyWeeks => _contentData?.fussyWeeks ?? [];

  /// Get SpurtEpisode list for backward compatibility
  List<SpurtEpisode> get episodes {
    if (_contentData == null) return [];
    
    return _contentData!.availableWeeks.map((week) {
      final content = _contentData!.getWeekContent(week)!;
      return SpurtEpisode(
        week: week,
        type: content.type == SpurtContentType.leap 
            ? SpurtType.leap 
            : SpurtType.fussy,
        contentKey: 'wk$week',
      );
    }).toList();
  }

  /// Get SpurtWeek for backward compatibility
  SpurtWeek? getSpurtWeek(int week) {
    final content = getWeekContent(week);
    if (content == null) return null;
    
    return SpurtWeek(
      type: content.type == SpurtContentType.leap 
          ? SpurtType.leap 
          : SpurtType.fussy,
      title: content.title,
      behavior: content.behavior,
      skills: content.skills,
      tips: content.tips,
    );
  }

  /// Reload content (useful for development or content updates)
  Future<void> reloadContent() async {
    _isLoaded = false;
    _contentData = null;
    await loadContent();
  }

  /// Get content statistics
  Map<String, dynamic> getContentStats() {
    if (_contentData == null) {
      return {
        'loaded': false,
        'total_weeks': 0,
        'leap_weeks': 0,
        'fussy_weeks': 0,
      };
    }
    
    return {
      'loaded': true,
      'schema_version': _contentData!.schema.version,
      'last_updated': _contentData!.schema.lastUpdated.toIso8601String(),
      'total_weeks': _contentData!.availableWeeks.length,
      'leap_weeks': _contentData!.leapWeeks.length,
      'fussy_weeks': _contentData!.fussyWeeks.length,
      'available_weeks': _contentData!.availableWeeks,
    };
  }

  /// Wait for content to be loaded (useful for initialization)
  Future<void> waitForContent() async {
    while (_isLoading) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  /// Ensure content is loaded before proceeding
  Future<void> ensureContentLoaded() async {
    if (!_isLoaded && !_isLoading) {
      await loadContent();
    } else if (_isLoading) {
      await waitForContent();
    }
  }
}
