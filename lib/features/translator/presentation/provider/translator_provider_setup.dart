// features/translator/presentation/providers/translator_provider_setup.dart

import 'package:http/http.dart' as http;
import '../../data/datasources/translation_remote_datasource.dart';
import '../../data/repository/translation_repository_impl.dart';
import '../../domain/usecases/translate_text.dart';
import 'translator_provider.dart';

// This function creates the TranslatorProvider with all dependencies
TranslatorProvider createTranslatorProvider() {
  // Create dependencies
  final client = http.Client();
  final remoteDataSource = TranslationRemoteDataSourceImpl(client: client);
  final repository = TranslationRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );
  final translateTextUseCase = TranslateText(repository);

  return TranslatorProvider(
    translateTextUseCase: translateTextUseCase,
    repository: repository,
  );
}
