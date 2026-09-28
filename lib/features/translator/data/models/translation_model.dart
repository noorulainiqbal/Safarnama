// features/translator/data/models/translation_model.dart

import '../../domain/entities/translation_entity.dart';

class TranslationModel extends Translation {
  TranslationModel({
    required super.sourceText,
    required super.translatedText,
    super.romanization,
    required super.sourceLanguage,
    required super.targetLanguage,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      sourceText: json['sourceText'] ?? '',
      translatedText: json['translatedText'] ?? '',
      romanization: json['romanization'],
      sourceLanguage: json['sourceLanguage'] ?? '',
      targetLanguage: json['targetLanguage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sourceText': sourceText,
      'translatedText': translatedText,
      'romanization': romanization,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
    };
  }
}
