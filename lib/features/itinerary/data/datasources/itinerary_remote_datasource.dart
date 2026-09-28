import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_model.dart';

class ItineraryRemoteDataSource {
  final FirebaseFirestore _firestore;

  ItineraryRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get user's schedules collection reference
  CollectionReference _getUserSchedulesCollection(String userId) {
    return _firestore
        .collection('itineraries')
        .doc(userId)
        .collection('schedules');
  }

  // Fetch all schedules for a user
  Future<List<ScheduleModel>> getSchedules(String userId) async {
    try {
      final snapshot = await _getUserSchedulesCollection(
        userId,
      ).orderBy('date', descending: false).get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch schedules: $e');
    }
  }

  // Fetch schedules for a specific date
  Future<List<ScheduleModel>> getSchedulesByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await _getUserSchedulesCollection(userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('date')
          .get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch schedules by date: $e');
    }
  }

  // Add a new schedule
  Future<void> addSchedule(String userId, ScheduleModel schedule) async {
    try {
      await _getUserSchedulesCollection(
        userId,
      ).doc(schedule.id).set(schedule.toFirestore());
    } catch (e) {
      throw Exception('Failed to add schedule: $e');
    }
  }

  // Update an existing schedule
  Future<void> updateSchedule(String userId, ScheduleModel schedule) async {
    try {
      await _getUserSchedulesCollection(
        userId,
      ).doc(schedule.id).update(schedule.toFirestore());
    } catch (e) {
      throw Exception('Failed to update schedule: $e');
    }
  }

  // Delete a schedule
  Future<void> deleteSchedule(String userId, String scheduleId) async {
    try {
      await _getUserSchedulesCollection(userId).doc(scheduleId).delete();
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }

  // Watch schedules in real-time
  Stream<List<ScheduleModel>> watchSchedules(String userId) {
    return _getUserSchedulesCollection(userId)
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ScheduleModel.fromFirestore(doc))
              .toList(),
        );
  }
}
