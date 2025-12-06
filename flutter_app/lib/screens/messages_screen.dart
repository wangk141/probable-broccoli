import 'package:flutter/material.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import '../chat_bubble.dart';
import '../models/message.dart';
import '../message_input.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final ScrollController _scrollController = ScrollController();
  late Box<Message> _messagesBox;

  @override
  void initState() {
    super.initState();
    _messagesBox = Hive.box<Message>('messages');

    if (_messagesBox.isEmpty) {
      _messagesBox.add(Message(
        text: 'Welcome! How can we help today?',
        timestamp: DateTime.now(),
        isUser: false,
      ));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _sendMessage(String text, {String? imagePath}) {
    final msg = Message(
      text: text,
      imagePath: imagePath,
      timestamp: DateTime.now(),
      isUser: true,
    );
    _messagesBox.add(msg);
    _scrollToBottom();
    _simulateAgentReply();
  }

  void _simulateAgentReply() async {
    final replies = [
      "Thanks — I'll look into that.",
      "Can you share more details?",
      "Great question! Here's what I found.",
      "I'm forwarding to support; expect an update soon."
    ];
    await Future.delayed(
      Duration(seconds: 1 + (DateTime.now().millisecondsSinceEpoch % 3)),
    );
    final reply = replies[DateTime.now().millisecondsSinceEpoch % replies.length];
    final msg = Message(
      text: reply,
      timestamp: DateTime.now(),
      isUser: false,
    );
    _messagesBox.add(msg);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearMessages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Messages'),
        content: const Text('Delete all messages?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.indigo[400],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.indigo[400]!),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    while (_messagesBox.length > 1) {
                      _messagesBox.deleteAt(_messagesBox.length - 1);
                    }
                    Navigator.pop(context);
                    _scrollToBottom();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Support Chat', style: TextStyle(color: Colors.white)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: 'Clear Messages',
            onPressed: _clearMessages,
          ),
          IconButton(
            icon: const Icon(Icons.dashboard, color: Colors.white),
            tooltip: 'Open Internal Tools',
            onPressed: () => Navigator.pushNamed(context, '/dashboard'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _messagesBox.listenable(),
              builder: (context, Box<Message> box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text('No messages yet'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: box.length,
                  itemBuilder: (ctx, i) {
                    final m = box.getAt(i)!;
                    final time = DateFormat.jm().format(m.timestamp);
                    return Column(
                      crossAxisAlignment: m.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (m.imagePath != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(m.imagePath!),
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ChatBubble(text: m.text, isMine: m.isUser, time: time),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          MessageInput(onSend: _sendMessage),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}