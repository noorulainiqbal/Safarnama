// features/translator/domain/usecases/translate_text.dart

import '../entities/translation_entity.dart';
import '../repository/translation_repository.dart';

class TranslateText {
  final TranslationRepository repository;

  TranslateText(this.repository);

  Future<Translation> call({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    if (text.trim().isEmpty) {
      throw Exception('Text cannot be empty');
    }

    return await repository.translate(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }
}
