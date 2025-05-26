import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/utils/constants/colors.dart';

class ArtAssistantScreen extends StatefulWidget {
  const ArtAssistantScreen({super.key});

  @override
  State<ArtAssistantScreen> createState() => _ArtAssistantScreenState();
}

class _ArtAssistantScreenState extends State<ArtAssistantScreen> {
  final _controller = ChatMessagesController();
  final _currentUser = ChatUser(id: 'user', firstName: 'Tú');
  final _aiUser = ChatUser(id: 'ai', firstName: 'Asistente de Arte');
  late final GenerativeModel _model;
  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    const apiKey = 'AIzaSyACIqyFr4GUnU70u0uuBAST89m5muA_RCM';
    _model = GenerativeModel(
      model: 'gemini-1.5-pro-latest',
      apiKey: apiKey,
    );

    _controller.addMessage(ChatMessage(
      text:
          "¡Hola! Soy tu asistente de arte. Puedes preguntarme sobre: Historia del arte, Pintura, Escultura, Arquitectura, Movimientos artísticos, Artistas famosos, Técnicas artísticas.",
      user: _aiUser,
      createdAt: DateTime.now(),
    ));

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    _controller.addMessage(message);

    final prompt = '''
Eres un asistente especializado en arte. Responde solo sobre:
- Historia del arte
- Pintura, escultura, arquitectura
- Movimientos artísticos
- Artistas famosos
- Técnicas artísticas

Si la pregunta no es de arte, responde:
"Soy un asistente de arte. ¿Puedo ayudarte con algo relacionado a pintura, escultura u otros temas artísticos?"

Pregunta: ${message.text}
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final reply = response.text?.trim() ?? 'No se pudo generar respuesta.';

      _controller.addMessage(ChatMessage(
        text: reply,
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ));
    } catch (err) {
      _controller.addMessage(ChatMessage(
        text: "Error al generar la respuesta: ${err.toString()}",
        user: _aiUser,
        createdAt: DateTime.now(),
      ));
    } finally {
      setState(() => _isLoading = false);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Asistente de Arte'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: isDarkMode ? TColors.blakfondo : Colors.white,
        child: Column(
          children: [
            Expanded(
              child: AiChatWidget(
                currentUser: _currentUser,
                aiUser: _aiUser,
                controller: _controller,
                onSendMessage: _handleSendMessage,
                loadingConfig: LoadingConfig(isLoading: _isLoading),
                inputOptions: InputOptions(
                  sendOnEnter: true,
                  unfocusOnTapOutside: true,
                  textController: _textController,
                  decoration: InputDecoration(
                    hintText: 'Pregunta sobre arte...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF333333)  // Color de fondo para el modo oscuro
                        : const Color(0xFFE0E0E0),  // Color de fondo para el modo claro
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),

                welcomeMessageConfig: const WelcomeMessageConfig(
                  title: '',
                  questionsSectionTitle: '',
                ),
                exampleQuestions: const [],
                persistentExampleQuestions: false,
                messageOptions: MessageOptions(
                  showTime: false,
                  showUserName: true,
                  bubbleStyle: BubbleStyle(
                    userBubbleColor: isDarkMode
                        ? const Color.fromARGB(255, 134, 175, 221).withOpacity(0.3)
                        : Colors.blue[100]!,
                    aiBubbleColor:
                        isDarkMode ? const Color.fromARGB(255, 36, 36, 36): Colors.white,
                    userNameColor:
                        isDarkMode ? Colors.blue[200]! : Colors.blue[700]!,
                    aiNameColor:
                        isDarkMode ? Colors.purple[200]! : Colors.purple[700]!,
                    bottomLeftRadius: 12,
                    bottomRightRadius: 12,
                    enableShadow: true,
                  ),
                ),
                enableAnimation: true,
                enableMarkdownStreaming: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
