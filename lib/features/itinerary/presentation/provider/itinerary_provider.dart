// features/itinerary/presentation/providers/itinerary_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/usecases/add_schedule_usecase.dart';
import '../../domain/usecases/delete_schedule_usecase.dart';
import '../../domain/usecases/get_schedules_usecase.dart';
import '../../domain/usecases/update_schedule_usecase.dart';

class ItineraryProvider extends ChangeNotifier {
  final AddScheduleUseCase addScheduleUseCase;
  final GetSchedulesUseCase getSchedulesUseCase;
  final GetSchedulesByDateUseCase getSchedulesByDateUseCase;
  final UpdateScheduleUseCase updateScheduleUseCase;
  final DeleteScheduleUseCase deleteScheduleUseCase;

  ItineraryProvider({
    required this.addScheduleUseCase,
    required this.getSchedulesUseCase,
    required this.getSchedulesByDateUseCase,
    required this.updateScheduleUseCase,
    required this.deleteScheduleUseCase,
  });

  List<ScheduleEntity> _allSchedules = [];
  List<ScheduleEntity> _todaySchedules = [];
  List<ScheduleEntity> _upcomingSchedules = [];
  List<ScheduleEntity> _completedSchedules = [];
  DateTime _selectedDate = DateTime.now();

  String? _errorMessage;

  // Getters
  List<ScheduleEntity> get allSchedules => _allSchedules;
  List<ScheduleEntity> get todaySchedules => _todaySchedules;
  List<ScheduleEntity> get upcomingSchedules => _upcomingSchedules;
  List<ScheduleEntity> get completedSchedules => _completedSchedules;
  DateTime get selectedDate => _selectedDate;

  String? get errorMessage => _errorMessage;

  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  Future<void> loadSchedules() async {
    try {
      _allSchedules = await getSchedulesUseCase(_userId);
      _categorizeSchedules();
      _clearError();
    } catch (e) {
      _setError('Failed to load schedules: $e');
    }
  }

  void _categorizeSchedules() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _todaySchedules = _allSchedules.where((s) {
      final scheduleDay = DateTime(s.date.year, s.date.month, s.date.day);
      return scheduleDay == today && !s.isCompleted;
    }).toList()..sort((a, b) => a.date.compareTo(b.date));

    _upcomingSchedules = _allSchedules.where((s) {
      return s.date.isAfter(DateTime.now()) && !s.isCompleted;
    }).toList()..sort((a, b) => a.date.compareTo(b.date));

    _completedSchedules = _allSchedules.where((s) {
      return s.isCompleted;
    }).toList()..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

    notifyListeners();
  }

  List<ScheduleEntity> getSchedulesForDate(DateTime date) {
    final targetDay = DateTime(date.year, date.month, date.day);
    return _allSchedules.where((s) {
      final scheduleDay = DateTime(s.date.year, s.date.month, s.date.day);
      return scheduleDay == targetDay;
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  // 🔥 ULTIMATE FIX: Add schedule - Update UI AFTER returning success
  Future<bool> addSchedule(ScheduleEntity schedule) async {
    debugPrint('📝 PROVIDER ADD: Starting...');

    try {
      // 1. Save to Firebase
      debugPrint('💾 PROVIDER ADD: Saving to Firebase...');
      await addScheduleUseCase(_userId, schedule);
      debugPrint('✅ PROVIDER ADD: Firebase save complete');

      // 2. Add to local list (don't notify yet)
      _allSchedules.add(schedule);

      // 4. Return success IMMEDIATELY
      debugPrint('✅ PROVIDER ADD: Returning true');

      // 5. Update UI in the next frame (after method returns)
      Future.microtask(() {
        _categorizeSchedules();
      });

      return true;
    } catch (e) {
      debugPrint('❌ PROVIDER ADD: Error - $e');
      _setError('Failed to add: $e');
      return false;
    }
  }

  // 🔥 ULTIMATE FIX: Update schedule - Update UI AFTER returning success
  Future<bool> updateSchedule(ScheduleEntity schedule) async {
    debugPrint('🔄 PROVIDER UPDATE: Starting...');

    try {
      // 1. Update in Firebase
      debugPrint('💾 PROVIDER UPDATE: Updating Firebase...');
      await updateScheduleUseCase(_userId, schedule);
      debugPrint('✅ PROVIDER UPDATE: Firebase update complete');

      // 2. Update local list (don't notify yet)
      final index = _allSchedules.indexWhere((s) => s.id == schedule.id);
      if (index != -1) {
        _allSchedules[index] = schedule;
      }

      // 4. Return success IMMEDIATELY
      debugPrint('✅ PROVIDER UPDATE: Returning true');

      // 5. Update UI in the next frame
      Future.microtask(() {
        _categorizeSchedules();
      });

      return true;
    } catch (e) {
      debugPrint('❌ PROVIDER UPDATE: Error - $e');
      _setError('Failed to update: $e');
      return false;
    }
  }

  Future<bool> deleteSchedule(String scheduleId) async {
    try {
      await deleteScheduleUseCase(_userId, scheduleId);
      _allSchedules.removeWhere((s) => s.id == scheduleId);

      Future.microtask(() {
        _categorizeSchedules();
      });

      return true;
    } catch (e) {
      _setError('Failed to delete: $e');
      return false;
    }
  }

  // Toggle completion - Already optimized
  Future<void> toggleCompletion(String scheduleId) async {
    final index = _allSchedules.indexWhere((s) => s.id == scheduleId);
    if (index == -1) return;

    final oldSchedule = _allSchedules[index];
    final updatedSchedule = oldSchedule.copyWith(
      isCompleted: !oldSchedule.isCompleted,
      completedAt: !oldSchedule.isCompleted ? DateTime.now() : null,
    );

    // Update UI immediately
    _allSchedules[index] = updatedSchedule;
    _categorizeSchedules();

    // Sync to Firebase in background
    try {
      await updateScheduleUseCase(_userId, updatedSchedule);
    } catch (e) {
      // Rollback on error
      _allSchedules[index] = oldSchedule;
      _categorizeSchedules();
      _setError('Failed to update schedule');
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
