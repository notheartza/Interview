// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_api_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusAPIMap _$StatusAPIMapFromJson(Map<String, dynamic> json) {
  return StatusAPIMap(
    json['status'] as int,
    json['message'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$StatusAPIMapToJson(StatusAPIMap instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
