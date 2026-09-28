// features/itinerary/presentation/pages/add_schedule_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../route/presentation/widget/app_bar_icon_widget.dart';
import '../../domain/entities/schedule_entity.dart';
import '../provider/itinerary_provider.dart';

class AddScheduleScreen extends StatefulWidget {
  final ScheduleEntity? schedule;

  const AddScheduleScreen({super.key, this.schedule});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _notesController;

  late final ValueNotifier<DateTime> _selectedDateNotifier;
  late final ValueNotifier<TimeOfDay> _selectedTimeNotifier;
  final ValueNotifier<bool> _isSavingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    if (widget.schedule != null) {
      _titleController = TextEditingController(text: widget.schedule!.title);
      _locationController = TextEditingController(
        text: widget.schedule!.location,
      );
      _notesController = TextEditingController(
        text: widget.schedule!.notes ?? '',
      );
      _selectedDateNotifier = ValueNotifier(widget.schedule!.date);
      _selectedTimeNotifier = ValueNotifier(
        TimeOfDay(
          hour: widget.schedule!.date.hour,
          minute: widget.schedule!.date.minute,
        ),
      );
    } else {
      _titleController = TextEditingController();
      _locationController = TextEditingController();
      _notesController = TextEditingController();
      _selectedDateNotifier = ValueNotifier(DateTime.now());
      _selectedTimeNotifier = ValueNotifier(TimeOfDay.now());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _selectedDateNotifier.dispose();
    _selectedTimeNotifier.dispose();
    _isSavingNotifier.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateNotifier.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryOrange),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _selectedDateNotifier.value = picked;
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimeNotifier.value,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryOrange),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _selectedTimeNotifier.value = picked;
    }
  }

  Future<void> _saveSchedule() async {
    debugPrint('🎯 SAVE: Button pressed');

    // Validate form
    if (!_formKey.currentState!.validate()) {
      debugPrint('⚠️ SAVE: Form validation failed');
      return;
    }

    // Prevent double tap
    if (_isSavingNotifier.value) {
      debugPrint('⚠️ SAVE: Already saving, ignoring');
      return;
    }

    // Start loading
    if (!mounted) return;
    _isSavingNotifier.value = true;
    debugPrint('🔄 SAVE: Loading started');

    try {
      // Get provider
      final provider = Provider.of<ItineraryProvider>(context, listen: false);

      final date = _selectedDateNotifier.value;
      final time = _selectedTimeNotifier.value;

      // Create schedule object
      final combinedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      final schedule = ScheduleEntity(
        id: widget.schedule?.id ?? Uuid().v4(),
        title: _titleController.text.trim(),
        location: _locationController.text.trim(),
        date: combinedDateTime,
        time: time.format(context),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        imageUrl: widget.schedule?.imageUrl,
        createdAt: widget.schedule?.createdAt ?? DateTime.now(),
      );

      debugPrint('📦 SAVE: Schedule created - ${schedule.title}');

      // Call provider with timeout protection
      bool success;
      if (widget.schedule != null) {
        debugPrint('🔄 SAVE: Calling UPDATE with 10s timeout...');
        success = await provider
            .updateSchedule(schedule)
            .timeout(
              Duration(seconds: 10),
              onTimeout: () {
                debugPrint('⏱️ SAVE: TIMEOUT after 10 seconds!');
                throw TimeoutException('Save took too long');
              },
            );
      } else {
        debugPrint('➕ SAVE: Calling ADD with 10s timeout...');
        success = await provider
            .addSchedule(schedule)
            .timeout(
              Duration(seconds: 10),
              onTimeout: () {
                debugPrint('⏱️ SAVE: TIMEOUT after 10 seconds!');
                throw TimeoutException('Save took too long');
              },
            );
      }

      debugPrint('📊 SAVE: Provider returned: $success');

      // ALWAYS stop loading
      if (mounted) {
        _isSavingNotifier.value = false;
        debugPrint('⏹️ SAVE: Loading stopped');
      }

      // Handle result
      if (success) {
        debugPrint('✅ SAVE: Success! Showing message');

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.schedule != null
                          ? 'Schedule updated successfully!'
                          : 'Schedule added successfully!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(16),
            ),
          );

          // Wait briefly then navigate back
          await Future.delayed(Duration(milliseconds: 300));

          if (mounted) {
            debugPrint('⬅️ SAVE: Navigating back');
            Navigator.of(context).pop(true);
          }
        }
      } else {
        debugPrint('❌ SAVE: Provider returned false');
        if (mounted) {
          _showErrorDialog('Failed to save schedule. Please try again.');
        }
      }
    } on TimeoutException catch (e) {
      debugPrint('⏱️ SAVE: Caught timeout - $e');

      if (mounted) {
        _isSavingNotifier.value = false;
        _showErrorDialog('Request timed out. Check your internet connection.');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 SAVE: Exception - $e');
      debugPrint('Stack: $stackTrace');

      if (mounted) {
        _isSavingNotifier.value = false;
        _showErrorDialog('An error occurred: ${e.toString()}');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.accentRed, size: 24),
            SizedBox(width: 12),
            Text('Error', style: AppTextStyles.semibold(context, 18)),
          ],
        ),
        content: Text(message, style: AppTextStyles.regular(context, 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'OK',
              style: AppTextStyles.semibold(
                context,
                14,
              ).copyWith(color: AppColors.primaryOrange),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.schedule != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(20)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(56)),

                _buildAppBar(context, isEditing),

                SizedBox(height: context.h(30)),

                _buildLabel("Title*"),
                SizedBox(height: context.h(8)),
                _buildTextField(
                  controller: _titleController,
                  hint: "E.g., Visit Eiffel Tower",
                  icon: Icons.title,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),

                SizedBox(height: context.h(20)),

                _buildLabel("Location*"),
                SizedBox(height: context.h(8)),
                _buildTextField(
                  controller: _locationController,
                  hint: "E.g., Paris, France",
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),

                SizedBox(height: context.h(20)),

                _buildLabel("Date*"),
                SizedBox(height: context.h(8)),
                ValueListenableBuilder<DateTime>(
                  valueListenable: _selectedDateNotifier,
                  builder: (context, date, child) {
                    return _buildDateTimeSelector(
                      icon: Icons.calendar_today,
                      text: DateFormat('EEEE, MMMM d, y').format(date),
                      onTap: _selectDate,
                    );
                  },
                ),

                SizedBox(height: context.h(20)),

                _buildLabel("Time*"),
                SizedBox(height: context.h(8)),
                ValueListenableBuilder<TimeOfDay>(
                  valueListenable: _selectedTimeNotifier,
                  builder: (context, time, child) {
                    return _buildDateTimeSelector(
                      icon: Icons.access_time,
                      text: time.format(context),
                      onTap: _selectTime,
                    );
                  },
                ),

                SizedBox(height: context.h(20)),

                _buildLabel("Notes (Optional)"),
                SizedBox(height: context.h(8)),
                _buildTextField(
                  controller: _notesController,
                  hint: "Add any additional notes...",
                  icon: Icons.notes,
                  maxLines: 4,
                ),

                SizedBox(height: context.h(40)),

                _buildSaveButton(context, isEditing),

                SizedBox(height: context.h(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isEditing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppBarIconWidget(
          icon: MyAssets.backicon,
          onTap: () => Navigator.pop(context),
        ),
        Text(
          isEditing ? "Edit Schedule" : "Add Schedule",
          style: AppTextStyles.semibold(
            context,
            18,
          ).copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(width: context.w(44)),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.semibold(
        context,
        16,
      ).copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.regular(
        context,
        15,
      ).copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.regular(
          context,
          15,
        ).copyWith(color: AppColors.textSecondary.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.backgroundGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.w(12)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.w(12)),
          borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.w(12)),
          borderSide: BorderSide(color: AppColors.accentRed, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(16),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDateTimeSelector({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSavingNotifier,
      builder: (context, isSaving, _) {
        return GestureDetector(
          onTap: isSaving ? null : onTap,
          child: Container(
            height: context.h(56),
            padding: EdgeInsets.symmetric(horizontal: context.w(16)),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(context.w(12)),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary, size: context.w(20)),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.regular(
                      context,
                      15,
                    ).copyWith(color: AppColors.textPrimary),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: context.w(16),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isEditing) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSavingNotifier,
      builder: (context, isSaving, _) {
        return GestureDetector(
          onTap: isSaving ? null : _saveSchedule,
          child: Container(
            width: double.infinity,
            height: context.h(56),
            decoration: BoxDecoration(
              color: isSaving
                  ? AppColors.textSecondary.withValues(alpha: 0.6)
                  : AppColors.underlineOrange,
              borderRadius: BorderRadius.circular(context.w(16)),
              boxShadow: isSaving
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.shadowOrange,
                        blurRadius: 15,
                        offset: Offset(0, 4),
                      ),
                    ],
            ),
            child: Center(
              child: isSaving
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: context.w(20),
                          height: context.h(20),
                          child: CircularProgressIndicator(
                            color: AppColors.backgroundWhite,
                            strokeWidth: 2.5,
                          ),
                        ),
                        SizedBox(width: context.w(12)),
                        Text(
                          'Saving...',
                          style: AppTextStyles.semibold(
                            context,
                            16,
                          ).copyWith(color: AppColors.backgroundWhite),
                        ),
                      ],
                    )
                  : Text(
                      isEditing ? "Update Schedule" : "Save Schedule",
                      style: AppTextStyles.semibold(
                        context,
                        16,
                      ).copyWith(color: AppColors.backgroundWhite),
                    ),
            ),
          ),
        );
      },
    );
  }
}
