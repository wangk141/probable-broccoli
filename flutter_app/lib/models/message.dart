import 'package:hive/hive.dart';

class Message {
  final String text;
  final String? imagePath;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.text,
    this.imagePath,
    required this.isUser,
    required this.timestamp,
  });
}

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 0;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      text: fields[0] as String,
      imagePath: fields[1] as String?,
      isUser: fields[2] as bool,
      timestamp: DateTime.fromMillisecondsSinceEpoch(fields[3] as int),
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.isUser)
      ..writeByte(3)
      ..write(obj.timestamp.millisecondsSinceEpoch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MessageAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}