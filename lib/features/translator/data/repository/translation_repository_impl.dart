// features/translator/data/repositories/translation_repository_impl.dart

import '../../domain/entities/translation_entity.dart';
import '../../domain/repository/translation_repository.dart';
import '../datasources/translation_remote_datasource.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationRemoteDataSource remoteDataSource;

  TranslationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Translation> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      return await remoteDataSource.translate(
        text: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    } catch (e) {
      throw Exception('Translation failed: $e');
    }
  }

  @override
  List<String> getSupportedLanguages() {
    return [
      'English',
      'Korean',
      'Spanish',
      'French',
      'German',
      'Italian',
      'Portuguese',
      'Russian',
      'Japanese',
      'Chinese',
      'Arabic',
      'Hindi',
      'Turkish',
      'Dutch',
      'Polish',
      'Swedish',
      'Danish',
      'Norwegian',
      'Finnish',
      'Greek',
    ];
  }
}
