import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  final OnDeviceTranslator _translator;
  final _modelManager = OnDeviceTranslatorModelManager();

  TranslationService({
    required this.sourceLanguage,
    TranslateLanguage? targetLanguage,
  })  : targetLanguage = targetLanguage ?? TranslateLanguage.english,
        _translator = OnDeviceTranslator(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage ?? TranslateLanguage.english,
        );

  Future<bool> downloadSourceAndTargetModels() async {
    try {
      if (!await isModelDownloaded(bcpCode: sourceLanguage.bcpCode)) {
        return await _modelManager.downloadModel(sourceLanguage.bcpCode);
      }

      if (!await isModelDownloaded(bcpCode: targetLanguage.bcpCode)) {
        return await _modelManager.downloadModel(targetLanguage.bcpCode);
      }

      return true;
    } catch (e) {
      print('Error downloading models: $e');
      return false;
    }
  }

  Future<bool> downloadModel({String bcpCode = "en"}) async {
    return await _modelManager.downloadModel(bcpCode);
  }

  Future<bool> deleteModel({String bcpCode = "en"}) async {
    return await _modelManager.deleteModel(bcpCode);
  }

  Future<void> close() async {
    await _translator.close();
  }

  Future<bool> isModelDownloaded({String bcpCode = 'en'}) async {
    return await _modelManager.isModelDownloaded(bcpCode);
  }

  Future<String> translateText(String text) async {
    return await _translator.translateText(text);
  }
}
