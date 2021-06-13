// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cafe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CafeModelAdapter extends TypeAdapter<CafeModel> {
  @override
  final int typeId = 0;

  @override
  CafeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CafeModel(
      id: fields[0] as String,
      time: fields[3] as int,
      title: fields[1] as String,
      imageUrl: fields[2] as String,
      discount: fields[4] as int,
      rating: fields[5] as double,
      isFavorite: fields[6] as bool,
      chosenKuhni: (fields[7] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CafeModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.chosenKuhni);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CafeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
