// features/translator/presentation/providers/translator_provider.dart

import 'package:flutter/material.dart';
import '../../domain/entities/translation_entity.dart';
import '../../domain/usecases/translate_text.dart';
import '../../domain/repository/translation_repository.dart';

class TranslatorProvider extends ChangeNotifier {
  final TranslateText translateTextUseCase;
  final TranslationRepository repository;

  TranslatorProvider({
    required this.translateTextUseCase,
    required this.repository,
  });

  // Controllers
  final TextEditingController sourceTextController = TextEditingController();

  // State
  Translation? _currentTranslation;
  bool _isLoading = false;
  String? _errorMessage;
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Korean';
  List<String> _supportedLanguages = [];

  // Getters
  Translation? get currentTranslation => _currentTranslation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get sourceLanguage => _sourceLanguage;
  String get targetLanguage => _targetLanguage;
  List<String> get supportedLanguages => _supportedLanguages;
  String get sourceText => sourceTextController.text;
  bool get hasTranslation => _currentTranslation != null;

  void initialize() {
    _supportedLanguages = repository.getSupportedLanguages();
    notifyListeners();
  }

  void setSourceLanguage(String language) {
    _sourceLanguage = language;
    _clearError();
    notifyListeners();
  }

  void setTargetLanguage(String language) {
    _targetLanguage = language;
    _clearError();
    notifyListeners();
  }

  void swapLanguages() {
    final temp = _sourceLanguage;
    _sourceLanguage = _targetLanguage;
    _targetLanguage = temp;

    // If we have a translation, swap the text
    if (_currentTranslation != null) {
      sourceTextController.text = _currentTranslation!.translatedText;
      _currentTranslation = null;
    }

    _clearError();
    notifyListeners();
  }

  Future<void> translateText() async {
    if (sourceTextController.text.trim().isEmpty) {
      _errorMessage = 'Please enter text to translate';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentTranslation = await translateTextUseCase.call(
        text: sourceTextController.text,
        sourceLanguage: _sourceLanguage,
        targetLanguage: _targetLanguage,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Translation failed. Please try again.';
      _currentTranslation = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSourceText() {
    sourceTextController.clear();
    _currentTranslation = null;
    _clearError();
    notifyListeners();
  }

  void copyToClipboard(String text) {
    // This will be implemented in the widget using Clipboard
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    sourceTextController.dispose();
    super.dispose();
  }
}
