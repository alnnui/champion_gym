import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({required this.text, required this.isUser, required this.timestamp});
}

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({Key? key}) : super(key: key);

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  // Замените на ваш API ключ OpenAI
  static const String _apiKey = 'YOUR_OPENAI_API_KEY';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
    _addDailyReminder();
  }

  void _addWelcomeMessage() {
    _messages.add(
      Message(
        text:
            'Привет! Я ваш персональный фитнес-ассистент. Я помогу вам с тренировками, питанием и достижением целей. Что вас интересует?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _addDailyReminder() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Проверяем, было ли уже напоминание сегодня
    final hasReminderToday = _messages.any(
      (msg) =>
          !msg.isUser &&
          msg.text.contains('Ежедневное напоминание') &&
          msg.timestamp.isAfter(today),
    );

    if (!hasReminderToday) {
      _messages.add(
        Message(
          text: _generateDailyReminder(),
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  String _generateDailyReminder() {
    final now = DateTime.now();
    final hour = now.hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Доброе утро!';
    } else if (hour < 18) {
      greeting = 'Добрый день!';
    } else {
      greeting = 'Добрый вечер!';
    }

    return '''$greeting 🌟

Ежедневное напоминание:

💪 Тренировки:
• Не забудьте про тренировку сегодня
• Ваша цель: 3 тренировки в неделю
• Текущий прогресс: 2/3 тренировки

🥗 Питание:
• Пейте больше воды (2-3 литра в день)
• Следите за белком в рационе
• Не пропускайте завтрак

🎯 Цели:
• Целевой вес: 70 кг
• Текущий вес: 75 кг
• Осталось сбросить: 5 кг

Хотите получить персональные советы по тренировкам или питанию?''';
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(
        Message(text: message, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _getAIResponse(message);
      setState(() {
        _messages.add(
          Message(text: response, isUser: false, timestamp: DateTime.now()),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          Message(
            text: 'Извините, произошла ошибка. Попробуйте позже.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  Future<String> _getAIResponse(String message) async {
    // Если API ключ не настроен, используем мок-ответы
    if (_apiKey == 'YOUR_OPENAI_API_KEY') {
      return _getMockResponse(message);
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  '''Ты персональный фитнес-ассистент. Твоя задача - помогать пользователям с тренировками, питанием и достижением фитнес-целей. 
              
              Ты должен:
              - Давать конкретные и практичные советы
              - Учитывать уровень подготовки пользователя
              - Рекомендовать безопасные упражнения
              - Помогать с планированием тренировок
              - Давать советы по питанию
              - Мотивировать и поддерживать
              
              Отвечай кратко, но информативно. Используй эмодзи для лучшего восприятия.''',
            },
            {'role': 'user', 'content': message},
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('API request failed');
      }
    } catch (e) {
      return _getMockResponse(message);
    }
  }

  String _getMockResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('привет') ||
        lowerMessage.contains('здравствуй')) {
      return 'Привет! 👋 Рад вас видеть! Как ваши тренировки? Есть ли вопросы по фитнесу?';
    }

    if (lowerMessage.contains('тренировка') ||
        lowerMessage.contains('упражнение')) {
      return '''💪 Отличный вопрос о тренировках!

Вот несколько советов:

🏋️ Силовые тренировки:
• 3-4 раза в неделю
• 8-12 повторений
• 3-4 подхода
• Отдых 1-2 минуты

🏃 Кардио:
• 20-30 минут
• 3-4 раза в неделю
• Пульс 120-140 уд/мин

Хотите получить персональную программу тренировок?''';
    }

    if (lowerMessage.contains('питание') ||
        lowerMessage.contains('еда') ||
        lowerMessage.contains('диета')) {
      return '''🥗 Питание - ключ к успеху!

Основные принципы:

🍗 Белок: 1.6-2.2г на кг веса
🥑 Жиры: 20-35% от калорий
🍞 Углеводы: остальные калории

📋 Рекомендации:
• Ешьте каждые 3-4 часа
• Пейте 2-3 литра воды
• Не пропускайте завтрак
• Ешьте овощи с каждым приемом пищи

Нужна помощь с расчетом калорий?''';
    }

    if (lowerMessage.contains('похудение') ||
        lowerMessage.contains('сбросить вес')) {
      return '''🎯 Похудение - это процесс!

Советы для эффективного похудения:

⚖️ Дефицит калорий: -300-500 ккал
🏃 Кардио: 3-4 раза в неделю
💪 Силовые: 2-3 раза в неделю
😴 Сон: 7-9 часов
🚰 Вода: 2-3 литра

📊 Ваш прогресс:
• Цель: 70 кг
• Текущий: 75 кг
• Осталось: 5 кг

Продолжайте в том же духе! 💪''';
    }

    if (lowerMessage.contains('мотивация') || lowerMessage.contains('устал')) {
      return '''🔥 Мотивация - это навык!

Вот что поможет:

💭 Визуализируйте результат
📈 Отслеживайте прогресс
🎯 Ставьте маленькие цели
👥 Найдите партнера по тренировкам
🎵 Слушайте энергичную музыку

Помните: каждый день - это новая возможность стать лучше! 

Что вас мотивирует больше всего?''';
    }

    return '''🤖 Я ваш персональный фитнес-ассистент!

Могу помочь с:
💪 Программами тренировок
🥗 Советами по питанию
🎯 Постановкой целей
📊 Отслеживанием прогресса
🔥 Мотивацией

Задайте любой вопрос о фитнесе!''';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.smart_toy,
                color: AppColors.textAlternative,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'ИИ Ассистент',
              style: GoogleFonts.delaGothicOne(
                fontSize: 18.sp,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.text),
            onPressed: () {
              setState(() {
                _messages.clear();
                _addWelcomeMessage();
                _addDailyReminder();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Сообщения
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),

          // Индикатор загрузки
          if (_isLoading)
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.smart_toy,
                      color: AppColors.textAlternative,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Печатает...',
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 14.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Поле ввода
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.backgroundComplimentary,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16.sp,
                      fontFamily: 'Gilroy',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Задайте вопрос...',
                      hintStyle: TextStyle(
                        color: AppColors.textComplimentary,
                        fontFamily: 'Gilroy',
                      ),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: Icon(
                      Icons.send,
                      color: AppColors.textAlternative,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.smart_toy,
                color: AppColors.textAlternative,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? AppColors.primary
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: message.isUser
                        ? null
                        : Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? AppColors.textAlternative
                          : AppColors.text,
                      fontSize: 16.sp,
                      fontFamily: 'Gilroy',
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    color: AppColors.textComplimentary,
                    fontSize: 12.sp,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 12.w),
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.person,
                color: AppColors.textAlternative,
                size: 20.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day.toString().padLeft(2, '0')}.${timestamp.month.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

