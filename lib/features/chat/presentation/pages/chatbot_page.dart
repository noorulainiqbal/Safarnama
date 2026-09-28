// ignore_for_file: avoid_print

import 'dart:ui';
import '../../domain/entities/chat_message_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../provider/chatbot_provider.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/chat_history_modal.dart';
import '../../../../l10n/app_localizations.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ChatbotProvider>(context, listen: false);
      provider.initialize();

      // Add listener to provider to auto-scroll on new messages
      provider.addListener(_scrollToBottom);
    });
  }

  @override
  void dispose() {
    final provider = Provider.of<ChatbotProvider>(context, listen: false);
    provider.removeListener(_scrollToBottom);
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // Scroll to top since ListView is reversed
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final provider = Provider.of<ChatbotProvider>(context, listen: false);

    // Send message
    provider
        .sendMessage(message)
        .then((_) {
          // Scroll to bottom after message is sent
          _scrollToBottom();
        })
        .catchError((error) {
          print('Error sending message: $error');
        });

    // Clear input and unfocus
    _messageController.clear();
    _focusNode.unfocus();

    // Scroll immediately to show user message
    _scrollToBottom();
  }

  void _showHistoryModal() {
    showDialog(
      context: context,
      builder: (context) => const ChatHistoryModal(),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearChatDialogTitle),
        content: Text(AppLocalizations.of(context)!.clearChatDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final provider = Provider.of<ChatbotProvider>(
                context,
                listen: false,
              );
              provider.clearChatHistory();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.clear),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatbotProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(context),

                // Error Message
                if (provider.error != null)
                  Container(
                    padding: EdgeInsets.all(context.w(12)),
                    margin: EdgeInsets.symmetric(
                      horizontal: context.w(16),
                      vertical: context.h(8),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                          size: context.sp(20),
                        ),
                        SizedBox(width: context.w(8)),
                        Expanded(
                          child: Text(
                            provider.error!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: context.sp(14),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: context.sp(16)),
                          onPressed: provider.clearError,
                        ),
                      ],
                    ),
                  ),

                // Chat Messages
                Expanded(
                  child: provider.isLoading && provider.messages.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF7029),
                          ),
                        )
                      : provider.messages.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(context.w(16)),
                          reverse: true,
                          itemCount: provider.messages.length,
                          itemBuilder: (context, index) {
                            final message = provider.messages[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: context.h(16)),
                              child: ChatMessageWidget(
                                message: message,
                                showTimestamp:
                                    index == 0 ||
                                    _shouldShowTimestamp(
                                      provider.messages,
                                      index,
                                    ),
                              ),
                            );
                          },
                        ),
                ),

                // Input Area
                _buildInputArea(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.h(56),
        left: context.w(20),
        right: context.w(20),
        bottom: context.h(20),
      ),
      child: SizedBox(
        width: context.w(335),
        height: context.h(44),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _appBarIcon(context, MyAssets.backicon, () {
              Navigator.pop(context);
            }),
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.chatTitle,
                  style: TextStyle(
                    fontFamily: "SF UI Display",
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(18),
                    height: 22 / 18,
                    color: const Color(0xFF1B1E28),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _appBarIcon(
                  context,
                  'assets/icons/history.png',
                  _showHistoryModal,
                ),
                SizedBox(width: context.w(8)),
                _appBarIcon(
                  context,
                  'assets/icons/clear.png',
                  _showClearConfirmation,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBarIcon(BuildContext context, String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: context.w(44),
            height: context.h(44),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image.asset(
                icon,
                width: context.w(24),
                height: context.h(24),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.w(32)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: context.w(120),
            height: context.h(120),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.travel_explore,
              size: 64,
              color: Colors.white,
            ),
          ),
          SizedBox(height: context.h(32)),
          Text(
            //             'Welcome to Cultural Guide!',
            AppLocalizations.of(context)!.welcomeChatTitle,
            style: TextStyle(
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w600,
              fontSize: context.sp(24),
              color: const Color(0xFF1B1E28),
            ),
          ),
          SizedBox(height: context.h(16)),
          Text(
            //             'I\'m your personal cultural tour guide and storyteller. '
            //             'Tell me which tourist attraction you\'d like to explore, '
            //             'and I\'ll create an immersive travel narrative just for you.',
            AppLocalizations.of(context)!.welcomeChatSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.sp(16),
              color: const Color(0xFF7D848D),
              height: 1.5,
            ),
          ),
          SizedBox(height: context.h(32)),
          Container(
            padding: EdgeInsets.all(context.w(16)),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.tryAskingAbout,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(16),
                    color: const Color(0xFF1B1E28),
                  ),
                ),
                SizedBox(height: context.h(12)),
                Wrap(
                  spacing: context.w(8),
                  runSpacing: context.h(8),
                  children: [
                    _buildExampleChip('Lahore Fort', context),
                    _buildExampleChip('Grand Canyon', context),
                    _buildExampleChip('Eiffel Tower', context),
                    _buildExampleChip('Taj Mahal', context),
                    _buildExampleChip('Great Wall', context),
                    _buildExampleChip('Machu Picchu', context),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: context.h(32)),
          Text(
            //             'I\'ll provide:\n'
            //             '• Immersive travel narratives\n'
            //             '• Fun facts and cultural insights\n'
            //             '• Local customs and etiquette\n'
            //             '• Must-see spots and hidden gems',
            AppLocalizations.of(context)!.chatFeaturesList,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.sp(14),
              color: const Color(0xFF7D848D),
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleChip(String text, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(12),
          vertical: context.h(8),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: context.sp(14),
            color: const Color(0xFF1B1E28),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ChatbotProvider provider) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(8),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      style: TextStyle(
                        fontSize: context.sp(16),
                        color: const Color(0xFF1B1E28),
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.chatHint,
                        hintStyle: TextStyle(
                          color: const Color(0xFF7D848D),
                          fontSize: context.sp(16),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: 3,
                      minLines: 1,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  if (provider.isSending)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: const Color(0xFFFF7029),
                      ),
                    )
                  else
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: const Color(0xFFFF7029),
                        size: context.sp(24),
                      ),
                      onPressed: _sendMessage,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowTimestamp(List<ChatMessageEntity> messages, int index) {
    if (index == 0) return true;

    final current = messages[index].timestamp;
    final previous = messages[index - 1].timestamp;

    return current.difference(previous).inMinutes >= 5;
  }
}
