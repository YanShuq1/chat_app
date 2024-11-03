// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shot_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************


class ShotModelAdapter extends TypeAdapter<ShotModel> {
  @override
  final int typeId = 0;

  @override
  ShotModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShotModel(
      imagePath: fields[0] as String,
      avatarPath: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShotModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.imagePath)
      ..writeByte(1)
      ..write(obj.avatarPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShotModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
