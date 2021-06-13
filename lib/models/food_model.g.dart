// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodModelAdapter extends TypeAdapter<FoodModel> {
  @override
  final int typeId = 1;

  @override
  FoodModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodModel(
      cafeId: fields[0] as String,
      cafeDostavkaTime: fields[9] as int,
      cafeSkidka: fields[10] as int,
      quantity: fields[3] as int,
      cafeTitle: fields[1] as String,
      id: fields[2] as String,
      time: fields[6] as String,
      title: fields[4] as String,
      imageUrl: fields[5] as String,
      discount: fields[7] as int,
      isFavorite: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FoodModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.cafeId)
      ..writeByte(1)
      ..write(obj.cafeTitle)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.discount)
      ..writeByte(8)
      ..write(obj.isFavorite)
      ..writeByte(9)
      ..write(obj.cafeDostavkaTime)
      ..writeByte(10)
      ..write(obj.cafeSkidka);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
