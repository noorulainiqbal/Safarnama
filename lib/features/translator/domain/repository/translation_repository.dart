// features/translator/domain/repositories/translation_repository.dart

import '../entities/translation_entity.dart';

abstract class TranslationRepository {
  Future<Translation> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });

  List<String> getSupportedLanguages();
}
