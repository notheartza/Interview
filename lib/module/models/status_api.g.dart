// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusAPI _$StatusAPIFromJson(Map<String, dynamic> json) {
  return StatusAPI(
    json['status'] as int,
    json['message'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$StatusAPIToJson(StatusAPI instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
