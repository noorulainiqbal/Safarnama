import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/checklist_item_entity.dart';
import '../../domain/usecases/add_update_checklist_item_usecase.dart';
import '../../domain/usecases/delete_checklist_item_usecase.dart';
import '../../domain/usecases/get_checklist_usecase.dart';
import '../widget/checklist_item.dart';

class ChecklistProvider extends ChangeNotifier {
  final GetChecklistUseCase getChecklistUseCase;
  final AddOrUpdateChecklistItemUseCase addOrUpdateChecklistItemUseCase;
  final DeleteChecklistItemUseCase deleteChecklistItemUseCase;

  List<ChecklistItem> essentialItems = [];
  List<ChecklistItem> rainyItems = [];
  bool isLoading = false;

  Timer? _debounce;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _uuid = const Uuid();
  StreamSubscription<User?>? _authSubscription;

  ChecklistProvider({
    required this.getChecklistUseCase,
    required this.addOrUpdateChecklistItemUseCase,
    required this.deleteChecklistItemUseCase,
  }) {
    _initAuthListener();
  }

  void _initAuthListener() {
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        loadChecklist();
      } else {
        _clearData();
      }
    });
  }

  void _clearData() {
    essentialItems = [];
    rainyItems = [];
    isLoading = false;
    _debounce?.cancel();
    notifyListeners();
  }

  String? get _uid => _auth.currentUser?.uid;

  Future<void> loadChecklist() async {
    if (_uid == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final entities = await getChecklistUseCase(_uid!);

      // 1. Filter out empty items locally and from source if possible (though we can't delete from source here easily without iterating)
      // We will filter locally for display, and the "Sync" step will handle additions.
      // Actually, let's clean up the entities first.
      final validEntities = entities
          .where((e) => e.title.trim().isNotEmpty)
          .toList();

      if (validEntities.isEmpty) {
        await _initializeDefaults();
      } else {
        // 2. Sync / Merge Defaults
        await _syncWithDefaults(validEntities);
      }
    } catch (e) {
      debugPrint("Error loading checklist: $e");
      // If error, stop loading
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _syncWithDefaults(
    List<ChecklistItemEntity> existingEntities,
  ) async {
    final defaultEssentials = [
      'Wallet',
      'Snacks',
      'Sunscreen',
      'Passport / CNIC',
      'Mobile phone',
      'Phone charger / power bank',
      'Medications',
      'Travel Bag',
      'Water Bottle',
    ];
    final defaultRainy = ['Raincoat', 'Umbrella', 'Waterproof Bag', 'Towel'];

    // Normalize logic: strict exact match on title.
    final allowedTitles = {...defaultEssentials, ...defaultRainy};

    bool needsReload = false;
    Set<String> processedTitles = {};

    // 1. DELETE UNAUTHORIZED Items & DUPLICATES
    // Iterate manually to handle async deletions
    for (var entity in [...existingEntities]) {
      final title = entity.title.trim();

      // Check if allowed
      if (!allowedTitles.contains(title)) {
        debugPrint('🗑️ Strict Cleanup: Deleting unauthorized item: $title');
        await deleteChecklistItemUseCase(_uid!, entity.id);
        needsReload = true;
        continue;
      }

      // Check for duplicates
      if (processedTitles.contains(title)) {
        debugPrint('🗑️ Strict Cleanup: Deleting duplicate item: $title');
        await deleteChecklistItemUseCase(_uid!, entity.id);
        needsReload = true;
        continue;
      }

      processedTitles.add(title);

      // Check Category
      String expectedCategory = defaultEssentials.contains(title)
          ? 'essential'
          : 'rainy';
      if (entity.category != expectedCategory) {
        debugPrint('🔧 Strict Cleanup: Fixing category for: $title');
        final updatedItem = checklistItemEntityCopyWith(
          entity,
          category: expectedCategory,
        );
        await addOrUpdateChecklistItemUseCase(_uid!, updatedItem);
        needsReload = true;
      }
    }

    // 2. ADD MISSING Items
    for (var title in defaultEssentials) {
      if (!processedTitles.contains(title)) {
        debugPrint('➕ Strict Cleanup: Adding missing item: $title');
        final newItem = ChecklistItemEntity(
          id: _uuid.v4(),
          title: title,
          isChecked: [
            'Passport / CNIC',
            'Wallet',
            'Mobile phone',
            'Phone charger / power bank',
          ].contains(title),
          category: 'essential',
        );
        await addOrUpdateChecklistItemUseCase(_uid!, newItem);
        needsReload = true;
      }
    }

    for (var title in defaultRainy) {
      if (!processedTitles.contains(title)) {
        debugPrint('➕ Strict Cleanup: Adding missing item: $title');
        final newItem = ChecklistItemEntity(
          id: _uuid.v4(),
          title: title,
          isChecked: ['Umbrella'].contains(title),
          category: 'rainy',
        );
        await addOrUpdateChecklistItemUseCase(_uid!, newItem);
        needsReload = true;
      }
    }

    if (needsReload) {
      // Reload to get fresh clean list
      final freshEntities = await getChecklistUseCase(_uid!);
      _mapEntitiesToCategories(
        freshEntities.where((e) => e.title.trim().isNotEmpty).toList(),
      );
    } else {
      // Filter existingEntities in memory to match what we kept (approximation, but safer to reload if we deleted things)
      // If we didn't reload, it means existingEntities is PERFECT.
      _mapEntitiesToCategories(existingEntities);
    }

    isLoading = false;
    notifyListeners();
  }

  // Helper for copyWith since Entity might not have it or I can't see it (assuming I construct it manually)
  ChecklistItemEntity checklistItemEntityCopyWith(
    ChecklistItemEntity original, {
    String? category,
  }) {
    return ChecklistItemEntity(
      id: original.id,
      title: original.title,
      isChecked: original.isChecked,
      category: category ?? original.category,
    );
  }

  Future<void> _initializeDefaults() async {
    final defaultEssentials = [
      'Wallet',
      'Snacks',
      'Sunscreen',
      'Passport / CNIC',
      'Mobile phone',
      'Phone charger / power bank',
      'Medications',
      'Travel Bag',
      'Water Bottle',
    ];
    final defaultRainy = ['Raincoat', 'Umbrella', 'Waterproof Bag', 'Towel'];

    essentialItems = defaultEssentials
        .map(
          (title) => ChecklistItem(
            id: _uuid.v4(),
            title: title,
            isChecked: [
              'Passport / CNIC',
              'Wallet',
              'Mobile phone',
              'Phone charger / power bank',
            ].contains(title),
            category: 'essential',
          ),
        )
        .toList();

    rainyItems = defaultRainy
        .map(
          (title) => ChecklistItem(
            id: _uuid.v4(),
            title: title,
            isChecked: ['Umbrella'].contains(title),
            category: 'rainy',
          ),
        )
        .toList();

    // Save all to Firestore
    for (var item in [...essentialItems, ...rainyItems]) {
      await _saveItem(item);
    }

    _attachListeners();
    isLoading = false;
    notifyListeners();
  }

  void _mapEntitiesToCategories(List<ChecklistItemEntity> entities) {
    // Also filter empty here just in case
    final validEntities = entities
        .where((e) => e.title.trim().isNotEmpty)
        .toList();

    essentialItems = validEntities
        .where((e) => e.category == 'essential')
        .map(
          (e) => ChecklistItem(
            id: e.id,
            title: e.title,
            isChecked: e.isChecked,
            category: 'essential',
          ),
        )
        .toList();

    rainyItems = validEntities
        .where((e) => e.category == 'rainy')
        .map(
          (e) => ChecklistItem(
            id: e.id,
            title: e.title,
            isChecked: e.isChecked,
            category: 'rainy',
          ),
        )
        .toList();

    _attachListeners();
    // No notify here, assume caller handles it or call it?
    // loadChecklist handles it.
  }

  void _attachListeners() {
    for (var item in [...essentialItems, ...rainyItems]) {
      if (!item.titleController.hasListeners) {
        item.titleController.addListener(() {
          _onTitleChanged(item);
        });
      }
    }
  }

  void _onTitleChanged(ChecklistItem item) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _saveItem(item);
    });
  }

  Future<void> saveItemNow(ChecklistItem item) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    await _saveItem(item);
  }

  Future<void> _saveItem(ChecklistItem item) async {
    if (_uid == null) return;

    // If title is empty, DELETE it
    if (item.titleController.text.trim().isEmpty) {
      await deleteChecklistItemUseCase(_uid!, item.id);

      // Also remove from local list to reflect UI
      if (item.category == 'essential') {
        essentialItems.removeWhere((e) => e.id == item.id);
      } else {
        rainyItems.removeWhere((e) => e.id == item.id);
      }
      notifyListeners();
      return;
    }

    final entity = ChecklistItemEntity(
      id: item.id,
      title: item.titleController.text,
      isChecked: item.isChecked,
      category: item.category,
    );

    await addOrUpdateChecklistItemUseCase(_uid!, entity);
  }

  Future<void> toggleItem(ChecklistItem item) async {
    item.isChecked = !item.isChecked;
    notifyListeners();
    await _saveItem(item);
  }

  Future<void> addEssentialItem() async {
    final newItem = ChecklistItem(
      id: _uuid.v4(),
      title: '',
      category: 'essential',
    );
    essentialItems.add(newItem);
    newItem.titleController.addListener(
      () => _onTitleChanged(newItem),
    ); // Attach listener
    notifyListeners();
    await _saveItem(newItem);
  }

  Future<void> addRainyItem() async {
    final newItem = ChecklistItem(id: _uuid.v4(), title: '', category: 'rainy');
    rainyItems.add(newItem);
    newItem.titleController.addListener(
      () => _onTitleChanged(newItem),
    ); // Attach listener
    notifyListeners();
    await _saveItem(newItem);
  }

  // We can also implement delete if needed, but not requested.

  // ================= Progress =================
  int get totalItems => essentialItems.length + rainyItems.length;

  int get checkedItems =>
      essentialItems.where((e) => e.isChecked).length +
      rainyItems.where((e) => e.isChecked).length;

  int get progressPercent =>
      totalItems == 0 ? 0 : ((checkedItems / totalItems) * 100).round();

  @override
  void dispose() {
    _authSubscription?.cancel();
    _debounce?.cancel();
    for (var item in [...essentialItems, ...rainyItems]) {
      item.titleController.dispose();
    }
    super.dispose();
  }
}
