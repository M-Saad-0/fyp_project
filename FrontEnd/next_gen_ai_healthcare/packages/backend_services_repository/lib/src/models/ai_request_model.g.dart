// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AiRequestModelAdapter extends TypeAdapter<AiRequestModel> {
  @override
  final int typeId = 0;

  @override
  AiRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AiRequestModel(
      query: fields[0] as String,
      image: fields[1] as String?,
      date: fields[3] as String,
      reponse: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AiRequestModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.reponse)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
