import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class MessageInput extends StatefulWidget {
  final void Function(String, {String? imagePath}) onSend;
  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _ctrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _showEmojiPicker = false;

  void _handleSend() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _ctrl.clear();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.onSend('Image', imagePath: image.path);
    }
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined),
                  onPressed: _toggleEmojiPicker,
                  color: Colors.grey[600],
                ),
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: _pickImage,
                  color: Colors.grey[600],
                ),
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.indigo[400],
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _handleSend,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _ctrl.text += emoji.emoji;
              },
              config: const Config(
                columns: 7,
                emojiSizeMax: 32,
              ),
            ),
          ),
      ],
    );
  }
}