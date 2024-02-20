// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResumeSectionAdapter extends TypeAdapter<ResumeSection> {
  @override
  final int typeId = 0;

  @override
  ResumeSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResumeSection(
      title: fields[0] as String,
      content: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ResumeSection obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
