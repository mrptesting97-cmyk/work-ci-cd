import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIRemoteDataSource {
  GenerativeModel? _model;
  ChatSession? _chat;

  GenerativeModel _getModel() {
    if (_model != null) return _model!;
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    // Debug check
    if (apiKey.isEmpty) {}

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content('system', [
        TextPart(
          'You are an AI assistant embedded inside a property hosting app. '
          'Help hosts list their properties, suggest pricing, autofill form fields, and give tips. '
          'Be concise, friendly, and practical. '
          'If the user asks you to fill/autofill a form, respond with a JSON block inside ```json ``` '
          'with keys: title, rooms, type, description, amenities, price. '
          'Outside the JSON block, add a short friendly message.',
        ),
      ]),
    );
    return _model!;
  }

  ChatSession _getChat() {
    _chat ??= _getModel().startChat();
    return _chat!;
  }

  Future<Map<String, dynamic>> getAiResponse({
    required String query,
    required String screenContext,
    required Map<dynamic, dynamic> formData,
  }) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        return {
          'message':
              'API Error: GEMINI_API_KEY is missing from .env file. Please add it and restart the app.',
        };
      }

      final prompt = screenContext.isNotEmpty
          ? 'Context: User is on "$screenContext" screen. Current Form: $formData. User says: $query'
          : query;

      // final response = await _getChat().sendMessage(Content.text(prompt));
      final response = await _getChat()
          .sendMessage(Content.text(prompt))
          .timeout(const Duration(seconds: 30));
      final rawText = response.text ?? '';

      final jsonMatch = RegExp(
        r'```json\s*([\s\S]*?)\s*```',
      ).firstMatch(rawText);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(1) ?? '';
        final message = rawText.replaceAll(jsonMatch.group(0)!, '').trim();
        return {
          'message': message.isNotEmpty
              ? message
              : "I've updated the form for you.",
          'action': 'autofill',
          'data': _parseSimpleJson(jsonStr),
        };
      }

      return {'message': rawText};
    } catch (e) {
      return {
        'message':
            'API Error: $e\n\nTips: Check your internet connection or verify your API key in the .env file.',
      };
    }
  }

  Map<String, dynamic> _parseSimpleJson(String json) {
    final result = <String, dynamic>{};
    try {
      final title = RegExp(r'"title"\s*:\s*"([^"]*)"').firstMatch(json);
      if (title != null) result['title'] = title.group(1);

      final rooms = RegExp(r'"rooms"\s*:\s*(\d+)').firstMatch(json);
      if (rooms != null) result['rooms'] = int.tryParse(rooms.group(1)!);

      final type = RegExp(r'"type"\s*:\s*"([^"]*)"').firstMatch(json);
      if (type != null) result['type'] = type.group(1);

      final desc = RegExp(r'"description"\s*:\s*"([^"]*)"').firstMatch(json);
      if (desc != null) result['description'] = desc.group(1);

      final price = RegExp(r'"price"\s*:\s*([\d.]+)').firstMatch(json);
      if (price != null) result['price'] = double.tryParse(price.group(1)!);
    } catch (_) {}
    return result;
  }
}
