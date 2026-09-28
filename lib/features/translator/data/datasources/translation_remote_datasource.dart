import 'package:translator/translator.dart';
import '../models/translation_model.dart';

abstract class TranslationRemoteDataSource {
  Future<TranslationModel> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });
}

class TranslationRemoteDataSourceImpl implements TranslationRemoteDataSource {
  final GoogleTranslator _translator = GoogleTranslator();

  TranslationRemoteDataSourceImpl({
    required dynamic client,
  }); // Client no longer needed but kept for DI compatibility if needed, or can be removed if DI allows

  @override
  Future<TranslationModel> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final translation = await _translator.translate(
        text,
        from: _getLanguageCode(sourceLanguage),
        to: _getLanguageCode(targetLanguage),
      );

      return TranslationModel(
        sourceText: text,
        translatedText: translation.text,
        romanization:
            null, // Google translator package doesn't readily provide romanization in the simple result
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    } catch (e) {
      throw Exception('Failed to translate text: $e');
    }
  }

  String _getLanguageCode(String language) {
    final codes = {
      'English': 'en',
      'Korean': 'ko',
      'Spanish': 'es',
      'French': 'fr',
      'German': 'de',
      'Italian': 'it',
      'Portuguese': 'pt',
      'Russian': 'ru',
      'Japanese': 'ja',
      'Chinese': 'zh',
      'Arabic': 'ar',
      'Hindi': 'hi',
      'Turkish': 'tr',
      'Dutch': 'nl',
      'Polish': 'pl',
      'Swedish': 'sv',
      'Danish': 'da',
      'Norwegian': 'no',
      'Finnish': 'fi',
      'Greek': 'el',
    };
    return codes[language] ?? 'en';
  }
}
