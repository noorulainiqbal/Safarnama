// features/translator/domain/entities/translation.dart

class Translation {
  final String sourceText;
  final String translatedText;
  final String? romanization;
  final String sourceLanguage;
  final String targetLanguage;

  Translation({
    required this.sourceText,
    required this.translatedText,
    this.romanization,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}
