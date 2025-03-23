// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatsAdapter extends TypeAdapter<Chats> {
  @override
  final int typeId = 1;

  @override
  Chats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chats(
      allChatsPerDay: (fields[0] as List).cast<AiRequestModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, Chats obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.allChatsPerDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
