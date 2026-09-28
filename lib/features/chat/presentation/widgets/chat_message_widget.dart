// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessageEntity message;
  final bool showTimestamp;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.showTimestamp = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: message.isUserMessage
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (showTimestamp && message.timestamp != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),

        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.isUserMessage
                ? const Color(0xFF007AFF)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUserMessage)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFFFF7029),
                      child: Icon(
                        Icons.travel_explore,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cultural Guide',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 8),

              if (message.isUserMessage)
                Text(
                  message.message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                )
              else
                MarkdownBody(
                  data: message.response,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                    h1: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    h2: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    h3: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    strong: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF7029),
                    ),
                    em: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                    blockquote: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontStyle: FontStyle.italic,
                    ),

                    blockquoteDecoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border(
                        left: BorderSide(color: Color(0xFFFF7029), width: 4),
                      ),
                    ),

                    blockquotePadding: const EdgeInsets.all(12),
                    listBullet: TextStyle(color: const Color(0xFFFF7029)),
                    code: TextStyle(
                      backgroundColor: Colors.grey[100],
                      color: Colors.grey[800],
                      fontFamily: 'monospace',
                    ),
                  ),
                ),

              if (message.location != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: message.isUserMessage
                            ? Colors.white70
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        message.location!,
                        style: TextStyle(
                          fontSize: 12,
                          color: message.isUserMessage
                              ? Colors.white70
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
